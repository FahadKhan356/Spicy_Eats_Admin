-- Spicy Eats: admin portal orders support + critical security lockdown
-- Run in Supabase SQL Editor, in this order.

-- 1. CRITICAL: the users table is world-readable and the app was writing
--    plaintext passwords into it. Remove the column, then lock reads down.
alter table public.users drop column if exists password;

drop policy if exists "for-select" on public.users;
create policy "users_select_own"
  on public.users for select to authenticated
  using (id = auth.uid());

-- 2. Orders: give the admin portal a real restaurant scope.
--    Today the restaurant id only exists inside orderedItems jsonb, so the
--    app has to download every order and filter client-side.
alter table public.orders
  add column if not exists restaurant_id uuid references public.restaurants(rest_uid) on delete cascade,
  add column if not exists notes text,
  add column if not exists cancelled_reason text,
  add column if not exists updated_at timestamptz not null default now();

alter table public.orders
  alter column ordersId set default gen_random_uuid();

-- Backfill from the jsonb payload that the customer app already writes.
update public.orders o
set restaurant_id = (
  select (item->>'restaurant_id')::uuid
  from jsonb_array_elements(
    case
      when jsonb_typeof(o.orderedItems::jsonb) = 'array' then o.orderedItems::jsonb
      else '[]'::jsonb
    end
  ) as item
  where item->>'restaurant_id' is not null
  limit 1
)
where o.restaurant_id is null;

-- Fill in the columns the customer app never wrote.
update public.orders
set status = 'pending'
where status is null;

alter table public.orders
  drop constraint if exists orders_status_check;
alter table public.orders
  add constraint orders_status_check
  check (status in ('pending','accepted','preparing','ready',
                    'out_for_delivery','delivered','cancelled',
                    'rejected','completed'));

create index if not exists orders_restaurant_idx
  on public.orders (restaurant_id, created_at desc);
create index if not exists orders_status_idx
  on public.orders (restaurant_id, status);

-- 3. Orders RLS. There was no UPDATE policy at all, so no admin could ever
--    accept, prepare or complete an order.
alter table public.orders enable row level security;

drop policy if exists "Enable read access for all users" on public.orders;
drop policy if exists "temp insert" on public.orders;

create policy "orders_select_participant"
  on public.orders for select to authenticated
  using (
    user_id = auth.uid()
    or restaurant_id in (
      select rest_uid from public.restaurants where user_id = auth.uid()
    )
  );

create policy "orders_insert_customer"
  on public.orders for insert to authenticated
  with check (user_id = auth.uid() and restaurant_id is not null);

create policy "orders_update_restaurant"
  on public.orders for update to authenticated
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

-- 4. Dishes / restaurants were writable by anon. Scope them to the owner.
drop policy if exists "Policy with table joins" on public.dishes;
drop policy if exists "dishes delete " on public.dishes;

create policy "dishes_update_own"
  on public.dishes for update to authenticated
  using (
    rest_uid in (
      select rest_uid from public.restaurants where user_id = auth.uid()
    )
  )
  with check (
    rest_uid in (
      select rest_uid from public.restaurants where user_id = auth.uid()
    )
  );

create policy "dishes_delete_own"
  on public.dishes for delete to authenticated
  using (
    rest_uid in (
      select rest_uid from public.restaurants where user_id = auth.uid()
    )
  );

drop policy if exists "update restuarant" on public.restaurants;
create policy "restaurants_update_own"
  on public.restaurants for update to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- 5. Cart was readable and editable by anyone.
drop policy if exists "for insert"     on public.cart;
drop policy if exists "for retrieve"   on public.cart;
drop policy if exists "for update"     on public.cart;
drop policy if exists "or remove cart" on public.cart;

create policy "cart_own_all"
  on public.cart for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- 6. Registration is impossible today: rest_uid has no default and iban /
--    phoneNumber are numeric columns that cannot hold real values.
alter table public.restaurants
  alter column rest_uid set default gen_random_uuid();

alter table public.restaurants
  alter column iban type text,
  alter column phoneNumber type text;

alter table public.users
  alter column contactno type text;

-- 7. Dish soft delete + updated_at, used by the admin menu.
alter table public.dishes
  add column if not exists updated_at timestamptz not null default now(),
  add column if not exists deleted_at timestamptz;

create index if not exists dishes_category_idx
  on public.dishes (category_id) where deleted_at is null;

-- 8. Categories and variations had no UPDATE/DELETE policy, so editing a
--    dish or renaming a category was impossible.
alter table public.categories enable row level security;

create policy "categories_update_own"
  on public.categories for update to authenticated
  using (
    rest_uid::uuid in (
      select rest_uid from public.restaurants where user_id = auth.uid()
    )
  );

create policy "categories_delete_own"
  on public.categories for delete to authenticated
  using (
    rest_uid::uuid in (
      select rest_uid from public.restaurants where user_id = auth.uid()
    )
  );
