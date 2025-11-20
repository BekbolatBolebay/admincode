-- CAUTION: This script drops all tables and data to start fresh
-- Run this ONLY if you want to completely reset your database

DROP TRIGGER IF EXISTS on_admin_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_admin_user();

DROP TABLE IF EXISTS doctors CASCADE;
DROP TABLE IF EXISTS services CASCADE;
DROP TABLE IF EXISTS news CASCADE;
DROP TABLE IF EXISTS admin_users CASCADE;

-- Drop any existing policies (just in case)
-- Note: Dropping tables usually drops policies, but this is for safety
