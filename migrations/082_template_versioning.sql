-- Migration 082: Template Versioning and Regeneration Queue
-- Part of architecture refactor (Phase 5: Scalability)
-- Enables incremental regeneration when templates or content change

-- =============================================================================
-- Template Version Tracking
-- =============================================================================

-- Track template versions for incremental regeneration
CREATE TABLE IF NOT EXISTS template_versions (
    id SERIAL PRIMARY KEY,
    template_name VARCHAR(100) NOT NULL UNIQUE,  -- 'article', 'index', 'base'
    version_hash VARCHAR(64) NOT NULL,           -- SHA-256 of template content
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Track which template version was used to generate each article's HTML
ALTER TABLE articles
ADD COLUMN IF NOT EXISTS template_version VARCHAR(64),
ADD COLUMN IF NOT EXISTS html_generated_at TIMESTAMPTZ;

-- Index for finding articles needing regeneration
CREATE INDEX IF NOT EXISTS idx_articles_template_version
    ON articles(template_version);

CREATE INDEX IF NOT EXISTS idx_articles_html_generated
    ON articles(html_generated_at);

-- =============================================================================
-- Regeneration Queue
-- =============================================================================

-- Queue for background HTML regeneration
CREATE TABLE IF NOT EXISTS regeneration_queue (
    id SERIAL PRIMARY KEY,
    article_slug VARCHAR(255) NOT NULL,
    priority VARCHAR(20) DEFAULT 'normal',    -- 'immediate', 'normal', 'low'
    reason VARCHAR(100),                       -- 'content_change', 'template_update', 'manual'
    status VARCHAR(20) DEFAULT 'pending',      -- 'pending', 'processing', 'completed', 'failed'
    attempts INTEGER DEFAULT 0,
    max_attempts INTEGER DEFAULT 3,
    error_message TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,

    CONSTRAINT valid_priority CHECK (
        priority IN ('immediate', 'normal', 'low')
    ),
    CONSTRAINT valid_status CHECK (
        status IN ('pending', 'processing', 'completed', 'failed')
    )
);

-- Indexes for queue processing
CREATE INDEX IF NOT EXISTS idx_regen_queue_status_priority
    ON regeneration_queue(status, priority, created_at);

CREATE INDEX IF NOT EXISTS idx_regen_queue_slug
    ON regeneration_queue(article_slug);

-- Prevent duplicate queue entries for same article
CREATE UNIQUE INDEX IF NOT EXISTS idx_regen_queue_pending_slug
    ON regeneration_queue(article_slug)
    WHERE status IN ('pending', 'processing');

-- =============================================================================
-- Helper Functions
-- =============================================================================

-- Add article to regeneration queue
CREATE OR REPLACE FUNCTION queue_regeneration(
    p_slug VARCHAR(255),
    p_priority VARCHAR(20) DEFAULT 'normal',
    p_reason VARCHAR(100) DEFAULT 'manual'
) RETURNS INTEGER AS $$
DECLARE
    v_id INTEGER;
BEGIN
    -- Try to insert, or update priority if higher
    INSERT INTO regeneration_queue (article_slug, priority, reason)
    VALUES (p_slug, p_priority, p_reason)
    ON CONFLICT (article_slug) WHERE status IN ('pending', 'processing')
    DO UPDATE SET
        priority = CASE
            WHEN EXCLUDED.priority = 'immediate' THEN 'immediate'
            WHEN regeneration_queue.priority = 'immediate' THEN 'immediate'
            WHEN EXCLUDED.priority = 'normal' AND regeneration_queue.priority = 'low' THEN 'normal'
            ELSE regeneration_queue.priority
        END,
        reason = EXCLUDED.reason
    RETURNING id INTO v_id;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- Get next item from queue for processing
CREATE OR REPLACE FUNCTION get_next_queue_item()
RETURNS TABLE (
    id INTEGER,
    article_slug VARCHAR(255),
    priority VARCHAR(20),
    reason VARCHAR(100)
) AS $$
BEGIN
    RETURN QUERY
    UPDATE regeneration_queue rq
    SET status = 'processing',
        started_at = NOW(),
        attempts = attempts + 1
    WHERE rq.id = (
        SELECT rq2.id
        FROM regeneration_queue rq2
        WHERE rq2.status = 'pending'
        ORDER BY
            CASE rq2.priority
                WHEN 'immediate' THEN 1
                WHEN 'normal' THEN 2
                WHEN 'low' THEN 3
            END,
            rq2.created_at
        LIMIT 1
        FOR UPDATE SKIP LOCKED
    )
    RETURNING rq.id, rq.article_slug, rq.priority, rq.reason;
END;
$$ LANGUAGE plpgsql;

-- Mark queue item as completed
CREATE OR REPLACE FUNCTION complete_queue_item(
    p_id INTEGER,
    p_success BOOLEAN DEFAULT TRUE,
    p_error TEXT DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
    IF p_success THEN
        UPDATE regeneration_queue
        SET status = 'completed',
            completed_at = NOW()
        WHERE id = p_id;
    ELSE
        UPDATE regeneration_queue
        SET status = CASE
                WHEN attempts >= max_attempts THEN 'failed'
                ELSE 'pending'
            END,
            error_message = p_error
        WHERE id = p_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Queue all articles for regeneration (template update)
CREATE OR REPLACE FUNCTION queue_all_articles(
    p_reason VARCHAR(100) DEFAULT 'template_update'
) RETURNS INTEGER AS $$
DECLARE
    v_count INTEGER;
BEGIN
    INSERT INTO regeneration_queue (article_slug, priority, reason)
    SELECT slug, 'low', p_reason
    FROM articles
    WHERE status = 'published'
    ON CONFLICT (article_slug) WHERE status IN ('pending', 'processing')
    DO NOTHING;

    GET DIAGNOSTICS v_count = ROW_COUNT;
    RETURN v_count;
END;
$$ LANGUAGE plpgsql;

-- =============================================================================
-- Views
-- =============================================================================

-- Queue status summary
CREATE OR REPLACE VIEW regeneration_queue_summary AS
SELECT
    status,
    priority,
    COUNT(*) as count,
    MIN(created_at) as oldest,
    MAX(created_at) as newest
FROM regeneration_queue
WHERE status IN ('pending', 'processing')
GROUP BY status, priority
ORDER BY status, priority;

-- Articles needing regeneration (template outdated)
CREATE OR REPLACE VIEW articles_needing_regeneration AS
SELECT
    a.slug,
    a.category,
    a.template_version as current_version,
    tv.version_hash as latest_version,
    a.html_generated_at,
    a.updated_at as content_updated_at
FROM articles a
LEFT JOIN template_versions tv ON tv.template_name = 'article'
WHERE a.status = 'published'
  AND (a.template_version IS NULL
       OR a.template_version != tv.version_hash
       OR a.html_generated_at < a.updated_at);

-- Comments
COMMENT ON TABLE template_versions IS
    'Tracks template file versions for incremental regeneration';

COMMENT ON TABLE regeneration_queue IS
    'Background queue for HTML regeneration. Processes by priority then FIFO.';

COMMENT ON FUNCTION queue_regeneration IS
    'Add article to regeneration queue. Higher priority wins on conflict.';

COMMENT ON FUNCTION get_next_queue_item IS
    'Get and lock next queue item for processing. Uses SKIP LOCKED for concurrency.';
