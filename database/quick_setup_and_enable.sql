-- Quick setup: Create necessary tables and enable triggers
-- Run this if you haven't run setup_gamification.sql yet

-- Create user_stats table if it doesn't exist
CREATE TABLE IF NOT EXISTS user_stats (
  user_id UUID PRIMARY KEY,
  points INTEGER DEFAULT 0,
  total_meals INTEGER DEFAULT 0,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_meal_date DATE,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Add level column if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'user_stats' AND column_name = 'level'
  ) THEN
    ALTER TABLE user_stats ADD COLUMN level INTEGER DEFAULT 1;
  END IF;
END $$;

-- Create achievements table if it doesn't exist
CREATE TABLE IF NOT EXISTS achievements (
  id BIGSERIAL PRIMARY KEY,
  key TEXT UNIQUE,
  title TEXT,
  name TEXT,
  icon TEXT,
  requirement_type TEXT,
  requirement_value INTEGER,
  description TEXT,
  points INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Create user_achievements table if it doesn't exist
CREATE TABLE IF NOT EXISTS user_achievements (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID NOT NULL,
  achievement_id BIGINT NOT NULL REFERENCES achievements(id) ON DELETE CASCADE,
  unlocked_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE(user_id, achievement_id)
);

-- Trigger function: update_user_stats_on_meal
-- Called after insert on meals: awards points and updates streaks
CREATE OR REPLACE FUNCTION update_user_stats_on_meal()
RETURNS TRIGGER AS $$
DECLARE
  stats_row user_stats%ROWTYPE;
  yesterday_date DATE := (NEW.meal_date - INTERVAL '1 day')::DATE;
BEGIN
  -- try to select existing stats
  SELECT * INTO stats_row FROM user_stats WHERE user_id = NEW.user_id;

  IF NOT FOUND THEN
    -- create new stats row
    INSERT INTO user_stats(user_id, points, total_meals, current_streak, longest_streak, last_meal_date, updated_at, level)
    VALUES(NEW.user_id, 10, 1, 1, 1, NEW.meal_date, now(), 1);
  ELSE
    -- increment points and total meals
    UPDATE user_stats
    SET points = user_stats.points + 10,
        total_meals = user_stats.total_meals + 1,
        level = FLOOR((user_stats.points + 10) / 100.0) + 1,
        updated_at = now()
    WHERE user_id = NEW.user_id;

    -- update streaks: if last_meal_date = yesterday -> increment current_streak, else if last_meal_date = NEW.meal_date -> do nothing (duplicate same day), else reset to 1
    IF stats_row.last_meal_date = yesterday_date THEN
      UPDATE user_stats
      SET current_streak = stats_row.current_streak + 1,
          longest_streak = GREATEST(stats_row.longest_streak, stats_row.current_streak + 1),
          last_meal_date = NEW.meal_date,
          updated_at = now()
      WHERE user_id = NEW.user_id;
    ELSIF stats_row.last_meal_date = NEW.meal_date THEN
      -- same day; no change to streak counts, just update time
      UPDATE user_stats
      SET updated_at = now(), last_meal_date = NEW.meal_date
      WHERE user_id = NEW.user_id;
    ELSE
      UPDATE user_stats
      SET current_streak = 1,
          last_meal_date = NEW.meal_date,
          updated_at = now()
      WHERE user_id = NEW.user_id;
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger on meals AFTER INSERT
DROP TRIGGER IF EXISTS trg_update_user_stats_on_meal ON meals;
CREATE TRIGGER trg_update_user_stats_on_meal
AFTER INSERT ON meals
FOR EACH ROW
EXECUTE PROCEDURE update_user_stats_on_meal();

-- Insert default achievements if they don't exist
INSERT INTO achievements (key, title, name, icon, requirement_type, requirement_value, description, points)
VALUES 
  ('first_steps', 'First Steps', 'First Steps', '🎯', 'total_meals', 1, 'Log your first meal', 10),
  ('week_warrior', 'Week Warrior', 'Week Warrior', '🔥', 'streak', 7, 'Maintain a 7-day streak', 50),
  ('month_master', 'Month Master', 'Month Master', '👑', 'streak', 30, 'Maintain a 30-day streak', 200),
  ('century_club', 'Century Club', 'Century Club', '💯', 'total_meals', 100, 'Log 100 meals', 100),
  ('consistency_king', 'Consistency King', 'Consistency King', '⭐', 'streak', 50, 'Maintain a 50-day streak', 300),
  ('nutrition_ninja', 'Nutrition Ninja', 'Nutrition Ninja', '🥷', 'total_meals', 500, 'Log 500 meals', 500)
ON CONFLICT (key) DO NOTHING;

-- Success message
SELECT 'Setup complete! Gamification system is now active. You will earn 10 points per meal logged.' AS status;
