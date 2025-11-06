-- Disable gamification triggers and functions temporarily

-- Drop the triggers
DROP TRIGGER IF EXISTS after_meal_insert ON meals CASCADE;
DROP TRIGGER IF EXISTS after_water_insert ON water_logs CASCADE;

-- Drop the trigger functions
DROP FUNCTION IF EXISTS update_user_stats_on_meal() CASCADE;
DROP FUNCTION IF EXISTS trigger_check_challenges_on_meal() CASCADE;
DROP FUNCTION IF EXISTS trigger_check_challenges_on_water() CASCADE;
DROP FUNCTION IF EXISTS check_and_update_challenges(UUID) CASCADE;

-- You can re-enable them later once all columns are properly set up
