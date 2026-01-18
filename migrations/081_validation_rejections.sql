-- Migration 081: Validation Rejections Table
-- Part of architecture refactor (Phase 6: Agent-Driven Monitoring)
-- Tracks all validation rejections for automated content generation

-- Create validation_rejections table
CREATE TABLE IF NOT EXISTS validation_rejections (
    id SERIAL PRIMARY KEY,

    -- Article identification
    article_slug VARCHAR(255),

    -- Rejection details
    rejection_type VARCHAR(50) NOT NULL,  -- 'legal', 'structure', 'incomplete', 'html'
    severity VARCHAR(20) DEFAULT 'error',  -- 'error', 'warning', 'critical'

    -- Error details
    errors JSONB NOT NULL DEFAULT '[]',    -- Array of error messages
    warnings JSONB DEFAULT '[]',           -- Array of warning messages

    -- Raw content for debugging (optional, can be null for privacy)
    raw_content JSONB,                     -- Original article data that failed

    -- Source of the content
    source VARCHAR(100) DEFAULT 'n8n',     -- 'n8n', 'api', 'manual', 'regeneration'

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),

    -- Index for efficient queries
    CONSTRAINT valid_rejection_type CHECK (
        rejection_type IN ('legal', 'structure', 'incomplete', 'html', 'other')
    ),
    CONSTRAINT valid_severity CHECK (
        severity IN ('warning', 'error', 'critical')
    )
);

-- Indexes for common queries
CREATE INDEX IF NOT EXISTS idx_validation_rejections_type
    ON validation_rejections(rejection_type);

CREATE INDEX IF NOT EXISTS idx_validation_rejections_created
    ON validation_rejections(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_validation_rejections_severity
    ON validation_rejections(severity);

CREATE INDEX IF NOT EXISTS idx_validation_rejections_slug
    ON validation_rejections(article_slug);

-- Comments for documentation
COMMENT ON TABLE validation_rejections IS
    'Logs all validation failures from automated content generation.
     Part of Phase 6 agent-driven architecture - no human in the loop.';

COMMENT ON COLUMN validation_rejections.rejection_type IS
    'Type of validation failure: legal (€2.5M fine risk), structure (WCAG), incomplete (missing translations), html (malformed)';

COMMENT ON COLUMN validation_rejections.raw_content IS
    'Original article content for debugging. May be null for large content or privacy reasons.';

-- View for daily rejection summary (useful for monitoring)
CREATE OR REPLACE VIEW validation_rejection_summary AS
SELECT
    DATE(created_at) as date,
    rejection_type,
    severity,
    COUNT(*) as count
FROM validation_rejections
WHERE created_at > NOW() - INTERVAL '30 days'
GROUP BY DATE(created_at), rejection_type, severity
ORDER BY date DESC, count DESC;

-- Function to log a validation rejection
CREATE OR REPLACE FUNCTION log_validation_rejection(
    p_slug VARCHAR(255),
    p_type VARCHAR(50),
    p_severity VARCHAR(20),
    p_errors JSONB,
    p_warnings JSONB DEFAULT '[]',
    p_raw_content JSONB DEFAULT NULL,
    p_source VARCHAR(100) DEFAULT 'api'
) RETURNS INTEGER AS $$
DECLARE
    v_id INTEGER;
BEGIN
    INSERT INTO validation_rejections (
        article_slug, rejection_type, severity, errors, warnings, raw_content, source
    ) VALUES (
        p_slug, p_type, p_severity, p_errors, p_warnings, p_raw_content, p_source
    ) RETURNING id INTO v_id;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION log_validation_rejection IS
    'Convenience function to log validation rejections from API or n8n workflows';
