-- Create doctors table
CREATE TABLE IF NOT EXISTS doctors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name TEXT NOT NULL,
  specialization TEXT NOT NULL,
  qualifications TEXT NOT NULL,
  experience_years INTEGER NOT NULL,
  email TEXT,
  phone TEXT,
  bio TEXT,
  image_url TEXT,
  availability_schedule JSONB,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'on_leave')),
  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE doctors ENABLE ROW LEVEL SECURITY;

-- Only authenticated admin users can view doctors
CREATE POLICY "Authenticated users can view doctors"
  ON doctors FOR SELECT
  USING (auth.uid() IN (SELECT id FROM admin_users));

-- Only authenticated admin users can insert doctors
CREATE POLICY "Authenticated users can insert doctors"
  ON doctors FOR INSERT
  WITH CHECK (auth.uid() IN (SELECT id FROM admin_users));

-- Only authenticated admin users can update doctors
CREATE POLICY "Authenticated users can update doctors"
  ON doctors FOR UPDATE
  USING (auth.uid() IN (SELECT id FROM admin_users));

-- Only authenticated admin users can delete doctors
CREATE POLICY "Authenticated users can delete doctors"
  ON doctors FOR DELETE
  USING (auth.uid() IN (SELECT id FROM admin_users));

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_doctors_status ON doctors(status);
CREATE INDEX IF NOT EXISTS idx_doctors_specialization ON doctors(specialization);
