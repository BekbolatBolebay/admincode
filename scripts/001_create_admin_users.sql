-- Create admin_users table
CREATE TABLE IF NOT EXISTS public.admin_users (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email text NOT NULL UNIQUE,
  full_name text,
  role text DEFAULT 'admin',
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.admin_users ENABLE ROW LEVEL SECURITY;

-- Allow admins to view only themselves
CREATE POLICY "Allow admin to view themselves"
  ON public.admin_users
  FOR SELECT
  USING (auth.uid() = id);

-- Allow admins to update only themselves
CREATE POLICY "Allow admin to update themselves"
  ON public.admin_users
  FOR UPDATE
  USING (auth.uid() = id);
