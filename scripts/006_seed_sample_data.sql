-- Seed sample data for testing
-- Uses WHERE NOT EXISTS to prevent duplicates on re-runs

-- Sample news items
INSERT INTO news (title, subtitle, content, author, category, published_date, status, image_url)
SELECT 
  'Advanced Cardiac Care Now Available', 
  'State-of-the-art cardiology department opens', 
  'We are excited to announce the opening of our new cardiology department with the latest technology...', 
  'Dr. Sarah Johnson', 
  'Healthcare', 
  CURRENT_DATE - INTERVAL '5 days', 
  'published', 
  '/placeholder.svg?height=400&width=600'
WHERE NOT EXISTS (SELECT 1 FROM news WHERE title = 'Advanced Cardiac Care Now Available');

INSERT INTO news (title, subtitle, content, author, category, published_date, status, image_url)
SELECT 
  'New MRI Scanner Installation Complete', 
  'Enhanced diagnostic capabilities', 
  'Our facility now features a cutting-edge 3T MRI scanner providing superior image quality...', 
  'Dr. Michael Chen', 
  'Technology', 
  CURRENT_DATE - INTERVAL '3 days', 
  'published', 
  '/placeholder.svg?height=400&width=600'
WHERE NOT EXISTS (SELECT 1 FROM news WHERE title = 'New MRI Scanner Installation Complete');

INSERT INTO news (title, subtitle, content, author, category, published_date, status, image_url)
SELECT 
  'Free Health Screening Camp This Weekend', 
  'Community health initiative', 
  'Join us for a comprehensive health screening including blood pressure, diabetes, and cholesterol tests...', 
  'Admin Team', 
  'Community', 
  CURRENT_DATE + INTERVAL '2 days', 
  'published', 
  '/placeholder.svg?height=400&width=600'
WHERE NOT EXISTS (SELECT 1 FROM news WHERE title = 'Free Health Screening Camp This Weekend');

-- Sample services
INSERT INTO services (name, description, category, features, status, icon)
SELECT 
  'Emergency Care', 
  'Round-the-clock emergency medical services with specialized trauma care', 
  'Emergency', 
  ARRAY['24/7 Availability', 'Trauma Center', 'Ambulance Service', 'Critical Care'], 
  'active', 
  'activity'
WHERE NOT EXISTS (SELECT 1 FROM services WHERE name = 'Emergency Care');

INSERT INTO services (name, description, category, features, status, icon)
SELECT 
  'Diagnostic Imaging', 
  'Comprehensive imaging services including X-Ray, CT, MRI, and Ultrasound', 
  'Diagnostics', 
  ARRAY['X-Ray', 'CT Scan', 'MRI', 'Ultrasound', 'Mammography'], 
  'active', 
  'scan'
WHERE NOT EXISTS (SELECT 1 FROM services WHERE name = 'Diagnostic Imaging');

INSERT INTO services (name, description, category, features, status, icon)
SELECT 
  'Laboratory Services', 
  'Full-service laboratory with advanced testing capabilities', 
  'Diagnostics', 
  ARRAY['Blood Tests', 'Pathology', 'Microbiology', 'Quick Results'], 
  'active', 
  'flask-conical'
WHERE NOT EXISTS (SELECT 1 FROM services WHERE name = 'Laboratory Services');

INSERT INTO services (name, description, category, features, status, icon)
SELECT 
  'Cardiology', 
  'Comprehensive heart care and cardiovascular services', 
  'Specialty', 
  ARRAY['ECG', 'Echo', 'Stress Tests', 'Cardiac Catheterization'], 
  'active', 
  'heart-pulse'
WHERE NOT EXISTS (SELECT 1 FROM services WHERE name = 'Cardiology');

-- Sample doctors
INSERT INTO doctors (full_name, specialization, qualifications, experience_years, email, phone, bio, status, image_url)
SELECT 
  'Dr. Sarah Johnson', 
  'Cardiology', 
  'MD, DM (Cardiology), FACC', 
  15, 
  'sarah.johnson@hospital.com', 
  '+1-555-0101', 
  'Dr. Johnson is a board-certified cardiologist with extensive experience in interventional cardiology and heart failure management.', 
  'active', 
  '/placeholder.svg?height=300&width=300'
WHERE NOT EXISTS (SELECT 1 FROM doctors WHERE email = 'sarah.johnson@hospital.com');

INSERT INTO doctors (full_name, specialization, qualifications, experience_years, email, phone, bio, status, image_url)
SELECT 
  'Dr. Michael Chen', 
  'Radiology', 
  'MD, DNB (Radiology)', 
  12, 
  'michael.chen@hospital.com', 
  '+1-555-0102', 
  'Specializing in diagnostic and interventional radiology with a focus on advanced imaging techniques.', 
  'active', 
  '/placeholder.svg?height=300&width=300'
WHERE NOT EXISTS (SELECT 1 FROM doctors WHERE email = 'michael.chen@hospital.com');

INSERT INTO doctors (full_name, specialization, qualifications, experience_years, email, phone, bio, status, image_url)
SELECT 
  'Dr. Priya Sharma', 
  'Pediatrics', 
  'MD, DCH, Fellowship in Pediatric Intensive Care', 
  10, 
  'priya.sharma@hospital.com', 
  '+1-555-0103', 
  'Dedicated pediatrician with expertise in neonatal and pediatric critical care.', 
  'active', 
  '/placeholder.svg?height=300&width=300'
WHERE NOT EXISTS (SELECT 1 FROM doctors WHERE email = 'priya.sharma@hospital.com');

INSERT INTO doctors (full_name, specialization, qualifications, experience_years, email, phone, bio, status, image_url)
SELECT 
  'Dr. James Wilson', 
  'Orthopedics', 
  'MS (Ortho), DNB, MRCS', 
  18, 
  'james.wilson@hospital.com', 
  '+1-555-0104', 
  'Experienced orthopedic surgeon specializing in joint replacement and sports medicine.', 
  'active', 
  '/placeholder.svg?height=300&width=300'
WHERE NOT EXISTS (SELECT 1 FROM doctors WHERE email = 'james.wilson@hospital.com');
