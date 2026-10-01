-- Spicy Eats: Promotions, Reviews, Earnings ledger, Payouts, Notifications
-- Run AFTER 20260930_01_security_and_orders.sql

-- ============================================================
-- 1. PROMOTIONS
-- ============================================================
create table if not exists public.promotions (
  id              bigint generated always as identity primary key,
  created_at      timestamptz not null default now(),
  restaurant_id   uuid references public.restaurants(rest_uid) on delete cascade,
  title           text not null,
  description     text,
  kind            text not null default 'percent'
                  check (kind in ('percent','fixed','free_delivery','bogo','combo')),
  value           numeric(12,2) not null default 0,
  min_order       numeric(12,2) not null default 0,
  max_discount    numeric(12,2),
  code            text unique,
  banner_image    text,
  starts_at       timestamptz not null default now(),
  ends_at         timestamptz,
  usage_limit     int,
  used_count      int not null default 0,
  per_user_limit  int not null default 1,
  is_active       boolean not null default true
);

create index if not exists promotions_owner_idx
  on public.promotions (restaurant_id, is_active, starts_at desc);

-- ============================================================
-- 2. PROMOTION REDEMPTIONS
-- ============================================================
create table if not exists public.promotion_redemptions (
  id           bigint generated always as identity primary key,
  created_at   timestamptz not null default now(),
  promotion_id bigint not null references public.promotions(id) on delete cascade,
  user_id      uuid not null,
  order_id     bigint references public.orders(id) on delete set null,
  amount       numeric(12,2) not null default 0
);

create index if not exists promotion_redemptions_idx
  on public.promotion_redemptions (promotion_id, user_id);

-- ============================================================
-- 3. REVIEWS (the dashboard "Reviews" card needs real text)
-- ============================================================
create table if not exists public.restaurant_reviews (
  id            bigint generated always as identity primary key,
  created_at    timestamptz not null default now(),
  restaurant_id uuid not null references public.restaurants(rest_uid) on delete cascade,
  user_id       uuid not null,
  order_id      bigint references public.orders(id) on delete set null,
  rating        int2 not null check (rating between 1 and 5),
  body          text,
  reply         text,
  replied_at    timestamptz,
  is_hidden     boolean not null default false
);

create index if not exists restaurant_reviews_idx
  on public.restaurant_reviews (restaurant_id, created_at desc);

-- The app embeds the reviewer's email, which needs a real FK to auth.users.
do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conrelid = 'public.restaurant_reviews'::regclass
      and contype = 'f'
      and conname = 'restaurant_reviews_user_id_fkey'
  ) then
    alter table public.restaurant_reviews
      add constraint restaurant_reviews_user_id_fkey
      foreign key (user_id) references auth.users(id) on delete cascade;
  end if;
end $$;

-- ============================================================
-- 4. EARNINGS LEDGER (dashboard "Total revenue" + payouts)
-- ============================================================
create table if not exists public.restaurant_ledger (
  id            bigint generated always as identity primary key,
  created_at    timestamptz not null default now(),
  restaurant_id uuid not null references public.restaurants(rest_uid) on delete cascade,
  order_id      bigint references public.orders(id) on delete set null,
  entry_type    text not null
                check (entry_type in ('sale','commission','refund','payout','adjustment')),
  gross         numeric(12,2) not null default 0,
  fee           numeric(12,2) not null default 0,
  net           numeric(12,2) not null default 0,
  note          text
);

create index if not exists restaurant_ledger_idx
  on public.restaurant_ledger (restaurant_id, created_at desc);

create table if not exists public.payouts (
  id            bigint generated always as identity primary key,
  created_at    timestamptz not null default now(),
  restaurant_id uuid not null references public.restaurants(rest_uid) on delete cascade,
  amount        numeric(12,2) not null check (amount > 0),
  status        text not null default 'pending'
                check (status in ('pending','processing','paid','failed')),
  method        text,
  reference     text,
  period_start  date,
  period_end    date,
  processed_at  timestamptz
);

-- ============================================================
-- 5. IN-APP NOTIFICATIONS (new order alerts for the restaurant admin)
-- ============================================================
create table if not exists public.restaurant_notifications (
  id            bigint generated always as identity primary key,
  created_at    timestamptz not null default now(),
  restaurant_id uuid not null references public.restaurants(rest_uid) on delete cascade,
  type          text not null,
  title         text not null,
  body          text,
  payload       jsonb not null default '{}'::jsonb,
  is_read       boolean not null default false
);

create index if not exists restaurant_notifications_idx
  on public.restaurant_notifications (restaurant_id, is_read, created_at desc);

-- ============================================================
-- 6. RESTAURANT PROFILE COMPLETENESS
--    The register form collects bank + plan fields that had nowhere to go.
-- ============================================================
alter table public.restaurants
  add column if not exists status text not null default 'pending',
  add column if not exists approved_at timestamptz,
  add column if not exists rejection_reason text,
  add column if not exists is_open boolean not null default true;

alter table public.restaurants drop constraint if exists restaurants_status_check;
alter table public.restaurants add constraint restaurants_status_check
  check (status in ('pending','approved','rejected','suspended'));

-- ============================================================
-- 7. RLS
-- ============================================================
alter table public.promotions            enable row level security;
alter table public.promotion_redemptions enable row level security;
alter table public.restaurant_reviews    enable row level security;
alter table public.restaurant_ledger     enable row level security;
alter table public.payouts               enable row level security;
alter table public.restaurant_notifications enable row level security;

-- Promotions: public can read live ones, the owning restaurant manages them
create policy "promotions_read_live"
  on public.promotions for select to anon, authenticated
  using (
    is_active
    and (now() >= starts_at)
    and (ends_at is null or now() <= ends_at)
  );

create policy "promotions_read_own"
  on public.promotions for select to authenticated
  using (
    restaurant_id in (
      select rest_uid from public.restaurants where user_id = auth.uid()
    )
  );

create policy "promotions_manage_own"
  on public.promotions for all to authenticated
  using (
    restaurant_id in (
      select rest_uid from public.restaurants where user_id = auth.uid()
    )
  )
  with check (
    restaurant_id in (
      select rest_uid from public.restaurants where user_id = auth.uid()
    )
  );

create policy "promotion_redemptions_read"
  on public.promotion_redemptions for select to authenticated
  using (
    user_id = auth.uid()
    or promotion_id in (
      select id from public.promotions
      where restaurant_id in (
        select rest_uid from public.restaurants where user_id = auth.uid()
      )
    )
  );

create policy "promotion_redemptions_insert"
  on public.promotion_redemptions for insert to authenticated
  with check (user_id = auth.uid());

-- Reviews: anyone can read, a customer writes, the restaurant replies
create policy "reviews_read"
  on public.restaurant_reviews for select to anon, authenticated
  using (not is_hidden);

create policy "reviews_insert"
  on public.restaurant_reviews for insert to authenticated
  with check (user_id = auth.uid());

create policy "reviews_reply"
  on public.restaurant_reviews for update to authenticated
  using (
    restaurant_id in (
      select rest_uid from public.restaurants where user_id = auth.uid()
    )
  );

-- Ledger and payouts: restaurant owner only
create policy "ledger_read_own"
  on public.restaurant_ledger for select to authenticated
  using (
    restaurant_id in (
      select rest_uid from public.restaurants where user_id = auth.uid()
    )
  );

create policy "payouts_own"
  on public.payouts for all to authenticated
  using (
    restaurant_id in (
      select rest_uid from public.restaurants where user_id = auth.uid()
    )
  )
  with check (
    restaurant_id in (
      select rest_uid from public.restaurants where user_id = auth.uid()
    )
  );

create policy "notifications_read_own"
  on public.restaurant_notifications for select to authenticated
  using (
    restaurant_id in (
      select rest_uid from public.restaurants where user_id = auth.uid()
    )
  );

create policy "notifications_update_own"
  on public.restaurant_notifications for update to authenticated
  using (
    restaurant_id in (
      select rest_uid from public.restaurants where user_id = auth.uid()
    )
  );

create policy "notifications_insert_service"
  on public.restaurant_notifications for insert to authenticated
  with check (true);

-- ============================================================
-- 8. KEEP THE DERIVED RATING COLUMNS IN SYNC
--    restaurants.average_ratings / total_ratings were hand-set to junk.
-- ============================================================
create or replace function public.refresh_restaurant_rating(p_rest uuid)
returns void language sql as $$
  update public.restaurants r
  set total_ratings = s.cnt,
      average_ratings = round(s.avg::numeric, 1)
  from (
    select count(*)::int as cnt, coalesce(avg(rating), 0) as avg
    from public.restaurant_reviews
    where restaurant_id = p_rest and not is_hidden
  ) s
  where r.rest_uid = p_rest;
$$;

-- ============================================================
-- 9. REALTIME FOR THE ORDERS SCREEN
--    ALTER PUBLICATION supabase_realtime ADD TABLE public.orders;
--    (uncomment if you want live order updates without a refresh)
-- ============================================================
