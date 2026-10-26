-- =============================================================================
-- Spicy Eats Admin: Complete Promotions & Banners Migration
-- Run this script in your Supabase SQL Editor.
-- =============================================================================

-- 1. Create PROMOTIONS Table (Discounts, Coupons, Flat/Percent Off, BOGO)
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

-- 2. Create PROMOTION REDEMPTIONS Table
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

-- 3. Seed Default BANNER POSITIONS (if none exist)
insert into public.banner_positions (id, name, max_banners, base_price)
select gen_random_uuid(), 'Home Top Carousel', 5, 2500
where not exists (select 1 from public.banner_positions where name = 'Home Top Carousel');

insert into public.banner_positions (id, name, max_banners, base_price)
select gen_random_uuid(), 'Deals of the Day', 3, 1800
where not exists (select 1 from public.banner_positions where name = 'Deals of the Day');

insert into public.banner_positions (id, name, max_banners, base_price)
select gen_random_uuid(), 'Category Header Spotlight', 4, 1200
where not exists (select 1 from public.banner_positions where name = 'Category Header Spotlight');

-- 4. Enable Row Level Security (RLS)
alter table public.promotions            enable row level security;
alter table public.promotion_redemptions enable row level security;
alter table public.banner_positions      enable row level security;
alter table public.banner_slots          enable row level security;
alter table public.banner_requests       enable row level security;

-- 5. Promotions Policies
drop policy if exists "promotions_read_live" on public.promotions;
create policy "promotions_read_live"
  on public.promotions for select to anon, authenticated
  using (
    is_active
    and (now() >= starts_at)
    and (ends_at is null or now() <= ends_at)
  );

drop policy if exists "promotions_manage_own" on public.promotions;
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

-- 6. Banner Positions Policies (Readable by everyone)
drop policy if exists "banner_positions_read" on public.banner_positions;
create policy "banner_positions_read"
  on public.banner_positions for select to anon, authenticated
  using (true);

-- 7. Banner Slots Policies (Allow authenticated restaurants to insert, read and manage banner slots)
drop policy if exists "banner_slots_all" on public.banner_slots;
drop policy if exists "banner_slots_manage" on public.banner_slots;
drop policy if exists "banner_slots_manage_own" on public.banner_slots;
drop policy if exists "banner_slots_read" on public.banner_slots;
create policy "banner_slots_all"
  on public.banner_slots for all to authenticated
  using (true)
  with check (true);

-- 8. Banner Requests Policies (Allow authenticated restaurants to create and manage requests)
drop policy if exists "banner_requests_all" on public.banner_requests;
drop policy if exists "banner_requests_manage" on public.banner_requests;
drop policy if exists "banner_requests_manage_own" on public.banner_requests;
create policy "banner_requests_all"
  on public.banner_requests for all to authenticated
  using (true)
  with check (true);
