-- Create news table
CREATE TABLE IF NOT EXISTS news (
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

-- Enable RLS
ALTER TABLE news ENABLE ROW LEVEL SECURITY;

-- Only authenticated admin users can view news
CREATE POLICY "Authenticated users can view news"
  ON news FOR SELECT
  USING (auth.uid() IN (SELECT id FROM admin_users));

-- Only authenticated admin users can insert news
CREATE POLICY "Authenticated users can insert news"
  ON news FOR INSERT
  WITH CHECK (auth.uid() IN (SELECT id FROM admin_users));

-- Only authenticated admin users can update news
CREATE POLICY "Authenticated users can update news"
  ON news FOR UPDATE
  USING (auth.uid() IN (SELECT id FROM admin_users));

-- Only authenticated admin users can delete news
CREATE POLICY "Authenticated users can delete news"
  ON news FOR DELETE
  USING (auth.uid() IN (SELECT id FROM admin_users));

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_news_status ON news(status);
CREATE INDEX IF NOT EXISTS idx_news_published_date ON news(published_date DESC);
