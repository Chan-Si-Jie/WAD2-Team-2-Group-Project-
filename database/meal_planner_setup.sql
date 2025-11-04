-- Supabase Database Setup for Meal Planner Feature
-- Run these SQL commands in your Supabase SQL Editor

-- 1. Recipes Table
CREATE TABLE IF NOT EXISTS recipes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  total_calories INTEGER DEFAULT 0,
  total_protein DECIMAL(10,2) DEFAULT 0,
  total_carbs DECIMAL(10,2) DEFAULT 0,
  total_fat DECIMAL(10,2) DEFAULT 0,
  ingredients JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Planned Meals Table
CREATE TABLE IF NOT EXISTS planned_meals (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  meal_type TEXT NOT NULL CHECK (meal_type IN ('Breakfast', 'Lunch', 'Dinner', 'Snack')),
  name TEXT NOT NULL,
  calories INTEGER DEFAULT 0,
  protein DECIMAL(10,2) DEFAULT 0,
  carbs DECIMAL(10,2) DEFAULT 0,
  fat DECIMAL(10,2) DEFAULT 0,
  recipe_id UUID REFERENCES recipes(id) ON DELETE SET NULL,
  favorite_id UUID REFERENCES favorite_meals(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Favorite Meals Table
CREATE TABLE IF NOT EXISTS favorite_meals (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  calories INTEGER DEFAULT 0,
  protein DECIMAL(10,2) DEFAULT 0,
  carbs DECIMAL(10,2) DEFAULT 0,
  fat DECIMAL(10,2) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Shopping List Table
CREATE TABLE IF NOT EXISTS shopping_list (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  ingredient TEXT NOT NULL,
  checked BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security (RLS)
ALTER TABLE recipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE planned_meals ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorite_meals ENABLE ROW LEVEL SECURITY;
ALTER TABLE shopping_list ENABLE ROW LEVEL SECURITY;

-- RLS Policies for recipes
CREATE POLICY "Users can view own recipes" ON recipes
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own recipes" ON recipes
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own recipes" ON recipes
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own recipes" ON recipes
  FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for planned_meals
CREATE POLICY "Users can view own planned meals" ON planned_meals
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own planned meals" ON planned_meals
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own planned meals" ON planned_meals
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own planned meals" ON planned_meals
  FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for favorite_meals
CREATE POLICY "Users can view own favorites" ON favorite_meals
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own favorites" ON favorite_meals
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own favorites" ON favorite_meals
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own favorites" ON favorite_meals
  FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for shopping_list
CREATE POLICY "Users can view own shopping list" ON shopping_list
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own shopping items" ON shopping_list
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own shopping items" ON shopping_list
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own shopping items" ON shopping_list
  FOR DELETE USING (auth.uid() = user_id);

-- Create indexes for better performance
CREATE INDEX idx_recipes_user_id ON recipes(user_id);
CREATE INDEX idx_planned_meals_user_date ON planned_meals(user_id, date);
CREATE INDEX idx_favorite_meals_user_id ON favorite_meals(user_id);
CREATE INDEX idx_shopping_list_user_id ON shopping_list(user_id);
