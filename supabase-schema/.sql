-- India Drought Pulse - Supabase Schema Setup
-- Run this script in the Supabase SQL Editor (https://supabase.com/dashboard/project/_/sql)

-- 1. Create Publications Table (supporting both casing variants for compatibility)
CREATE TABLE IF NOT EXISTS publications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT,
    category TEXT,
    file_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    "Title" TEXT,
    "file url" TEXT
);

-- Support uppercase alias table or duplicate mapping for smooth fallback
CREATE TABLE IF NOT EXISTS "Publications" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "Title" TEXT,
    description TEXT,
    category TEXT,
    "file url" TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    title TEXT,
    file_url TEXT
);

-- 2. Create Researcher Updates Table
CREATE TABLE IF NOT EXISTS researcher_updates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT,
    category TEXT,
    file_url TEXT,
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Create Researcher Portal Table
CREATE TABLE IF NOT EXISTS researcher_portal (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT,
    category TEXT,
    file_url TEXT,
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Create Photo Gallery Table
CREATE TABLE IF NOT EXISTS photo_gallery (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT,
    category TEXT,
    image_url TEXT,
    file_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 5. Create Farmer Advisories Table
CREATE TABLE IF NOT EXISTS farmer_advisories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT,
    category TEXT,
    file_url TEXT,
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 6. Create News Updates Table
CREATE TABLE IF NOT EXISTS news_updates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT,
    category TEXT,
    image_url TEXT,
    file_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 7. Create Datasets Table
CREATE TABLE IF NOT EXISTS datasets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT,
    category TEXT,
    file_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 8. Create Globe Layers Table
CREATE TABLE IF NOT EXISTS globe_layers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT,
    category TEXT,
    file_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 9. Create Analytics Table
CREATE TABLE IF NOT EXISTS analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT,
    category TEXT,
    file_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);


-- ====== Row-Level Security (RLS) & Policies ======

-- Enable RLS on all tables
ALTER TABLE publications ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Publications" ENABLE ROW LEVEL SECURITY;
ALTER TABLE researcher_updates ENABLE ROW LEVEL SECURITY;
ALTER TABLE researcher_portal ENABLE ROW LEVEL SECURITY;
ALTER TABLE photo_gallery ENABLE ROW LEVEL SECURITY;
ALTER TABLE farmer_advisories ENABLE ROW LEVEL SECURITY;
ALTER TABLE news_updates ENABLE ROW LEVEL SECURITY;
ALTER TABLE datasets ENABLE ROW LEVEL SECURITY;
ALTER TABLE globe_layers ENABLE ROW LEVEL SECURITY;
ALTER TABLE analytics ENABLE ROW LEVEL SECURITY;

-- DROP existing policies if they exist to prevent conflict errors
DROP POLICY IF EXISTS "Allow public select on publications" ON publications;
DROP POLICY IF EXISTS "Allow auth insert on publications" ON publications;
DROP POLICY IF EXISTS "Allow auth delete on publications" ON publications;

DROP POLICY IF EXISTS "Allow public select on Publications tbl" ON "Publications";
DROP POLICY IF EXISTS "Allow auth insert on Publications tbl" ON "Publications";
DROP POLICY IF EXISTS "Allow auth delete on Publications tbl" ON "Publications";

DROP POLICY IF EXISTS "Allow public select on researcher_updates" ON researcher_updates;
DROP POLICY IF EXISTS "Allow auth insert on researcher_updates" ON researcher_updates;
DROP POLICY IF EXISTS "Allow auth delete on researcher_updates" ON researcher_updates;

DROP POLICY IF EXISTS "Allow public select on researcher_portal" ON researcher_portal;
DROP POLICY IF EXISTS "Allow auth insert on researcher_portal" ON researcher_portal;
DROP POLICY IF EXISTS "Allow auth delete on researcher_portal" ON researcher_portal;

DROP POLICY IF EXISTS "Allow public select on photo_gallery" ON photo_gallery;
DROP POLICY IF EXISTS "Allow auth insert on photo_gallery" ON photo_gallery;
DROP POLICY IF EXISTS "Allow auth delete on photo_gallery" ON photo_gallery;

DROP POLICY IF EXISTS "Allow public select on farmer_advisories" ON farmer_advisories;
DROP POLICY IF EXISTS "Allow auth insert on farmer_advisories" ON farmer_advisories;
DROP POLICY IF EXISTS "Allow auth delete on farmer_advisories" ON farmer_advisories;

DROP POLICY IF EXISTS "Allow public select on news_updates" ON news_updates;
DROP POLICY IF EXISTS "Allow auth insert on news_updates" ON news_updates;
DROP POLICY IF EXISTS "Allow auth delete on news_updates" ON news_updates;

DROP POLICY IF EXISTS "Allow public select on datasets" ON datasets;
DROP POLICY IF EXISTS "Allow auth insert on datasets" ON datasets;
DROP POLICY IF EXISTS "Allow auth delete on datasets" ON datasets;

DROP POLICY IF EXISTS "Allow public select on globe_layers" ON globe_layers;
DROP POLICY IF EXISTS "Allow auth insert on globe_layers" ON globe_layers;
DROP POLICY IF EXISTS "Allow auth delete on globe_layers" ON globe_layers;

DROP POLICY IF EXISTS "Allow public select on analytics" ON analytics;
DROP POLICY IF EXISTS "Allow auth insert on analytics" ON analytics;
DROP POLICY IF EXISTS "Allow auth delete on analytics" ON analytics;


-- PUBLIC SELECT POLICIES (Allow anyone to read)
CREATE POLICY "Allow public select on publications" ON publications FOR SELECT USING (true);
CREATE POLICY "Allow public select on Publications tbl" ON "Publications" FOR SELECT USING (true);
CREATE POLICY "Allow public select on researcher_updates" ON researcher_updates FOR SELECT USING (true);
CREATE POLICY "Allow public select on researcher_portal" ON researcher_portal FOR SELECT USING (true);
CREATE POLICY "Allow public select on photo_gallery" ON photo_gallery FOR SELECT USING (true);
CREATE POLICY "Allow public select on farmer_advisories" ON farmer_advisories FOR SELECT USING (true);
CREATE POLICY "Allow public select on news_updates" ON news_updates FOR SELECT USING (true);
CREATE POLICY "Allow public select on datasets" ON datasets FOR SELECT USING (true);
CREATE POLICY "Allow public select on globe_layers" ON globe_layers FOR SELECT USING (true);
CREATE POLICY "Allow public select on analytics" ON analytics FOR SELECT USING (true);

-- AUTHENTICATED INSERT POLICIES (Allow registered admins to insert)
-- Using USING (true) OR WITH CHECK (true) to cover inserts
CREATE POLICY "Allow auth insert on publications" ON publications FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Allow auth insert on Publications tbl" ON "Publications" FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Allow auth insert on researcher_updates" ON researcher_updates FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Allow auth insert on researcher_portal" ON researcher_portal FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Allow auth insert on photo_gallery" ON photo_gallery FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Allow auth insert on farmer_advisories" ON farmer_advisories FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Allow auth insert on news_updates" ON news_updates FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Allow auth insert on datasets" ON datasets FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Allow auth insert on globe_layers" ON globe_layers FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Allow auth insert on analytics" ON analytics FOR INSERT TO authenticated WITH CHECK (true);

-- AUTHENTICATED DELETE POLICIES (Allow registered admins to delete)
CREATE POLICY "Allow auth delete on publications" ON publications FOR DELETE TO authenticated USING (true);
CREATE POLICY "Allow auth delete on Publications tbl" ON "Publications" FOR DELETE TO authenticated USING (true);
CREATE POLICY "Allow auth delete on researcher_updates" ON researcher_updates FOR DELETE TO authenticated USING (true);
CREATE POLICY "Allow auth delete on researcher_portal" ON researcher_portal FOR DELETE TO authenticated USING (true);
CREATE POLICY "Allow auth delete on photo_gallery" ON photo_gallery FOR DELETE TO authenticated USING (true);
CREATE POLICY "Allow auth delete on farmer_advisories" ON farmer_advisories FOR DELETE TO authenticated USING (true);
CREATE POLICY "Allow auth delete on news_updates" ON news_updates FOR DELETE TO authenticated USING (true);
CREATE POLICY "Allow auth delete on datasets" ON datasets FOR DELETE TO authenticated USING (true);
CREATE POLICY "Allow auth delete on globe_layers" ON globe_layers FOR DELETE TO authenticated USING (true);
CREATE POLICY "Allow auth delete on analytics" ON analytics FOR DELETE TO authenticated USING (true);

-- Also add an all-access policy override if the user logs i
