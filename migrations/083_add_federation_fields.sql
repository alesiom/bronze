-- Add federation and series fields to events table
-- For tracking which governing body organizes each event

ALTER TABLE events ADD COLUMN IF NOT EXISTS federation VARCHAR(10);
ALTER TABLE events ADD COLUMN IF NOT EXISTS series VARCHAR(50);
ALTER TABLE events ADD COLUMN IF NOT EXISTS country VARCHAR(3);

-- Create index for federation filtering
CREATE INDEX IF NOT EXISTS idx_events_federation ON events(federation);

-- Update existing events with IOC federation (Olympics)
UPDATE events SET federation = 'IOC', series = 'Winter Olympics' WHERE federation IS NULL;

COMMENT ON COLUMN events.federation IS 'Governing body: FIS, IBU, IBSF, FIL, ISU, WCF, IOC';
COMMENT ON COLUMN events.series IS 'Competition series: World Cup, Tour de Ski, Four Hills, etc.';
COMMENT ON COLUMN events.country IS 'ISO 3-letter country code of venue';
