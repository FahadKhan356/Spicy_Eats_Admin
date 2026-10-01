-- =============================================================================
-- Spicy Eats — seed data for StreetGrill (sajjadkhan11@gmail.com)
--
-- Owner : sajjadkhan11@gmail.com  /  6431ff18-3f5f-492e-902f-27fd0e833e78
-- Store : StreetGrill              /  8cd1f2dc-1b9f-447e-ae3e-84197d841b90
--
-- Run order:
--   1. 20260930_01_security_and_orders.sql
--   2. 20260930_02_promotions_reviews_ledger.sql
--   3. this file
--
-- SAFE TO RE-RUN. Every insert is guarded so nothing duplicates.
-- =============================================================================

-- 0. Make sure the restaurants we touch are approved + open
update public.restaurants
set status = 'approved', is_open = true
where rest_uid = '8cd1f2dc-1b9f-447e-ae3e-84197d841b90'::uuid;

-- 1. CATEGORIES  (StreetGrill already has 4, adding 3 more)
insert into public.categories (category_id, category_name, rest_uid, category_description)
select gen_random_uuid(), v.name, v.rest::uuid, v.desc
from (values
  ('Beverages & Shakes','8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Cold drinks, malts and fresh juices'),
  ('Desserts',          '8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Sweet finishers'),
  ('Deals & Combos',    '8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Value bundles and family packs')
) as v(name, rest, desc)
where not exists (
  select 1 from public.categories c
  where c.rest_uid = v.rest::uuid and c.category_name = v.name
);

-- 2. DISHES  (StreetGrill has 17, adding 20 more across all 7 categories)
--    Image URLs reuse dishes already in your DB so every thumbnail renders.
insert into public.dishes (
  rest_uid, dish_name, dish_description, dish_price, dish_discount,
  dish_imageurl, category_id, isVeg, isAvailable, cusine
)
select
  v.rest::uuid, v.name, v.desc, v.price, v.discount, v.img,
  c.category_id, v.veg, v.avail, v.cuisine
from (values
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Double Flame Burger','Two smashed patties, double cheddar, caramelised onion and house sauce','12.50','10.50','https://spicysouthernkitchen.com/wp-content/uploads/bbq-burger-23.jpg',true,true,'Fast Food'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Crispy Chicken Zinger','Buttermilk marinated chicken, crunchy crumb, slaw and chipotle mayo','9.90','8.20','https://upload.wikimedia.org/wikipedia/commons/7/7d/Steak_burger_with_cheese_and_onion_rings.jpg',false,true,'Fast Food'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Mushroom Swiss Patty','Grilled patty, sauteed mushrooms, melted swiss and truffle mayo','11.00','9.00','https://spicysouthernkitchen.com/wp-content/uploads/bbq-burger-23.jpg',true,true,'Fast Food'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Paneer Tikka Burger','Charred paneer tikka, mint chutney, pickled onion and lettuce','8.75','7.25','https://spicysouthernkitchen.com/wp-content/uploads/vegetarian-sloppy-joes-36.jpg',true,true,'Fast Food'),

  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Chicken Tikka Wrap','Grilled chicken tikka, garlic mayo, salad wrapped in tortilla','7.90','6.60','https://www.ohiobeef.org/Media/OhBeef/Images/beef-shawarma-a-cedar-spoon.jpg',false,true,'Fast Food'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Zinger Shawarma Roll','Crispy zinger strips with shawarma sauce and pickles','8.40','7.00','https://supperinthesuburbs.com/wp-content/uploads/2019/01/The-inside-of-a-Vegan-Falafel-and-Hummet-Wrap-e1605993662153.jpg',false,true,'Fast Food'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Cheese Burst Roll','Melted cheese, jalapenos and peri peri dip','6.90','5.50','https://wearenotmartha.com/wp-content/uploads/grilled-chicken-caesar-wrap-lead.jpg',true,true,'Fast Food'),

  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Malai Boti Kebab','Creamy chicken malai boti charred over open flame','14.00','12.00','https://cdn12.picryl.com/photo/2016/12/31/steak-beef-meat-food-drink-010fd7-1024.jpg',false,true,'BBQ'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Seekh Kebab Platter','Four seekh kebabs, mint chutney, onion rings and naan','16.50','14.00','https://cdn12.picryl.com/photo/2016/12/31/steak-beef-meat-food-drink-010fd7-1024.jpg',false,true,'BBQ'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Tandoori Broccoli','Charred broccoli, hung curd and green chilli dressing','8.20','6.90','https://spicysouthernkitchen.com/wp-content/uploads/greek-chicken-17.jpg',true,true,'BBQ'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Prawn Skewers','Tiger prawns marinated in ajwain butter, grilled','18.00','15.50','https://thishealthytable.com/wp-content/uploads/2024/02/grilled-halibut-recipe-735x735.jpg',false,false,'BBQ'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Chicken Malai Boti Wrap','Malai boti, onion salad and mint chutney rolled flat','9.60','8.00','https://www.ohiobeef.org/Media/OhBeef/Images/beef-shawarma-a-cedar-spoon.jpg',false,true,'BBQ'),

  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Loaded Cheese Fries','Fries, cheese sauce, jalapenos and spring onion','6.50','5.20','https://media-cdn.tripadvisor.com/media/photo-s/29/0e/51/16/seasoned-curly-fries.jpg',true,true,'Sides'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Peri Peri Chicken Wings','Six wings tossed in peri peri glaze','9.80','8.00','https://spicysouthernkitchen.com/wp-content/uploads/Grilled-Cheese-Hot-Dogs-5.jpg',false,true,'Sides'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Garlic Bread Sticks','Toasted sticks with garlic butter and herbs','4.20','3.40','https://spicysouthernkitchen.com/wp-content/uploads/2022/03/Parmesan-Potato-Wedges-2.jpg',true,true,'Sides'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Pakoras (6 pcs)','Gram flour fritters with chutney','5.50','4.50','https://spicysouthernkitchen.com/wp-content/uploads/2022/03/Parmesan-Potato-Wedges-2.jpg',true,true,'Sides'),

  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Cold Coffee Shake','Blended cold coffee with whipped cream','5.90','4.80','https://foodish-api.com/images/idly/idly64.jpg',true,true,'Beverages'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Mango Lassi','Sweet mango lassi with pistachio','4.80','3.90','https://foodish-api.com/images/idly/idly64.jpg',true,true,'Beverages'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Mint Lemonade','Fresh lemon, mint and crushed ice','3.50','2.80','https://foodish-api.com/images/idly/idly64.jpg',true,true,'Beverages'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Soft Drink Can','Chilled can, choice of flavour','2.50','2.00','https://foodish-api.com/images/idly/idly64.jpg',true,true,'Beverages'),

  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Molten Chocolate Cake','Warm chocolate cake with vanilla scoop','7.90','6.50','https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/Cheeseburger_With_Lettuce%2C_Tomato_and_Onion_free_creative_commons_%284006382370%29.jpg/1015px-Cheeseburger_With_Lettuce%2C_Tomato_and_Onion_free_creative_commons_%284006382370%29.jpg',true,true,'Desserts'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90','Firni Pudding','Traditional rice pudding with rose and pistachio','4.20','3.40','https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/Cheeseburger_With_Lettuce%2C_Tomato_and_Onion_free_creative_commons_%284006382370%29.jpg/1015px-Cheeseburger_With_Lettuce%2C_Tomato_and_Onion_free_creative_commons_%284006382370%29.jpg',true,true,'Desserts')
) as v(rest, name, desc, price, discount, img, veg, avail, cuisine)
join public.categories c on c.rest_uid = v.rest::uuid
where not exists (
  select 1 from public.dishes d
  where d.rest_uid = v.rest::uuid and d.dish_name = v.name
);

-- 3. VARIATION GROUPS
insert into public.titleVariations (dishid, title, isRequired, subtitle, maxSeleted)
select d.id, v.vtitle, v.req, v.subtitle, v.maxsel
from (values
  ('Crispy Chicken Zinger',  'Spice level',    true,  'How hot?', 1),
  ('Crispy Chicken Zinger',  'Add cheese',     false, 'Select any', 1),
  ('Zinger Shawarma Roll',   'Sauce',          true,  'Pick one', 1),
  ('Malai Boti Kebab',       'Marination',     false, 'Optional', 1),
  ('Peri Peri Chicken Wings','Wing count',     true,  'Choose size', 1)
) as v(dname, vtitle, req, subtitle, maxsel)
join public.dishes d on d.dish_name = v.dname
where not exists (
  select 1 from public.titleVariations t
  where t.dishid = d.id and t.title = v.vtitle
);

-- 4. VARIATION OPTIONS
insert into public.variations (variation_id, variation_name, variation_price)
select t.id, v.oname, v.oprice
from (values
  ('Crispy Chicken Zinger',  'Spice level',     'Mild',             0.00),
  ('Crispy Chicken Zinger',  'Spice level',     'Hot',              0.00),
  ('Crispy Chicken Zinger',  'Spice level',     'Extra Hot',        0.00),
  ('Crispy Chicken Zinger',  'Add cheese',      'Cheddar slice',    0.80),
  ('Crispy Chicken Zinger',  'Add cheese',      'Mozzarella slice', 0.90),
  ('Zinger Shawarma Roll',   'Sauce',           'Garlic mayo',      0.00),
  ('Zinger Shawarma Roll',   'Sauce',           'Chipotle mayo',    0.00),
  ('Malai Boti Kebab',       'Marination',      'Regular',          0.00),
  ('Malai Boti Kebab',       'Marination',      'Extra creamy',     1.50),
  ('Peri Peri Chicken Wings','Wing count',      '6 pieces',         0.00),
  ('Peri Peri Chicken Wings','Wing count',      '12 pieces',        6.00)
) as v(dname, vtitle, oname, oprice)
join public.dishes d on d.dish_name = v.dname
join public.titleVariations t on t.dishid = d.id and t.title = v.vtitle
where not exists (
  select 1 from public.variations x
  where x.variation_id = t.id and x.variation_name = v.oname
);

-- 5. ORDERS
--    Deterministic ordersId (md5 -> uuid) so re-running never duplicates.
--    Dates are relative to now() so the dashboard 7-day chart always has data.
do $$
declare
  v_rest      uuid := '8cd1f2dc-1b9f-447e-ae3e-84197d841b90';
  v_name      text := 'StreetGrill';
  v_fee       numeric := 5.60;
  v_customers uuid[] := array[
    '1f33b6ff-35b9-469e-8ae8-883dd4b79db0',
    '26e632dc-951d-4ef7-b2ff-d15e789af6cd',
    '4de9048a-db3c-4eac-b476-dda6eccc8b91',
    '74ec62e2-5490-4008-9bbc-ad70e9ed4ea8',
    'a094f192-1ae3-42de-92ec-7e489b8be225',
    '2039fbab-4313-494a-ace2-fd86dafc031c'
  ];
  v_addrs text[] := array[
    'House 12, Street 4, Qasimabad, Hyderabad',
    'Flat 3B, Al-Mustafa Plaza, Latifabad Unit 9',
    'Shop 7, Auto Bhan Road, Hirabad',
    'House 45/A, Thandi Sarak, Hyderabad',
    'Office 202, Sindh Infotech Centre, Jamshoro'
  ];
  v_pay   text[] := array['Cash on Delivery','Credit or Debit Card','Cash on Delivery'];
  v_item  jsonb;
  v_items jsonb;
  v_total numeric;
  v_i int;
  v_n int;
  v_qty int;
  v_days int;
  v_uid uuid;
  v_oid uuid;
  v_status text;
  v_d record;
begin
  for v_i in 1..24 loop
    v_oid := md5('streetgrill-order-' || v_i)::uuid;
    continue when exists (select 1 from public.orders where ordersId = v_oid);

    v_days := case
      when v_i <= 7  then v_i - 1
      when v_i <= 15 then 8 + (v_i - 7) * 2
      else 28 + (v_i - 15)
    end;

    v_uid  := v_customers[(v_i % array_length(v_customers, 1)) + 1];
    v_qty  := 1 + (v_i % 3);

    v_status := case
      when v_i % 7 = 0 then 'cancelled'
      when v_i <= 4      then 'pending'
      when v_i <= 9      then 'preparing'
      else 'delivered'
    end;

    v_items := '[]'::jsonb;
    v_total := 0;

    for v_n in 1..(1 + (v_i % 3)) loop
      select d.id, d.dish_name, d.dish_price, d.dish_imageurl, d.dish_description
      into v_d
      from public.dishes d
      where d.rest_uid = v_rest
      order by random()
      limit 1;

      continue when v_d.id is null;

      v_item := jsonb_build_object(
        'dish_id',    v_d.id,
        'name',       v_d.dish_name,
        'image',      v_d.dish_imageurl,
        'description',v_d.dish_description,
        'itemprice',  v_d.dish_price,
        'tprice',     round(v_d.dish_price * v_qty, 2),
        'quantity',   v_qty,
        'restaurant_id', v_rest,
        'restaurant_name', v_name,
        'variation',  '[]',
        'frequently_boughtList', '[]',
        'created_at', to_char(now() - make_interval(days => v_days), 'YYYY-MM-DD"T"HH24:MI:SS')
      );

      v_items := v_items || jsonb_build_array(v_item);
      v_total := v_total + round(v_d.dish_price * v_qty, 2);
    end loop;

    continue when v_items = '[]'::jsonb;

    insert into public.orders (
      ordersId, created_at, restaurant_id, orderedFrom, deliveredTo,
      orderedItems, payType, total_price, status, user_id
    )
    values (
      v_oid,
      now() - make_interval(days => v_days, hours => (v_i * 3) % 20),
      v_rest,
      v_name,
      v_addrs[(v_i % array_length(v_addrs, 1)) + 1],
      v_items,
      v_pay[(v_i % array_length(v_pay, 1)) + 1],
      round(v_total + v_fee, 2),
      v_status,
      v_uid
    );
  end loop;
end $$;

-- Backfill anything the jsonb migration missed
update public.orders
set restaurant_id = '8cd1f2dc-1b9f-447e-ae3e-84197d841b90'::uuid
where restaurant_id is null and orderedFrom = 'StreetGrill';

update public.orders
set user_id = '1f33b6ff-35b9-469e-8ae8-883dd4b79db0'::uuid
where user_id is null;

-- 6. REVIEWS
insert into public.restaurant_reviews (restaurant_id, user_id, rating, body, reply, replied_at, created_at)
select
  '8cd1f2dc-1b9f-447e-ae3e-84197d841b90'::uuid,
  v.uid::uuid, v.rating, v.body, v.reply,
  case when v.reply is null then null
       else now() - make_interval(days => v.days - 2) end,
  now() - make_interval(days => v.days)
from (values
  (2, '1f33b6ff-35b9-469e-8ae8-883dd4b79db0', 5, 'The zinger was properly crispy and the chipotle mayo is addictive. Portion was huge for the price.', 'Thank you! See you again soon.'),
  (4, '26e632dc-951d-4ef7-b2ff-d15e789af6cd', 4, 'Malai boti was tender and smoky. Slightly less spicy than I expected but flavour was good.', null),
  (5, '4de9048a-db3c-4eac-b476-dda6eccc8b91', 5, 'Best shawarma roll in Qasimabad, hands down. The garlic mayo makes it.', 'We appreciate it!'),
  (9, '74ec62e2-5490-4008-9bbc-ad70e9ed4ea8', 3, 'Food was fine but it took 45 minutes. Fries were cold by the time they arrived.', null),
  (12,'a094f192-1ae3-42de-92ec-7e489b8be225', 5, 'Loaded cheese fries are dangerous. Ordering again this weekend.', null),
  (16,'2039fbab-4313-494a-ace2-fd86dafc031c', 4, 'Solid grill selection. The seekh kebab platter is a must for sharing.', null),
  (20,'1f33b6ff-35b9-469e-8ae8-883dd4b79db0', 4, 'Good packaging, everything arrived hot. Would like more vegetarian options.', null),
  (24,'26e632dc-951d-4ef7-b2ff-d15e789af6cd', 5, 'The prawn skewers are outstanding. Reasonably priced too.', null),
  (29,'4de9048a-db3c-4eac-b476-dda6eccc8b91', 2, 'Ordered twice, both times one item was missing. Food is good but stock needs work.', null),
  (33,'74ec62e2-5490-4008-9bbc-ad70e9ed4ea8', 5, 'Molten chocolate cake is a proper dessert. Staff called to confirm the order, nice touch.', null),
  (37,'a094f192-1ae3-42de-92ec-7e489b8be225', 4, 'Cold coffee shake is great value. Would like a sugar-free option.', null),
  (41,'2039fbab-4313-494a-ace2-fd86dafc031c', 5, 'Consistent quality every time. This is our family order now.', null)
) as v(days, uid, rating, body, reply)
where exists (select 1 from auth.users where id = v.uid::uuid)
  and not exists (
    select 1 from public.restaurant_reviews r
    where r.restaurant_id = '8cd1f2dc-1b9f-447e-ae3e-84197d841b90'::uuid
      and r.user_id = v.uid::uuid and r.body = v.body
);

select public.refresh_restaurant_rating('8cd1f2dc-1b9f-447e-ae3e-84197d841b90'::uuid);

-- 7. PROMOTIONS
insert into public.promotions (
  restaurant_id, title, description, kind, value, min_order,
  max_discount, code, starts_at, ends_at, usage_limit, is_active
)
select
  '8cd1f2dc-1b9f-447e-ae3e-84197d841b90'::uuid,
  v.title, v.desc, v.kind, v.value, v.min_order, v.max_disc, v.code,
  now() - make_interval(days => v.start_days),
  now() + make_interval(days => v.end_days),
  v.usage_limit, v.active
from (values
  ('Weekend Grill Bonanza','20% off all grilled specials, Friday to Sunday','percent',       20,  800,  400, 'GRILL20',  3,  9, 300, true),
  ('Free Delivery Above 1500','No delivery charge on orders over Rs 1500','free_delivery',  0, 1500, null, 'FREEDEL', 10, 20, 500, true),
  ('Student Saver','Rs 150 off when you spend Rs 900 or more','fixed',            150,  900,  150, 'STUDENT',  5, 25, 200, true),
  ('Family Combo Deal','Buy 2 mains get 1 dessert free','bogo',                     0, 1200,  350, 'FAMILY3',  1, 14, 100, true),
  ('Lunch Rush','15% off between 12pm and 3pm','percent',                         15,  500,  250, 'LUNCH15',  7,  3, 400, true),
  ('Midnight Munches','25% off after 10pm, delivery only','percent',               25,  700,  500, 'MIDNIGHT', 0, 60, 150, false)
) as v(title, desc, kind, value, min_order, max_disc, code, start_days, end_days, usage_limit, active)
where not exists (
  select 1 from public.promotions p
  where p.restaurant_id = '8cd1f2dc-1b9f-447e-ae3e-84197d841b90'::uuid and p.code = v.code
);

-- 8. EARNINGS LEDGER
insert into public.restaurant_ledger (
  restaurant_id, order_id, entry_type, gross, fee, net, note, created_at
)
select
  o.restaurant_id, o.id, 'sale',
  o.total_price,
  round(o.total_price * 0.05, 2),
  round(o.total_price * 0.95, 2),
  'Order #' || o.id,
  o.created_at
from public.orders o
where o.restaurant_id = '8cd1f2dc-1b9f-447e-ae3e-84197d841b90'::uuid
  and o.status not in ('cancelled', 'rejected')
  and not exists (
    select 1 from public.restaurant_ledger l
    where l.order_id = o.id and l.entry_type = 'sale'
  );

-- 9. PAYOUTS
insert into public.payouts (restaurant_id, amount, status, method, reference, period_start, period_end, processed_at, created_at)
select * from (values
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90'::uuid, 4200.00, 'paid',       'Bank transfer', 'TXN-2026-0912', (now() - interval '35 days')::date, (now() - interval '22 days')::date, (now() - interval '21 days'), (now() - interval '22 days')),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90'::uuid, 3150.50, 'paid',       'Bank transfer', 'TXN-2026-0926', (now() - interval '21 days')::date, (now() - interval '8 days')::date,  (now() - interval '7 days'),  (now() - interval '8 days')),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90'::uuid, 1980.00, 'processing', 'Bank transfer', 'TXN-2026-1003', (now() - interval '7 days')::date,  current_date,                null,                            (now() - interval '1 day'))
) as v(restaurant_id, amount, status, method, reference, period_start, period_end, processed_at, created_at)
where not exists (
  select 1 from public.payouts p
  where p.restaurant_id = v.restaurant_id and p.reference = v.reference
);

-- 10. NOTIFICATIONS
insert into public.restaurant_notifications (restaurant_id, type, title, body, payload, is_read, created_at)
select * from (values
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90'::uuid,'new_order','New order received','Order placed for Rs 812.00. Tap to review and accept.','{}'::jsonb,false, now() - interval '2 hours'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90'::uuid,'new_order','New order received','Order placed for Rs 1240.50. Tap to review and accept.','{}'::jsonb,false, now() - interval '9 hours'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90'::uuid,'review','New 1-star review','Ordered twice, both times one item was missing.','{}'::jsonb,false, now() - interval '2 days'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90'::uuid,'payout','Payout is processing','Rs 1980.00 is being transferred to your bank account.','{}'::jsonb,true, now() - interval '1 day'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90'::uuid,'promotion','Promotion ending soon','Weekend Grill Bonanza ends in 9 days.','{}'::jsonb,true, now() - interval '3 days'),
  ('8cd1f2dc-1b9f-447e-ae3e-84197d841b90'::uuid,'system','Menu sync complete','20 new dishes added to your menu from the last import.','{}'::jsonb,true, now() - interval '5 days')
) as v(restaurant_id, type, title, body, payload, is_read, created_at)
where not exists (
  select 1 from public.restaurant_notifications n
  where n.restaurant_id = v.restaurant_id and n.title = v.title and n.body = v.body
);

-- 11. SUMMARY
select 'Categories' as item, count(*)::text as total
  from public.categories where rest_uid = '8cd1f2dc-1b9f-447e-ae3e-84197d841b90'
union all select 'Dishes', count(*)::text
  from public.dishes where rest_uid = '8cd1f2dc-1b9f-447e-ae3e-84197d841b90'
union all select 'Variation groups', count(*)::text
  from public.titleVariations t join public.dishes d on d.id = t.dishid
  where d.rest_uid = '8cd1f2dc-1b9f-447e-ae3e-84197d841b90'
union all select 'Variation options', count(*)::text
  from public.variations x join public.titleVariations t on t.id = x.variation_id
  join public.dishes d on d.id = t.dishid
  where d.rest_uid = '8cd1f2dc-1b9f-447e-ae3e-84197d841b90'
union all select 'Orders', count(*)::text
  from public.orders where restaurant_id = '8cd1f2dc-1b9f-447e-ae3e-84197d841b90'
union all select 'Pending orders', count(*)::text
  from public.orders where restaurant_id = '8cd1f2dc-1b9f-447e-ae3e-84197d841b90' and status in ('pending','preparing')
union all select 'Revenue (non-cancelled)', 'Rs ' || coalesce(sum(total_price), 0)::text
  from public.orders where restaurant_id = '8cd1f2dc-1b9f-447e-ae3e-84197d841b90' and status not in ('cancelled','rejected')
union all select 'Reviews', count(*)::text
  from public.restaurant_reviews where restaurant_id = '8cd1f2dc-1b9f-447e-ae3e-84197d841b90'
union all select 'Promotions', count(*)::text
  from public.promotions where restaurant_id = '8cd1f2dc-1b9f-447e-ae3e-84197d841b90'
union all select 'Ledger entries', count(*)::text
  from public.restaurant_ledger where restaurant_id = '8cd1f2dc-1b9f-447e-ae3e-84197d841b90'
union all select 'Payouts', count(*)::text
  from public.payouts where restaurant_id = '8cd1f2dc-1b9f-447e-ae3e-84197d841b90'
union all select 'Notifications', count(*)::text
  from public.restaurant_notifications where restaurant_id = '8cd1f2dc-1b9f-447e-ae3e-84197d841b90';
