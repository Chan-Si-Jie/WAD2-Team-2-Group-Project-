-- fix_duplicate_achievements.sql
-- Removes duplicate achievement rows (keeps smallest id per key/title)

BEGIN;

-- Delete duplicates by key, keeping the row with the smallest id
DELETE FROM achievements a
USING achievements a2
WHERE a.id > a2.id
  AND a.key = a2.key;

-- As an extra precaution, also dedupe by title
DELETE FROM achievements a
USING achievements a2
WHERE a.id > a2.id
  AND a.title = a2.title;

COMMIT;

-- End of fix_duplicate_achievements.sql
