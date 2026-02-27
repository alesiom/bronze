-- Migration: Fix corrupted Instagram handles from initial seed
-- Run with: docker exec -i bronze-db psql -U postgres -d neve26 -f - < migrations/086_fix_athlete_handles.sql

UPDATE athlete_social SET instagram_handle = 'laragutbehrami' WHERE athlete_slug = 'lara-gut-behrami';
UPDATE athlete_social SET instagram_handle = 'halvorgranerud' WHERE athlete_slug = 'halvor-egner-granerud';
UPDATE athlete_social SET instagram_handle = 'zankranjec' WHERE athlete_slug = 'zan-kranjec';
