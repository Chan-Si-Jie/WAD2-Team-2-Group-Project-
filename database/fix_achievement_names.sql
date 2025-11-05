-- fix_achievement_names.sql
-- Updates achievements with NULL names, setting name = title when name is missing
-- Ensures uniqueness by appending description or row number if needed

BEGIN;

-- Update achievements where name is NULL
-- Use title as base, but ensure uniqueness by appending description suffix
UPDATE achievements
SET name = CASE 
  WHEN title IS NOT NULL THEN 
    title || ' - ' || COALESCE(SUBSTRING(description, 1, 20), id::text)
  ELSE 
    'Achievement - ' || id::text
END
WHERE name IS NULL;

COMMIT;

-- Display results
SELECT 'Achievement names fixed!' as status;
SELECT id, name, title, description 
FROM achievements 
ORDER BY created_at;
