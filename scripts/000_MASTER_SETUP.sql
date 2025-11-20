-- MASTER SETUP SCRIPT
-- Runs all necessary setup steps in one go.
-- WARNING: This will reset your database tables!

-- 1. CLEANUP (Drop existing tables to start fresh)
DROP TRIGGER IF EXISTS on_admin_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_admin_user();
DROP TABLE IF EXISTS doctors CASCADE;
DROP TABLE IF EXISTS services CASCADE;
DROP TABLE IF EXISTS news CASCADE;
DROP TABLE IF EXISTS admin_users CASCADE;

-- 2. CREATE ADMIN USERS TABLE
CREATE TABLE admin_users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  full_name TEXT,
  role TEXT DEFAULT 'admin',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admin users can view their own profile"
  ON admin_users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Admin users can update their own profile"
  ON admin_users FOR UPDATE
  USING (auth.uid() = id);

-- 3. CREATE NEWS TABLE
CREATE TABLE news (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  subtitle TEXT,
  content TEXT NOT NULL,
  author TEXT NOT NULL,
  category TEXT NOT NULL,
  image_url TEXT,
  published_date DATE NOT NULL,
  status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE news ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view news"
  ON news FOR SELECT
  USING (auth.uid() IN (SELECT id FROM admin_users));

CREATE POLICY "Authenticated users can insert news"
  ON news FOR INSERT
  WITH CHECK (auth.uid() IN (SELECT id FROM admin_users));

CREATE POLICY "Authenticated users can update news"
  ON news FOR UPDATE
  USING (auth.uid() IN (SELECT id FROM admin_users));

CREATE POLICY "Authenticated users can delete news"
  ON news FOR DELETE
  USING (auth.uid() IN (SELECT id FROM admin_users));

CREATE INDEX idx_news_status ON news(status);
CREATE INDEX idx_news_published_date ON news(published_date DESC);

-- 4. CREATE SERVICES TABLE
CREATE TABLE services (
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

ALTER TABLE services ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view services"
  ON services FOR SELECT
  USING (auth.uid() IN (SELECT id FROM admin_users));

CREATE POLICY "Authenticated users can insert services"
  ON services FOR INSERT
  WITH CHECK (auth.uid() IN (SELECT id FROM admin_users));

CREATE POLICY "Authenticated users can update services"
  ON services FOR UPDATE
  USING (auth.uid() IN (SELECT id FROM admin_users));

CREATE POLICY "Authenticated users can delete services"
  ON services FOR DELETE
  USING (auth.uid() IN (SELECT id FROM admin_users));

CREATE INDEX idx_services_status ON services(status);

-- 5. CREATE DOCTORS TABLE
CREATE TABLE doctors (
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

ALTER TABLE doctors ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view doctors"
  ON doctors FOR SELECT
  USING (auth.uid() IN (SELECT id FROM admin_users));

CREATE POLICY "Authenticated users can insert doctors"
  ON doctors FOR INSERT
  WITH CHECK (auth.uid() IN (SELECT id FROM admin_users));

CREATE POLICY "Authenticated users can update doctors"
  ON doctors FOR UPDATE
  USING (auth.uid() IN (SELECT id FROM admin_users));

CREATE POLICY "Authenticated users can delete doctors"
  ON doctors FOR DELETE
  USING (auth.uid() IN (SELECT id FROM admin_users));

CREATE INDEX idx_doctors_status ON doctors(status);
CREATE INDEX idx_doctors_specialization ON doctors(specialization);

-- 6. CREATE TRIGGER FOR NEW USERS
CREATE OR REPLACE FUNCTION public.handle_new_admin_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.admin_users (id, email, full_name)
  VALUES (
    new.id,
    new.email,
    COALESCE(new.raw_user_meta_data ->> 'full_name', NULL)
  )
  ON CONFLICT (id) DO NOTHING;

  RETURN new;
END;
$$;

CREATE TRIGGER on_admin_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_admin_user();

-- 7. SEED SAMPLE DATA
INSERT INTO news (title, subtitle, content, author, category, published_date, status, image_url)
VALUES 
  ('Advanced Cardiac Care Now Available', 'State-of-the-art cardiology department opens', 'We are excited to announce the opening of our new cardiology department...', 'Dr. Sarah Johnson', 'Healthcare', CURRENT_DATE - INTERVAL '5 days', 'published', '/placeholder.svg?height=400&width=600'),
  ('New MRI Scanner Installation Complete', 'Enhanced diagnostic capabilities', 'Our facility now features a cutting-edge 3T MRI scanner...', 'Dr. Michael Chen', 'Technology', CURRENT_DATE - INTERVAL '3 days', 'published', '/placeholder.svg?height=400&width=600'),
  ('Free Health Screening Camp This Weekend', 'Community health initiative', 'Join us for a comprehensive health screening...', 'Admin Team', 'Community', CURRENT_DATE + INTERVAL '2 days', 'published', '/placeholder.svg?height=400&width=600');

INSERT INTO services (name, description, category, features, status, icon)
VALUES 
  ('Emergency Care', 'Round-the-clock emergency medical services', 'Emergency', ARRAY['24/7 Availability', 'Trauma Center'], 'active', 'activity'),
  ('Diagnostic Imaging', 'Comprehensive imaging services', 'Diagnostics', ARRAY['X-Ray', 'CT Scan', 'MRI'], 'active', 'scan'),
  ('Cardiology', 'Comprehensive heart care', 'Specialty', ARRAY['ECG', 'Echo', 'Stress Tests'], 'active', 'heart-pulse');

INSERT INTO doctors (full_name, specialization, qualifications, experience_years, email, phone, bio, status, image_url)
VALUES 
  ('Dr. Sarah Johnson', 'Cardiology', 'MD, DM (Cardiology)', 15, 'sarah.johnson@hospital.com', '+1-555-0101', 'Board-certified cardiologist...', 'active', '/placeholder.svg?height=300&width=300'),
  ('Dr. Michael Chen', 'Radiology', 'MD, DNB (Radiology)', 12, 'michael.chen@hospital.com', '+1-555-0102', 'Specializing in diagnostic radiology...', 'active', '/placeholder.svg?height=300&width=300');
