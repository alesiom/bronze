-- Migration: Create athlete_social and social_posts_used tables
-- Run with: docker exec -i bronze-db psql -U postgres -d neve26 -f - < migrations/084_athlete_social_tables.sql

-- Athlete social media handles lookup
CREATE TABLE IF NOT EXISTS athlete_social (
    id SERIAL PRIMARY KEY,
    athlete_name VARCHAR(255) NOT NULL,
    athlete_slug VARCHAR(255) UNIQUE,
    country_code CHAR(3),
    sport VARCHAR(50),
    instagram_handle VARCHAR(100),
    instagram_id VARCHAR(50),
    instagram_verified BOOLEAN DEFAULT FALSE,
    instagram_followers INTEGER,
    twitter_handle VARCHAR(100),
    twitter_id VARCHAR(50),
    discovery_method VARCHAR(50),
    verified_at TIMESTAMPTZ,
    last_checked_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_athlete_social_slug ON athlete_social(athlete_slug);
CREATE INDEX IF NOT EXISTS idx_athlete_social_instagram ON athlete_social(instagram_handle);
CREATE INDEX IF NOT EXISTS idx_athlete_social_sport ON athlete_social(sport);

-- Track which social posts have been used in articles
CREATE TABLE IF NOT EXISTS social_posts_used (
    id SERIAL PRIMARY KEY,
    athlete_id INTEGER REFERENCES athlete_social(id),
    platform VARCHAR(20) NOT NULL,
    post_id VARCHAR(100) NOT NULL,
    post_url TEXT NOT NULL,
    caption TEXT,
    posted_at TIMESTAMPTZ,
    used_in_article VARCHAR(255),
    used_at TIMESTAMPTZ DEFAULT NOW(),
    relevance_score FLOAT,
    extracted_quote TEXT,
    event_slug VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(platform, post_id)
);

CREATE INDEX IF NOT EXISTS idx_social_posts_post_id ON social_posts_used(platform, post_id);
CREATE INDEX IF NOT EXISTS idx_social_posts_athlete ON social_posts_used(athlete_id);

COMMENT ON TABLE athlete_social IS 'Athlete social media handles for content enrichment';
COMMENT ON TABLE social_posts_used IS 'Tracks social media posts embedded in articles';
