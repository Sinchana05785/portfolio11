-- Supabase Database Setup for Portfolio CMS
-- Run this in the SQL Editor of your Supabase Dashboard

-- 1. Create the portfolio_data table
CREATE TABLE IF NOT EXISTS public.portfolio_data (
    id BIGINT PRIMARY KEY DEFAULT 1,
    data JSONB NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Ensure only id = 1 can exist if we want to restrict to a single portfolio configuration
ALTER TABLE public.portfolio_data ADD CONSTRAINT only_one_row CHECK (id = 1);

-- 2. Enable Row Level Security (RLS)
ALTER TABLE public.portfolio_data ENABLE ROW LEVEL SECURITY;

-- 3. Create RLS Policies
-- Allow anyone (public/anon) to read the portfolio data
CREATE POLICY "Allow public read access"
ON public.portfolio_data FOR SELECT
USING (true);

-- Allow authenticated users to perform all operations (insert, update, delete)
CREATE POLICY "Allow authenticated write access"
ON public.portfolio_data FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);

-- 4. Enable Realtime Replication
-- This allows index.html to update live when updates are published in the admin panel
ALTER PUBLICATION supabase_realtime ADD TABLE public.portfolio_data;

-- 5. Seed with initial default data if the table is empty
INSERT INTO public.portfolio_data (id, data)
VALUES (1, '{
    "hero": {
        "firstName": "Alex",
        "lastName": "Morgan",
        "role": "Full Stack Developer",
        "available": true,
        "desc": "Crafting digital experiences\nwith clean code & sharp design.\nBased in New York, working worldwide.",
        "photo": "https://via.placeholder.com/380",
        "resume": "#",
        "email": "alex@example.com",
        "github": "#",
        "linkedin": "#",
        "twitter": "#"
    },
    "about": {
        "bio": "I''m a full-stack developer with 6+ years of experience turning ideas into fast, accessible, and beautifully crafted products. I thrive at the intersection of engineering and design — obsessing over every pixel and every millisecond of load time.\n\nWhen I''m not shipping code, I''m contributing to open source, writing about web performance, and exploring the outdoors.",
        "hackathons": "10+",
        "projects": "40+",
        "stars": "3k+"
    },
    "skills": [
        { "icon": "⬡", "title": "Frontend", "items": "React / Next.js\nTypeScript\nTailwind CSS\nFramer Motion\nWebGL / Three.js" },
        { "icon": "◈", "title": "Backend", "items": "Node.js / Express\nPython / FastAPI\nPostgreSQL\nRedis\nGraphQL" },
        { "icon": "◎", "title": "DevOps & Cloud", "items": "AWS / GCP\nDocker / Kubernetes\nCI/CD Pipelines\nTerraform\nVercel / Netlify" }
    ],
    "education": [
        { "degree": "B.S. Computer Science", "institution": "University of Technology", "date": "2015 - 2019", "desc": "Graduated with Honors. Specialized in Software Engineering and Human-Computer Interaction." }
    ],
    "certifications": [
        { "title": "AWS Certified Developer", "issuer": "Amazon Web Services", "date": "2023", "link": "#" }
    ],
    "achievements": [
        { "title": "1st Place - Global Web3 Hackathon", "date": "Oct 2024", "desc": "Built a decentralized identity solution using zero-knowledge proofs. Selected as winner from 500+ competing teams." }
    ],
    "projects": [
        { "name": "Luminary — SaaS Dashboard", "desc": "A real-time analytics platform for e-commerce brands with live KPI tracking and AI-driven insights.", "tags": "Next.js, Postgres, D3.js", "year": "2024", "url": "#" },
        { "name": "Orbit — Design System", "desc": "An open-source component library with 80+ accessible components, used by 200+ developers.", "tags": "React, TypeScript, Storybook", "year": "2024", "url": "#" }
    ],
    "settings": {
        "siteTitle": "Alex Morgan — Full Stack Developer",
        "metaDescription": "Full Stack Developer crafting digital experiences with clean code and sharp design."
    }
}')
ON CONFLICT (id) DO NOTHING;

-- =========================================================================
-- OPTIONAL: LOCAL MODE WRITE ACCESS POLICY
-- =========================================================================
-- If you log in to the admin panel using "Local Mode" (username: admin, password: admin123)
-- rather than "Supabase Auth Mode" (which uses an email address containing @),
-- your requests will be sent as an anonymous public user ("anon" role).
--
-- Under the default security policies, anonymous writes are blocked.
-- To allow your admin panel to write to the Supabase database in Local Mode,
-- you can enable the following policy by copying and running it in your SQL Editor:
--
-- CREATE POLICY "Allow anonymous write access"
-- ON public.portfolio_data FOR ALL
-- TO anon
-- USING (true)
-- WITH CHECK (true);
-- =========================================================================
