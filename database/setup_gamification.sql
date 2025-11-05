-- setup_gamification.sql
-- Creates core tables, initial data, and triggers for SmartCal gamification and meal tracking

-- NOTE: This script assumes Supabase/Postgres environment. Adjust schema names as necessary.
-- If you have duplicate achievements or challenges, run cleanup_duplicates.sql first

BEGIN;

-- Users are handled by Supabase auth. We will reference user_id (uuid/text) as provided by Supabase.

-- meals: daily meal entries
CREATE TABLE IF NOT EXISTS meals (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID NOT NULL,
  name TEXT NOT NULL,
  calories INTEGER DEFAULT 0,
  protein INTEGER DEFAULT 0,
  carbs INTEGER DEFAULT 0,
  fat INTEGER DEFAULT 0,
  logged_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  meal_date DATE NOT NULL
);

-- water_logs: water intake tracking
CREATE TABLE IF NOT EXISTS water_logs (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID NOT NULL,
  amount_ml INTEGER NOT NULL,
  logged_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- nutrition: free-form nutrition entries (optional)
CREATE TABLE IF NOT EXISTS nutrition (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID NOT NULL,
  calories INTEGER DEFAULT 0,
  protein INTEGER DEFAULT 0,
  carbs INTEGER DEFAULT 0,
  fat INTEGER DEFAULT 0,
  logged_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- planned_meals: weekly schedule
CREATE TABLE IF NOT EXISTS planned_meals (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID NOT NULL,
  recipe_id BIGINT, -- references recipes.id when saved
  name TEXT,
  date DATE NOT NULL,
  meal_type TEXT, -- Breakfast/Lunch/Dinner/Snack
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- recipes: user-saved recipes (ingredients as jsonb array)
CREATE TABLE IF NOT EXISTS recipes (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  total_calories INTEGER DEFAULT 0,
  total_protein INTEGER DEFAULT 0,
  total_carbs INTEGER DEFAULT 0,
  total_fat INTEGER DEFAULT 0,
  ingredients JSONB DEFAULT '[]'::jsonb, -- [{name, amount, unit}, ...]
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- favorite_meals: shortcuts for quick-add
CREATE TABLE IF NOT EXISTS favorite_meals (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID NOT NULL,
  recipe_id BIGINT,
  name TEXT,
  calories INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- shopping_list: aggregated items generated per user
CREATE TABLE IF NOT EXISTS shopping_list (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID NOT NULL,
  ingredient TEXT NOT NULL,
  checked BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- achievements: definitions
CREATE TABLE IF NOT EXISTS achievements (
  id BIGSERIAL PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Add all required columns if they don't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'achievements' AND column_name = 'key'
  ) THEN
    ALTER TABLE achievements ADD COLUMN key TEXT UNIQUE;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'achievements' AND column_name = 'title'
  ) THEN
    ALTER TABLE achievements ADD COLUMN title TEXT;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'achievements' AND column_name = 'name'
  ) THEN
    ALTER TABLE achievements ADD COLUMN name TEXT;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'achievements' AND column_name = 'icon'
  ) THEN
    ALTER TABLE achievements ADD COLUMN icon TEXT;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'achievements' AND column_name = 'requirement_type'
  ) THEN
    ALTER TABLE achievements ADD COLUMN requirement_type TEXT;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'achievements' AND column_name = 'requirement_value'
  ) THEN
    ALTER TABLE achievements ADD COLUMN requirement_value INTEGER;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'achievements' AND column_name = 'description'
  ) THEN
    ALTER TABLE achievements ADD COLUMN description TEXT;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'achievements' AND column_name = 'points'
  ) THEN
    ALTER TABLE achievements ADD COLUMN points INTEGER DEFAULT 0;
  END IF;
  
  -- Drop NOT NULL constraints if they exist
  BEGIN
    ALTER TABLE achievements ALTER COLUMN name DROP NOT NULL;
  EXCEPTION
    WHEN undefined_column THEN NULL;
    WHEN others THEN NULL;
  END;
  
  BEGIN
    ALTER TABLE achievements ALTER COLUMN icon DROP NOT NULL;
  EXCEPTION
    WHEN undefined_column THEN NULL;
    WHEN others THEN NULL;
  END;
  
  BEGIN
    ALTER TABLE achievements ALTER COLUMN requirement_type DROP NOT NULL;
  EXCEPTION
    WHEN undefined_column THEN NULL;
    WHEN others THEN NULL;
  END;
  
  BEGIN
    ALTER TABLE achievements ALTER COLUMN requirement_value DROP NOT NULL;
  EXCEPTION
    WHEN undefined_column THEN NULL;
    WHEN others THEN NULL;
  END;
END $$;

-- user_achievements: unlocked per user
CREATE TABLE IF NOT EXISTS user_achievements (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID NOT NULL,
  achievement_id BIGINT NOT NULL REFERENCES achievements(id) ON DELETE CASCADE,
  unlocked_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE(user_id, achievement_id)
);

-- user_stats: track points, streaks, totals
CREATE TABLE IF NOT EXISTS user_stats (
  user_id UUID PRIMARY KEY,
  points INTEGER DEFAULT 0,
  total_meals INTEGER DEFAULT 0,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_meal_date DATE,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- challenges: definitions
CREATE TABLE IF NOT EXISTS challenges (
  id BIGSERIAL PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Add all required columns if they don't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'challenges' AND column_name = 'key'
  ) THEN
    ALTER TABLE challenges ADD COLUMN key TEXT UNIQUE;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'challenges' AND column_name = 'title'
  ) THEN
    ALTER TABLE challenges ADD COLUMN title TEXT;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'challenges' AND column_name = 'name'
  ) THEN
    ALTER TABLE challenges ADD COLUMN name TEXT;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'challenges' AND column_name = 'description'
  ) THEN
    ALTER TABLE challenges ADD COLUMN description TEXT;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'challenges' AND column_name = 'challenge_type'
  ) THEN
    ALTER TABLE challenges ADD COLUMN challenge_type TEXT;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'challenges' AND column_name = 'target_value'
  ) THEN
    ALTER TABLE challenges ADD COLUMN target_value INTEGER;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'challenges' AND column_name = 'reward_points'
  ) THEN
    ALTER TABLE challenges ADD COLUMN reward_points INTEGER DEFAULT 0;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'challenges' AND column_name = 'start_date'
  ) THEN
    ALTER TABLE challenges ADD COLUMN start_date DATE;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'challenges' AND column_name = 'end_date'
  ) THEN
    ALTER TABLE challenges ADD COLUMN end_date DATE;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'challenges' AND column_name = 'icon'
  ) THEN
    ALTER TABLE challenges ADD COLUMN icon TEXT;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'challenges' AND column_name = 'category'
  ) THEN
    ALTER TABLE challenges ADD COLUMN category TEXT;
  END IF;
  
  -- Drop NOT NULL constraints if they exist
  BEGIN
    ALTER TABLE challenges ALTER COLUMN start_date DROP NOT NULL;
  EXCEPTION
    WHEN undefined_column THEN NULL;
    WHEN others THEN NULL;
  END;
  
  BEGIN
    ALTER TABLE challenges ALTER COLUMN end_date DROP NOT NULL;
  EXCEPTION
    WHEN undefined_column THEN NULL;
    WHEN others THEN NULL;
  END;
  
  BEGIN
    ALTER TABLE challenges ALTER COLUMN icon DROP NOT NULL;
  EXCEPTION
    WHEN undefined_column THEN NULL;
    WHEN others THEN NULL;
  END;
  
  BEGIN
    ALTER TABLE challenges ALTER COLUMN category DROP NOT NULL;
  EXCEPTION
    WHEN undefined_column THEN NULL;
    WHEN others THEN NULL;
  END;
  
  BEGIN
    ALTER TABLE challenges ALTER COLUMN name DROP NOT NULL;
  EXCEPTION
    WHEN undefined_column THEN NULL;
    WHEN others THEN NULL;
  END;
END $$;

-- user_challenges: progress per user
CREATE TABLE IF NOT EXISTS user_challenges (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID NOT NULL,
  challenge_id BIGINT NOT NULL REFERENCES challenges(id) ON DELETE CASCADE,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE(user_id, challenge_id)
);

-- Add missing columns if they don't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'user_challenges' AND column_name = 'current_progress'
  ) THEN
    ALTER TABLE user_challenges ADD COLUMN current_progress INTEGER DEFAULT 0;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'user_challenges' AND column_name = 'is_completed'
  ) THEN
    ALTER TABLE user_challenges ADD COLUMN is_completed BOOLEAN DEFAULT false;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'user_challenges' AND column_name = 'completed_at'
  ) THEN
    ALTER TABLE user_challenges ADD COLUMN completed_at TIMESTAMP WITH TIME ZONE;
  END IF;
END $$;

-- Insert initial achievements (idempotent)
INSERT INTO achievements (key, title, description, points)
VALUES
  ('first_steps', 'First Steps', 'Log your first meal', 10),
  ('week_warrior', 'Week Warrior', '7-day logging streak', 50),
  ('month_master', 'Month Master', '30-day logging streak', 200),
  ('century_club', 'Century Club', 'Log 100 meals', 300),
  ('consistency_king', 'Consistency King', '50-day streak', 150),
  ('nutrition_ninja', 'Nutrition Ninja', 'Log 500 meals', 1000)
ON CONFLICT (key) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  points = EXCLUDED.points;

-- Insert initial challenges (idempotent)
INSERT INTO challenges (key, title, name, description, challenge_type, target_value, reward_points)
VALUES
  ('protein_power_week', 'Protein Power Week', 'Protein Power Week', 'Log at least 100g of protein in a single day', 'weekly', 100, 100),
  ('7_day_streak', '7-Day Streak Challenge', '7-Day Streak Challenge', 'Log your meals for 7 consecutive days', 'weekly', 7, 100),
  ('hydration_hero_week', 'Hydration Hero', 'Hydration Hero', 'Drink 8 glasses of water daily for a week', 'water_days', 7, 150),
  ('hydration_hero_daily', 'Hydration Hero', 'Hydration Hero', 'Track your water intake for 5 days', 'daily', 5, 50),
  ('7_day_streak_2', '7-Day Streak Challenge', '7-Day Streak Challenge', 'Log meals for 7 consecutive days', 'streak', 7, 150),
  ('protein_power_days', 'Protein Power Week', 'Protein Power Week', 'Hit your protein goal 5 times this week', 'protein_days', 5, 150)
ON CONFLICT (key) DO UPDATE SET
  title = EXCLUDED.title,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  challenge_type = EXCLUDED.challenge_type,
  target_value = EXCLUDED.target_value,
  reward_points = EXCLUDED.reward_points;

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

-- Trigger to check challenges after meal insert
CREATE OR REPLACE FUNCTION trigger_check_challenges_on_meal()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM check_and_update_challenges(NEW.user_id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_challenges_after_meal ON meals;
CREATE TRIGGER check_challenges_after_meal
AFTER INSERT ON meals
FOR EACH ROW
EXECUTE PROCEDURE trigger_check_challenges_on_meal();

-- Trigger to check challenges after water log insert
CREATE OR REPLACE FUNCTION trigger_check_challenges_on_water()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM check_and_update_challenges(NEW.user_id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_challenges_after_water ON water_logs;
CREATE TRIGGER check_challenges_after_water
AFTER INSERT ON water_logs
FOR EACH ROW
EXECUTE PROCEDURE trigger_check_challenges_on_water();

-- Function to check and update challenge progress
CREATE OR REPLACE FUNCTION check_and_update_challenges(p_user_id UUID)
RETURNS void AS $$
DECLARE
  user_stat RECORD;
  challenge RECORD;
  user_challenge RECORD;
  protein_today INTEGER;
  water_days_count INTEGER;
  protein_days_count INTEGER;
BEGIN
  -- Get user stats
  SELECT * INTO user_stat FROM user_stats WHERE user_id = p_user_id;
  
  IF NOT FOUND THEN
    RETURN;
  END IF;

  -- Loop through all challenges
  FOR challenge IN SELECT * FROM challenges LOOP
    -- Get or create user_challenge record
    SELECT * INTO user_challenge 
    FROM user_challenges 
    WHERE user_id = p_user_id AND challenge_id = challenge.id;
    
    IF NOT FOUND THEN
      INSERT INTO user_challenges(user_id, challenge_id, current_progress, is_completed)
      VALUES(p_user_id, challenge.id, 0, false)
      RETURNING * INTO user_challenge;
    END IF;
    
    -- Skip if already completed
    IF user_challenge.is_completed THEN
      CONTINUE;
    END IF;
    
    -- Check progress based on challenge type
    CASE challenge.challenge_type
      WHEN 'weekly' THEN
        -- For weekly challenges based on total meals in past 7 days
        IF challenge.key LIKE '%protein%' THEN
          -- Check protein for today
          SELECT COALESCE(SUM(protein), 0) INTO protein_today
          FROM meals
          WHERE user_id = p_user_id AND meal_date = CURRENT_DATE;
          
          UPDATE user_challenges
          SET current_progress = protein_today,
              is_completed = (protein_today >= challenge.target_value),
              completed_at = CASE WHEN protein_today >= challenge.target_value THEN now() ELSE NULL END,
              updated_at = now()
          WHERE id = user_challenge.id;
        END IF;
        
      WHEN 'streak' THEN
        -- Check current streak
        UPDATE user_challenges
        SET current_progress = user_stat.current_streak,
            is_completed = (user_stat.current_streak >= challenge.target_value),
            completed_at = CASE WHEN user_stat.current_streak >= challenge.target_value THEN now() ELSE NULL END,
            updated_at = now()
        WHERE id = user_challenge.id;
        
      WHEN 'water_days' THEN
        -- Count days with 8+ water logs (assuming ~250ml per glass)
        SELECT COUNT(DISTINCT DATE(logged_at)) INTO water_days_count
        FROM water_logs
        WHERE user_id = p_user_id 
          AND logged_at >= CURRENT_DATE - INTERVAL '7 days'
        GROUP BY user_id
        HAVING SUM(amount_ml) >= 2000; -- 8 glasses * 250ml
        
        UPDATE user_challenges
        SET current_progress = COALESCE(water_days_count, 0),
            is_completed = (COALESCE(water_days_count, 0) >= challenge.target_value),
            completed_at = CASE WHEN COALESCE(water_days_count, 0) >= challenge.target_value THEN now() ELSE NULL END,
            updated_at = now()
        WHERE id = user_challenge.id;
        
      WHEN 'daily' THEN
        -- Count distinct days with water logs
        SELECT COUNT(DISTINCT DATE(logged_at)) INTO water_days_count
        FROM water_logs
        WHERE user_id = p_user_id 
          AND logged_at >= CURRENT_DATE - INTERVAL '7 days';
        
        UPDATE user_challenges
        SET current_progress = COALESCE(water_days_count, 0),
            is_completed = (COALESCE(water_days_count, 0) >= challenge.target_value),
            completed_at = CASE WHEN COALESCE(water_days_count, 0) >= challenge.target_value THEN now() ELSE NULL END,
            updated_at = now()
        WHERE id = user_challenge.id;
        
      WHEN 'protein_days' THEN
        -- Count days with 100g+ protein in past week
        SELECT COUNT(*) INTO protein_days_count
        FROM (
          SELECT DATE(meal_date), SUM(protein) as daily_protein
          FROM meals
          WHERE user_id = p_user_id 
            AND meal_date >= CURRENT_DATE - INTERVAL '7 days'
          GROUP BY DATE(meal_date)
          HAVING SUM(protein) >= 100
        ) AS protein_days;
        
        UPDATE user_challenges
        SET current_progress = COALESCE(protein_days_count, 0),
            is_completed = (COALESCE(protein_days_count, 0) >= challenge.target_value),
            completed_at = CASE WHEN COALESCE(protein_days_count, 0) >= challenge.target_value THEN now() ELSE NULL END,
            updated_at = now()
        WHERE id = user_challenge.id;
        
      ELSE
        -- Default: do nothing
        NULL;
    END CASE;
    
    -- Award points if just completed
    IF user_challenge.is_completed = false THEN
      SELECT * INTO user_challenge 
      FROM user_challenges 
      WHERE user_id = p_user_id AND challenge_id = challenge.id;
      
      IF user_challenge.is_completed THEN
        UPDATE user_stats
        SET points = points + challenge.reward_points
        WHERE user_id = p_user_id;
      END IF;
    END IF;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

COMMIT;

-- End of setup_gamification.sql
