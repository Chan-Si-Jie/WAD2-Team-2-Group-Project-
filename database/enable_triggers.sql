-- Re-enable gamification triggers for automatic points
-- This script matches the existing schema in setup_gamification.sql

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
    INSERT INTO user_stats(user_id, points, total_meals, current_streak, longest_streak, last_meal_date, updated_at)
    VALUES(NEW.user_id, 10, 1, 1, 1, NEW.meal_date, now());
  ELSE
    -- increment points and total meals
    UPDATE user_stats
    SET points = user_stats.points + 10,
        total_meals = user_stats.total_meals + 1,
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

-- Success message
SELECT 'Gamification triggers re-enabled successfully! You will now earn 10 points per meal logged.' AS status;
