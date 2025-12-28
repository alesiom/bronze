# Neve26 - Winter Games Italy 2026 Schedule Tracker

## Project Overview

Neve26 is a mobile app that helps tourists attending the Milano Cortina 2026 Winter Games track event schedules, receive change notifications, and plan their visit.

**This is a one-time, time-boxed project** — the app is only relevant from late January to late February 2026.

## Business Model

- **Freemium mobile app** (iOS + Android via React Native or Flutter)
- Free: Browse schedule, save favorites
- Paid ($4.99 one-time): Push notifications for schedule changes, offline mode
- Revenue window: ~6 weeks (mid-January to end of February 2026)

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        NEVE26 SYSTEM                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐     ┌─────────────┐     ┌─────────────┐       │
│  │   Scraper   │────▶│  Diff Eng.  │────▶│  Push Svc   │       │
│  │   Service   │     │             │     │  (FCM/APNs) │       │
│  └──────┬──────┘     └─────────────┘     └─────────────┘       │
│         │                                                       │
│         ▼                                                       │
│  ┌─────────────┐     ┌─────────────┐     ┌─────────────┐       │
│  │   Proxy     │     │  PostgreSQL │     │   REST API  │       │
│  │   Rotator   │     │  (Supabase) │◀───▶│  (FastAPI)  │       │
│  └─────────────┘     └─────────────┘     └──────┬──────┘       │
│                                                  │              │
└──────────────────────────────────────────────────┼──────────────┘
                                                   │
                                                   ▼
                                          ┌─────────────┐
                                          │ Mobile App  │
                                          │ (RN/Flutter)│
                                          └─────────────┘
```

## Key Components

### 1. Scraper Service (`src/scraper/`)
- Adaptive frequency: night (30min) → day (5min) → pre-event (90s) → live (30s)
- Proxy rotation via IPRoyal or similar ($7/GB)
- Targets: olympics.com schedule pages
- Output: Parsed event data

### 2. Diff Engine (`src/scraper/diff.py`)
- Compares schedule snapshots
- Detects: time changes, venue changes, cancellations, delays
- Generates change events for notification service

### 3. API Service (`src/api/`)
- FastAPI backend
- Endpoints: /events, /events/{id}, /favorites, /user
- Auth: Simple JWT or Supabase Auth
- Hosted on: Railway, Render, or Fly.io

### 4. Notification Service (`src/notifications/`)
- Firebase Cloud Messaging (FCM) for Android
- APNs for iOS
- Triggered by diff engine when user's favorited events change

### 5. Database (`src/db/`)
- PostgreSQL via Supabase (free tier)
- Tables: events, users, favorites, schedule_changes, scrape_logs

## Tech Stack

| Component | Technology | Why |
|-----------|------------|-----|
| Backend | Python + FastAPI | Fast to build, async support |
| Database | Supabase (PostgreSQL) | Free tier, built-in auth |
| Scraping | httpx + BeautifulSoup | Async, lightweight |
| Proxy | IPRoyal residential | $7/GB, pay-as-you-go |
| Push | Firebase Cloud Messaging | Free, cross-platform |
| Hosting | Railway or Render | Simple deploy, cheap |
| Mobile | React Native or Flutter | Cross-platform |

## Data Sources

### Primary: Olympics.com
- URL: `https://olympics.com/en/milano-cortina-2026/schedule`
- Sport-specific: `https://olympics.com/en/milano-cortina-2026/schedule/{sport-code}`
- Sport codes: ALP, BTH, BOB, CCS, CUR, FSK, FRS, IHO, LUG, NCB, STK, SKN, SJP, SMT, SBD, SSK

### Data Structure (expected)
```json
{
  "event_id": "ALP-001-M-DH-0001",
  "sport": "Alpine Skiing",
  "sport_code": "ALP",
  "event_name": "Men's Downhill",
  "date": "2026-02-07",
  "time": "11:00",
  "venue": "Stelvio Ski Centre",
  "venue_city": "Bormio",
  "status": "scheduled",
  "session_code": "ALP01"
}
```

## Scraping Strategy

### Adaptive Frequency
```python
INTERVALS = {
    "night": 1800,      # 00:00-06:00 CET: every 30 min
    "day": 300,         # 06:00-24:00 CET: every 5 min
    "pre_event": 90,    # 2h before any event: every 90 sec
    "live": 30,         # During active sessions: every 30 sec
}
```

### Anti-Detection
- Rotate residential proxies (IPRoyal)
- Randomize User-Agent
- Add jitter (±10%) to intervals
- Respect rate limits, back off on 429

## Database Schema

```sql
-- Core tables
CREATE TABLE events (
    event_id VARCHAR(50) PRIMARY KEY,
    sport VARCHAR(50) NOT NULL,
    sport_code VARCHAR(10) NOT NULL,
    event_name VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    time TIME,
    venue VARCHAR(100),
    venue_city VARCHAR(50),
    status VARCHAR(50) DEFAULT 'scheduled',
    session_code VARCHAR(20),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_token VARCHAR(255),  -- FCM/APNs token
    platform VARCHAR(10),       -- ios/android
    is_premium BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE favorites (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    event_id VARCHAR(50) REFERENCES events(event_id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (user_id, event_id)
);

CREATE TABLE schedule_changes (
    id SERIAL PRIMARY KEY,
    event_id VARCHAR(50) REFERENCES events(event_id),
    change_type VARCHAR(50) NOT NULL,
    old_value TEXT,
    new_value TEXT,
    detected_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_events_date ON events(date);
CREATE INDEX idx_events_sport ON events(sport_code);
CREATE INDEX idx_favorites_user ON favorites(user_id);
```

## API Endpoints

```
GET  /api/v1/events                  # List all events (filterable)
GET  /api/v1/events/{event_id}       # Get single event
GET  /api/v1/events/live             # Currently happening events
GET  /api/v1/sports                  # List sports
GET  /api/v1/venues                  # List venues

POST /api/v1/users                   # Register device
GET  /api/v1/users/{id}/favorites    # Get user favorites
POST /api/v1/users/{id}/favorites    # Add favorite
DEL  /api/v1/users/{id}/favorites/{event_id}  # Remove favorite

POST /api/v1/webhooks/schedule-change  # Internal: trigger notifications
```

## Environment Variables

```bash
# Database
DATABASE_URL=postgresql://user:pass@host:5432/neve26

# Proxy
PROXY_PROVIDER=iproyal
PROXY_USERNAME=xxx
PROXY_PASSWORD=xxx

# Push Notifications
FIREBASE_CREDENTIALS_JSON=xxx
APNS_KEY_ID=xxx
APNS_TEAM_ID=xxx

# App
ENV=development
LOG_LEVEL=INFO
SCRAPE_ENABLED=true
```

## Project Timeline

| Phase | Dates | Deliverables |
|-------|-------|--------------|
| **MVP Backend** | Now - Jan 15 | Scraper, API, DB |
| **Mobile App** | Jan 1 - Jan 25 | React Native app |
| **Testing** | Jan 20 - Jan 31 | Load testing, bug fixes |
| **Launch** | Feb 1 | App Store / Play Store |
| **Live Ops** | Feb 4 - Feb 22 | Monitor, support |
| **Sunset** | Mar 1 | Archive, post-mortem |

## File Structure

```
neve26/
├── CLAUDE.md              # This file
├── README.md              # Public readme
├── pyproject.toml         # Python dependencies
├── .env.example           # Environment template
├── config/
│   └── settings.py        # App configuration
├── src/
│   ├── __init__.py
│   ├── scraper/
│   │   ├── __init__.py
│   │   ├── main.py        # Scraper entry point
│   │   ├── scheduler.py   # Adaptive scheduling
│   │   ├── parser.py      # HTML/JSON parsing
│   │   ├── diff.py        # Change detection
│   │   └── proxy.py       # Proxy rotation
│   ├── api/
│   │   ├── __init__.py
│   │   ├── main.py        # FastAPI app
│   │   ├── routes/
│   │   │   ├── events.py
│   │   │   ├── users.py
│   │   │   └── health.py
│   │   └── models.py      # Pydantic models
│   ├── notifications/
│   │   ├── __init__.py
│   │   └── push.py        # FCM/APNs integration
│   └── db/
│       ├── __init__.py
│       ├── connection.py
│       └── queries.py
├── scripts/
│   ├── seed_schedule.py   # Initial data load
│   └── migrate.py         # DB migrations
├── tests/
│   ├── test_scraper.py
│   ├── test_diff.py
│   └── test_api.py
└── docker-compose.yml     # Local development
```

## Commands

```bash
# Setup
python -m venv venv
source venv/bin/activate
pip install -e ".[dev]"

# Run scraper locally
python -m src.scraper.main

# Run API locally
uvicorn src.api.main:app --reload

# Run tests
pytest tests/

# Docker
docker-compose up -d
```

## Legal Notes

- **DO NOT** use "Olympic", "Olympics", "Milano Cortina 2026" anywhere
- App name: "Neve26" (neve = snow in Italian)
- Tagline: "Winter Games Italy Schedule Tracker"
- Data source: Publicly available schedule information
- No official logos, rings, or torch imagery

## Current Status

- [x] Architecture defined
- [x] Domain secured (neve26.app, neve26.com)
- [ ] Scraper prototype
- [ ] Database setup
- [ ] API implementation
- [ ] Mobile app
- [ ] App Store submission

## Next Steps for Claude Code

1. **First**: Test scraping olympics.com to understand actual HTML/JSON structure
2. **Then**: Implement parser based on real data format
3. **Then**: Build out full scraper with proxy rotation
4. **Then**: Set up Supabase and implement API
5. **Finally**: Notification service

Start with: `python src/scraper/main.py --test` to probe the live site.
