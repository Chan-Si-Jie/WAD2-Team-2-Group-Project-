-- Add missing columns to user_challenges, user_stats, and meals tables

-- Add meal_date column to meals table if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'meals' AND column_name = 'meal_date'
  ) THEN
    -- Add the column
    ALTER TABLE meals ADD COLUMN meal_date DATE;
    -- Copy existing date values to meal_date
    UPDATE meals SET meal_date = date WHERE meal_date IS NULL;
  END IF;
END $$;

-- Add protein column to meals table if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'meals' AND column_name = 'protein'
  ) THEN
    ALTER TABLE meals ADD COLUMN protein INTEGER DEFAULT 0;
  END IF;
END $$;

-- Add carbs column to meals table if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'meals' AND column_name = 'carbs'
  ) THEN
    ALTER TABLE meals ADD COLUMN carbs INTEGER DEFAULT 0;
  END IF;
END $$;

-- Add fat column to meals table if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'meals' AND column_name = 'fat'
  ) THEN
    ALTER TABLE meals ADD COLUMN fat INTEGER DEFAULT 0;
  END IF;
END $$;

-- Add logged_at column to meals table if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'meals' AND column_name = 'logged_at'
  ) THEN
    ALTER TABLE meals ADD COLUMN logged_at TIMESTAMP WITH TIME ZONE DEFAULT now();
  END IF;
END $$;

-- Add logged_at column to water_logs table if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'water_logs' AND column_name = 'logged_at'
  ) THEN
    ALTER TABLE water_logs ADD COLUMN logged_at TIMESTAMP WITH TIME ZONE DEFAULT now();
  END IF;
END $$;

-- Add logged_at column to nutrition table if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'nutrition' AND column_name = 'logged_at'
  ) THEN
    ALTER TABLE nutrition ADD COLUMN logged_at TIMESTAMP WITH TIME ZONE DEFAULT now();
  END IF;
END $$;

-- Add updated_at column to user_challenges if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'user_challenges' AND column_name = 'updated_at'
  ) THEN
    ALTER TABLE user_challenges ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT now();
  END IF;
END $$;

-- Add other potentially missing columns for user_challenges
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'user_challenges' AND column_name = 'current_progress'
  ) THEN
    ALTER TABLE user_challenges ADD COLUMN current_progress INTEGER DEFAULT 0;
  END IF;
END $$;

DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'user_challenges' AND column_name = 'is_completed'
  ) THEN
    ALTER TABLE user_challenges ADD COLUMN is_completed BOOLEAN DEFAULT false;
  END IF;
END $$;

DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'user_challenges' AND column_name = 'completed_at'
  ) THEN
    ALTER TABLE user_challenges ADD COLUMN completed_at TIMESTAMP WITH TIME ZONE;
  END IF;
END $$;

-- Add missing columns to user_stats table
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'user_stats' AND column_name = 'points'
  ) THEN
    ALTER TABLE user_stats ADD COLUMN points INTEGER DEFAULT 0;
  END IF;
END $$;

DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'user_stats' AND column_name = 'total_meals'
  ) THEN
    ALTER TABLE user_stats ADD COLUMN total_meals INTEGER DEFAULT 0;
  END IF;
END $$;

DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'user_stats' AND column_name = 'current_streak'
  ) THEN
    ALTER TABLE user_stats ADD COLUMN current_streak INTEGER DEFAULT 0;
  END IF;
END $$;

DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'user_stats' AND column_name = 'longest_streak'
  ) THEN
    ALTER TABLE user_stats ADD COLUMN longest_streak INTEGER DEFAULT 0;
  END IF;
END $$;

DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'user_stats' AND column_name = 'last_meal_date'
  ) THEN
    ALTER TABLE user_stats ADD COLUMN last_meal_date DATE;
  END IF;
END $$;

DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'user_stats' AND column_name = 'updated_at'
  ) THEN
    ALTER TABLE user_stats ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT now();
  END IF;
END $$;

