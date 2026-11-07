-- ============================================================
-- Reviews System Migration
-- Supports both Restaurant-level reviews and Dish-level reviews
-- ============================================================

-- 1. Restaurant Reviews
CREATE TABLE IF NOT EXISTS public.restaurant_reviews (
  id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  restaurant_id UUID NOT NULL REFERENCES public.restaurants(rest_uid) ON DELETE CASCADE,
  user_id       UUID NOT NULL,
  order_id      BIGINT REFERENCES public.orders(id) ON DELETE SET NULL,
  rating        INT2 NOT NULL CHECK (rating BETWEEN 1 AND 5),
  body          TEXT,
  reply         TEXT,
  replied_at    TIMESTAMPTZ,
  is_hidden     BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS restaurant_reviews_idx
  ON public.restaurant_reviews (restaurant_id, created_at DESC);

-- FK to public.users for PostgREST embedding: profiles:users!restaurant_reviews_user_id_fkey(email)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid = 'public.restaurant_reviews'::regclass
      AND contype = 'f'
      AND conname = 'restaurant_reviews_user_id_fkey'
  ) THEN
    ALTER TABLE public.restaurant_reviews
      ADD CONSTRAINT restaurant_reviews_user_id_fkey
      FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
  END IF;
END $$;

-- 2. Dish Reviews
CREATE TABLE IF NOT EXISTS public.dish_reviews (
  id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  dish_id       BIGINT NOT NULL REFERENCES public.dishes(id) ON DELETE CASCADE,
  restaurant_id UUID NOT NULL REFERENCES public.restaurants(rest_uid) ON DELETE CASCADE,
  user_id       UUID NOT NULL,
  order_id      BIGINT REFERENCES public.orders(id) ON DELETE SET NULL,
  rating        INT2 NOT NULL CHECK (rating BETWEEN 1 AND 5),
  body          TEXT,
  dish_name     TEXT,
  reply         TEXT,
  replied_at    TIMESTAMPTZ,
  is_hidden     BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS dish_reviews_dish_idx
  ON public.dish_reviews (dish_id, created_at DESC);

CREATE INDEX IF NOT EXISTS dish_reviews_rest_idx
  ON public.dish_reviews (restaurant_id, created_at DESC);

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid = 'public.dish_reviews'::regclass
      AND contype = 'f'
      AND conname = 'dish_reviews_user_id_fkey'
  ) THEN
    ALTER TABLE public.dish_reviews
      ADD CONSTRAINT dish_reviews_user_id_fkey
      FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
  END IF;
END $$;

-- 3. Enable RLS
ALTER TABLE public.restaurant_reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dish_reviews ENABLE ROW LEVEL SECURITY;

-- Policies for restaurant_reviews
DROP POLICY IF EXISTS "restaurant_reviews_read" ON public.restaurant_reviews;
CREATE POLICY "restaurant_reviews_read" ON public.restaurant_reviews
  FOR SELECT TO anon, authenticated
  USING (is_hidden = false);

DROP POLICY IF EXISTS "restaurant_reviews_insert" ON public.restaurant_reviews;
CREATE POLICY "restaurant_reviews_insert" ON public.restaurant_reviews
  FOR INSERT TO authenticated
  WITH CHECK (true);

DROP POLICY IF EXISTS "restaurant_reviews_update" ON public.restaurant_reviews;
CREATE POLICY "restaurant_reviews_update" ON public.restaurant_reviews
  FOR UPDATE TO authenticated
  USING (true)
  WITH CHECK (true);

-- Policies for dish_reviews
DROP POLICY IF EXISTS "dish_reviews_read" ON public.dish_reviews;
CREATE POLICY "dish_reviews_read" ON public.dish_reviews
  FOR SELECT TO anon, authenticated
  USING (is_hidden = false);

DROP POLICY IF EXISTS "dish_reviews_insert" ON public.dish_reviews;
CREATE POLICY "dish_reviews_insert" ON public.dish_reviews
  FOR INSERT TO authenticated
  WITH CHECK (true);

DROP POLICY IF EXISTS "dish_reviews_update" ON public.dish_reviews;
CREATE POLICY "dish_reviews_update" ON public.dish_reviews
  FOR UPDATE TO authenticated
  USING (true)
  WITH CHECK (true);

-- Grants
GRANT SELECT, INSERT, UPDATE ON public.restaurant_reviews TO anon, authenticated;
GRANT SELECT, INSERT, UPDATE ON public.dish_reviews TO anon, authenticated;

