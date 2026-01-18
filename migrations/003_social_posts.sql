-- Social posts history for content variety tracking
-- Stores what was posted to avoid repetition

CREATE TABLE IF NOT EXISTS social_posts (
    id SERIAL PRIMARY KEY,
    content_type VARCHAR(50) NOT NULL,        -- 'quote', 'race_preview', 'athlete_stat', etc.
    post_text TEXT NOT NULL,
    platform VARCHAR(20) NOT NULL,            -- 'twitter', 'instagram', etc.
    posted_at TIMESTAMPTZ DEFAULT NOW(),

    -- Context for smarter content selection
    athletes_mentioned TEXT[],                -- ['mikaela-shiffrin', 'marco-odermatt']
    sports_mentioned TEXT[],                  -- ['alpine-skiing', 'biathlon']
    topics TEXT[],                            -- ['world-cup', 'injury', 'record']

    -- Late.dev response tracking
    late_post_id VARCHAR(100),                -- ID from Late.dev API response

    -- Indexing for fast lookups
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for fetching recent posts quickly
CREATE INDEX IF NOT EXISTS idx_social_posts_posted_at ON social_posts(posted_at DESC);
CREATE INDEX IF NOT EXISTS idx_social_posts_content_type ON social_posts(content_type);
CREATE INDEX IF NOT EXISTS idx_social_posts_platform ON social_posts(platform);
