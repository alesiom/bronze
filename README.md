# Neve26 ❄️

**Winter Games Italy 2026 Schedule Tracker**

A mobile app that helps tourists attending the Milano Cortina 2026 Winter Games track event schedules, receive change notifications, and plan their visit.

> *"Neve"* means *"snow"* in Italian 🇮🇹

## Features

- 📅 **Full Schedule** — Browse all 116 medal events across 16 sports
- ⭐ **Favorites** — Save events you want to attend
- 🔔 **Push Notifications** — Get alerts when your events change (time, venue, delays)
- 📍 **Venue Info** — Details on all 15 venues across Milan, Cortina, and beyond
- 📴 **Offline Mode** — Access your schedule without internet (Premium)

## Project Structure

```
neve26/
├── CLAUDE.md              # AI assistant context
├── README.md              # This file
├── pyproject.toml         # Python dependencies
├── config/
│   └── settings.py        # App configuration
├── src/
│   ├── scraper/           # Schedule scraping
│   │   ├── main.py        # Entry point
│   │   ├── scheduler.py   # Adaptive timing
│   │   ├── parser.py      # HTML/JSON parsing
│   │   ├── diff.py        # Change detection
│   │   └── proxy.py       # IP rotation
│   ├── api/               # REST API (FastAPI)
│   ├── notifications/     # Push notifications
│   └── db/                # Database access
├── scripts/               # Utility scripts
└── tests/                 # Test suite
```

## Quick Start

```bash
# Clone and setup
git clone https://github.com/yourusername/neve26.git
cd neve26

# Create virtual environment
python -m venv venv
source venv/bin/activate  # or `venv\Scripts\activate` on Windows

# Install dependencies
pip install -e ".[dev]"

# Copy environment config
cp .env.example .env

# Test the scraper
python -m src.scraper.main --test
```

## Development

### Run Scraper (Test Mode)

```bash
python -m src.scraper.main --test
```

### Run API Server

```bash
uvicorn src.api.main:app --reload
```

### Run Tests

```bash
pytest tests/
```

## Tech Stack

| Component | Technology |
|-----------|------------|
| Backend | Python 3.11 + FastAPI |
| Database | PostgreSQL (Supabase) |
| Scraping | httpx + BeautifulSoup |
| Push Notifications | Firebase Cloud Messaging |
| Mobile App | React Native (separate repo) |

## Scraping Strategy

The scraper uses **adaptive frequency** to balance freshness vs. server load:

| Time Period | Frequency |
|-------------|-----------|
| Night (00:00-06:00) | Every 30 min |
| Day (06:00-24:00) | Every 5 min |
| Pre-Event (2h before) | Every 90 sec |
| Live (during events) | Every 30 sec |

## Deployment

### Backend (Railway/Render)

```bash
# Using Railway
railway up

# Using Render
# Connect GitHub repo via dashboard
```

### Database (Supabase)

1. Create project at [supabase.com](https://supabase.com)
2. Run migrations from `scripts/migrate.py`
3. Copy connection string to `.env`

## Legal Notes

⚠️ This project is **not affiliated** with the International Olympic Committee or Milano Cortina 2026.

- We do not use "Olympic", "Olympics", or "Milano Cortina 2026" trademarks
- Schedule data is publicly available factual information
- No official logos, rings, or torch imagery are used

## Timeline

| Phase | Dates | Status |
|-------|-------|--------|
| MVP Backend | Dec 2025 - Jan 15 | 🚧 In Progress |
| Mobile App | Jan 1 - Jan 25 | ⏳ Planned |
| Beta Testing | Jan 20 - Jan 31 | ⏳ Planned |
| Launch | Feb 1, 2026 | ⏳ Planned |
| Live Ops | Feb 4 - Feb 22 | ⏳ Planned |

## License

MIT License — See [LICENSE](LICENSE) for details.

---

**Domains**: [neve26.app](https://neve26.app) · [neve26.com](https://neve26.com)
