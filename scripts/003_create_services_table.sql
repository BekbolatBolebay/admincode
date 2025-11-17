-- Create services table
CREATE TABLE IF NOT EXISTS services (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  icon TEXT,
  category TEXT NOT NULL,
  features TEXT[],
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE services ENABLE ROW LEVEL SECURITY;

-- Only authenticated admin users can view services
CREATE POLICY "Authenticated users can view services"
  ON services FOR SELECT
  USING (auth.uid() IN (SELECT id FROM admin_users));

-- Only authenticated admin users can insert services
CREATE POLICY "Authenticated users can insert services"
  ON services FOR INSERT
  WITH CHECK (auth.uid() IN (SELECT id FROM admin_users));

-- Only authenticated admin users can update services
CREATE POLICY "Authenticated users can update services"
  ON services FOR UPDATE
  USING (auth.uid() IN (SELECT id FROM admin_users));

-- Only authenticated admin users can delete services
CREATE POLICY "Authenticated users can delete services"
  ON services FOR DELETE
  USING (auth.uid() IN (SELECT id FROM admin_users));

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_services_status ON services(status);
