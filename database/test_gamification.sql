-- test_gamification.sql
-- Basic tests to verify tables, triggers, and initial data

-- 1) Check achievements
SELECT id, key, title, points FROM achievements ORDER BY id LIMIT 10;

-- 2) Create a test user id (use an existing Supabase user id in real tests)
-- We'll use a fixed UUID for testing (replace with real user id when integrating)
DO $$
BEGIN
  -- warning: this block is safe for quick local testing only
  RAISE NOTICE 'Testing gamification: ensure you replace test_user_id with a real user uuid for integration tests.';
END$$;

-- Example test user UUID (replace in production)
-- INSERT INTO user_stats(user_id, points) VALUES('00000000-0000-0000-0000-000000000000', 0)
-- ON CONFLICT (user_id) DO NOTHING;

-- 3) Insert sample meals to trigger points & streaks
-- Replace user_id in real tests; using parameter placeholder below in actual scripts
-- Example:
-- INSERT INTO meals(user_id, name, calories, protein, carbs, fat, meal_date) VALUES('00000000-0000-0000-0000-000000000000','Test Meal',200,10,20,5,'2025-11-01');

-- 4) Verify user_stats updates
-- SELECT * FROM user_stats WHERE user_id = '00000000-0000-0000-0000-000000000000';

-- 5) Verify trigger fired by running a meal insert and then selecting stats (manual test recommended)

-- 6) Test shopping list aggregation logic (manual flow):
-- a) Insert recipes with ingredients JSONB
-- b) Insert planned_meals referencing same recipe multiple times
-- c) Run the generate shopping list logic from the application or emulate aggregation logic in SQL

-- 7) Query sample tables
SELECT COUNT(*) AS meals_count FROM meals;
SELECT COUNT(*) AS recipes_count FROM recipes;
SELECT COUNT(*) AS achievements_count FROM achievements;

-- End of test_gamification.sql
