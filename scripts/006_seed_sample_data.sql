-- Seed sample data for testing (only run after first admin user signs up)
-- This script will fail if no admin user exists yet, which is expected

-- Sample news items
INSERT INTO news (title, subtitle, content, author, category, published_date, status, image_url)
VALUES 
  ('Advanced Cardiac Care Now Available', 'State-of-the-art cardiology department opens', 'We are excited to announce the opening of our new cardiology department with the latest technology...', 'Dr. Sarah Johnson', 'Healthcare', CURRENT_DATE - INTERVAL '5 days', 'published', '/placeholder.svg?height=400&width=600'),
  ('New MRI Scanner Installation Complete', 'Enhanced diagnostic capabilities', 'Our facility now features a cutting-edge 3T MRI scanner providing superior image quality...', 'Dr. Michael Chen', 'Technology', CURRENT_DATE - INTERVAL '3 days', 'published', '/placeholder.svg?height=400&width=600'),
  ('Free Health Screening Camp This Weekend', 'Community health initiative', 'Join us for a comprehensive health screening including blood pressure, diabetes, and cholesterol tests...', 'Admin Team', 'Community', CURRENT_DATE + INTERVAL '2 days', 'published', '/placeholder.svg?height=400&width=600')
ON CONFLICT DO NOTHING;

-- Sample services
INSERT INTO services (name, description, category, features, status, icon)
VALUES 
  ('Emergency Care', 'Round-the-clock emergency medical services with specialized trauma care', 'Emergency', ARRAY['24/7 Availability', 'Trauma Center', 'Ambulance Service', 'Critical Care'], 'active', 'activity'),
  ('Diagnostic Imaging', 'Comprehensive imaging services including X-Ray, CT, MRI, and Ultrasound', 'Diagnostics', ARRAY['X-Ray', 'CT Scan', 'MRI', 'Ultrasound', 'Mammography'], 'active', 'scan'),
  ('Laboratory Services', 'Full-service laboratory with advanced testing capabilities', 'Diagnostics', ARRAY['Blood Tests', 'Pathology', 'Microbiology', 'Quick Results'], 'active', 'flask-conical'),
  ('Cardiology', 'Comprehensive heart care and cardiovascular services', 'Specialty', ARRAY['ECG', 'Echo', 'Stress Tests', 'Cardiac Catheterization'], 'active', 'heart-pulse')
ON CONFLICT DO NOTHING;

-- Sample doctors
INSERT INTO doctors (full_name, specialization, qualifications, experience_years, email, phone, bio, status, image_url)
VALUES 
  ('Dr. Sarah Johnson', 'Cardiology', 'MD, DM (Cardiology), FACC', 15, 'sarah.johnson@hospital.com', '+1-555-0101', 'Dr. Johnson is a board-certified cardiologist with extensive experience in interventional cardiology and heart failure management.', 'active', '/placeholder.svg?height=300&width=300'),
  ('Dr. Michael Chen', 'Radiology', 'MD, DNB (Radiology)', 12, 'michael.chen@hospital.com', '+1-555-0102', 'Specializing in diagnostic and interventional radiology with a focus on advanced imaging techniques.', 'active', '/placeholder.svg?height=300&width=300'),
  ('Dr. Priya Sharma', 'Pediatrics', 'MD, DCH, Fellowship in Pediatric Intensive Care', 10, 'priya.sharma@hospital.com', '+1-555-0103', 'Dedicated pediatrician with expertise in neonatal and pediatric critical care.', 'active', '/placeholder.svg?height=300&width=300'),
  ('Dr. James Wilson', 'Orthopedics', 'MS (Ortho), DNB, MRCS', 18, 'james.wilson@hospital.com', '+1-555-0104', 'Experienced orthopedic surgeon specializing in joint replacement and sports medicine.', 'active', '/placeholder.svg?height=300&width=300')
ON CONFLICT DO NOTHING;
