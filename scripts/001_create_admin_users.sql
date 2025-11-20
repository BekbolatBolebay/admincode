-- Create admin_users table to manage admin access
CREATE TABLE IF NOT EXISTS admin_users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  full_name TEXT,
  role TEXT DEFAULT 'admin',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;

-- Drop existing policies to prevent errors on re-run
DROP POLICY IF EXISTS "Admin users can view their own profile" ON admin_users;
DROP POLICY IF EXISTS "Admin users can update their own profile" ON admin_users;

-- Admin users can view their own profile
CREATE POLICY "Admin users can view their own profile"
  ON admin_users FOR SELECT
  USING (auth.uid() = id);

-- Admin users can update their own profile
CREATE POLICY "Admin users can update their own profile"
  ON admin_users FOR UPDATE
  USING (auth.uid() = id);
