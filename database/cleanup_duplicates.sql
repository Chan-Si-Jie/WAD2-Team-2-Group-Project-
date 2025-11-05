-- cleanup_duplicates.sql
-- Removes duplicate achievements and challenges from the database
-- Compares by description only - if descriptions match, removes duplicates
-- Keeps only one record for each unique description

BEGIN;

-- Clean up duplicate achievements based on description only
-- Uses ROW_NUMBER to identify duplicates, keeps the first one
DELETE FROM achievements 
WHERE id IN (
  SELECT id
  FROM (
    SELECT id,
           ROW_NUMBER() OVER (
             PARTITION BY COALESCE(description, '')
             ORDER BY created_at ASC, id
           ) AS rn
    FROM achievements
  ) sub
  WHERE rn > 1
);

-- Clean up duplicate challenges based on description only
-- Uses ROW_NUMBER to identify duplicates, keeps the first one
DELETE FROM challenges 
WHERE id IN (
  SELECT id
  FROM (
    SELECT id,
           ROW_NUMBER() OVER (
             PARTITION BY COALESCE(description, '')
             ORDER BY created_at ASC, id
           ) AS rn
    FROM challenges
  ) sub
  WHERE rn > 1
);

COMMIT;

-- Display results
SELECT 'Cleanup completed!' as status;
SELECT COUNT(*) as total_achievements FROM achievements;
SELECT COUNT(*) as total_challenges FROM challenges;
