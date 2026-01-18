-- Migration: Create articles table for news content
-- Run with: psql -d neve26 -f migrations/001_articles.sql

-- Articles table with multilingual support
CREATE TABLE IF NOT EXISTS articles (
    id SERIAL PRIMARY KEY,
    slug VARCHAR(255) UNIQUE NOT NULL,

    -- Multilingual content stored as JSONB
    -- Format: {"en": "...", "de": "...", "fr": "...", etc.}
    title JSONB NOT NULL,
    excerpt JSONB,
    content JSONB NOT NULL,

    -- Categorization
    category VARCHAR(50) NOT NULL,  -- alpine-skiing, biathlon, cross-country, athletes, etc.
    sport_code VARCHAR(10),         -- ALP, BTH, CCS, etc.

    -- Related entities (for linking)
    athlete_slugs TEXT[],           -- ['mikaela-shiffrin', 'marco-odermatt']
    event_id VARCHAR(50),           -- Link to events table if applicable
    venue VARCHAR(100),
    venue_city VARCHAR(50),

    -- SEO and structured data
    meta_description JSONB,         -- Multilingual meta descriptions
    canonical_url VARCHAR(500),
    structured_data JSONB,          -- JSON-LD schema.org data

    -- Media
    featured_image VARCHAR(500),    -- URL to image
    image_alt JSONB,                -- Multilingual alt text
    image_credit VARCHAR(255),

    -- Publishing
    status VARCHAR(20) DEFAULT 'draft',  -- draft, published, archived
    published_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),

    -- Source tracking
    source_type VARCHAR(50),        -- 'auto-generated', 'manual', 'imported'
    source_data JSONB               -- Original data used for generation
);

-- Indexes for common queries
CREATE INDEX idx_articles_slug ON articles(slug);
CREATE INDEX idx_articles_category ON articles(category);
CREATE INDEX idx_articles_sport ON articles(sport_code);
CREATE INDEX idx_articles_status ON articles(status);
CREATE INDEX idx_articles_published ON articles(published_at DESC) WHERE status = 'published';
CREATE INDEX idx_articles_athlete_slugs ON articles USING GIN(athlete_slugs);

-- Function to auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER articles_updated_at
    BEFORE UPDATE ON articles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Athlete profiles table (for pre-built evergreen content)
CREATE TABLE IF NOT EXISTS athlete_profiles (
    id SERIAL PRIMARY KEY,
    slug VARCHAR(255) UNIQUE NOT NULL,

    -- Basic info
    name VARCHAR(255) NOT NULL,
    nationality VARCHAR(3),         -- ISO country code
    birth_date DATE,

    -- Social handles
    x_handle VARCHAR(100),
    instagram_handle VARCHAR(100),

    -- Multilingual bio
    bio JSONB,

    -- Stats (updated periodically)
    career_stats JSONB,             -- World Cup wins, podiums, etc.
    current_rankings JSONB,

    -- Sports
    sports TEXT[],                  -- ['alpine-skiing']
    disciplines TEXT[],             -- ['downhill', 'super-g', 'giant-slalom']

    -- Media
    portrait_image VARCHAR(500),    -- AI-generated stylized portrait
    portrait_prompt TEXT,           -- Midjourney prompt used

    -- Metadata
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_athlete_profiles_slug ON athlete_profiles(slug);
CREATE INDEX idx_athlete_profiles_nationality ON athlete_profiles(nationality);
CREATE INDEX idx_athlete_profiles_sports ON athlete_profiles USING GIN(sports);

CREATE TRIGGER athlete_profiles_updated_at
    BEFORE UPDATE ON athlete_profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Legal terms blocklist (safety filter)
CREATE TABLE IF NOT EXISTS legal_blocklist (
    id SERIAL PRIMARY KEY,
    term VARCHAR(255) NOT NULL,
    category VARCHAR(50),           -- 'olympic', 'trademark', 'team'
    severity VARCHAR(20) DEFAULT 'block',  -- 'block', 'warn'
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Seed blocklist with known terms
INSERT INTO legal_blocklist (term, category, severity) VALUES
    ('olympic', 'olympic', 'block'),
    ('olympics', 'olympic', 'block'),
    ('olympiad', 'olympic', 'block'),
    ('olimpico', 'olympic', 'block'),
    ('olimpiade', 'olympic', 'block'),
    ('paralympic', 'olympic', 'block'),
    ('paralimpico', 'olympic', 'block'),
    ('milano cortina 2026', 'trademark', 'block'),
    ('cortina 2026', 'trademark', 'block'),
    ('milano 2026', 'trademark', 'block'),
    ('winter games 2026', 'trademark', 'block'),
    ('games of 2026', 'trademark', 'block'),
    ('the games', 'trademark', 'warn'),
    ('going for gold', 'trademark', 'warn'),
    ('medal hopes', 'trademark', 'warn'),
    ('team usa', 'team', 'block'),
    ('team italy', 'team', 'block'),
    ('team canada', 'team', 'block'),
    ('team france', 'team', 'block'),
    ('team germany', 'team', 'block')
ON CONFLICT DO NOTHING;

-- Article generation log (for n8n tracking)
CREATE TABLE IF NOT EXISTS article_generation_log (
    id SERIAL PRIMARY KEY,
    article_id INTEGER REFERENCES articles(id),
    trigger_type VARCHAR(50),       -- 'race_result', 'preview', 'profile_update'
    source_url VARCHAR(500),
    generation_time_ms INTEGER,
    tokens_used INTEGER,
    model_used VARCHAR(50),
    success BOOLEAN DEFAULT true,
    error_message TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Comments for documentation
COMMENT ON TABLE articles IS 'News articles with multilingual content for neve26.com';
COMMENT ON COLUMN articles.title IS 'Multilingual titles: {"en": "...", "de": "...", ...}';
COMMENT ON COLUMN articles.content IS 'Multilingual HTML content for article body';
COMMENT ON TABLE athlete_profiles IS 'Pre-built athlete profiles for SEO and Olympic-adjacent traffic';
COMMENT ON TABLE legal_blocklist IS 'Terms to filter from generated content to avoid legal issues';
