# Bronze

**Ad-free, accessible, independent sports news.**

Bronze is an open-source sports news platform with a companion mobile app. Free website, paid app with schedule, notifications, and favorites. WCAG AAA accessible. No ads, no sponsors, no brand deals — ever.

> *"Not everything has to be gold."*

## Project Structure

```
bronze/
├── app/                  # Mobile app (Expo / React Native)
├── website/              # Static website (Jinja2 templates, nginx)
├── src/
│   ├── api/              # REST API (FastAPI)
│   ├── db/               # SQLAlchemy models + queries
│   └── notifications/    # Push notification service
├── config/               # App configuration
├── migrations/           # SQL migrations
├── scripts/              # Utility scripts
├── n8n-workflows/        # Automation workflows
├── docs/                 # Architecture, integrations, project vision
└── docker-compose.yml
```

## Quick Start

```bash
# Clone
git clone https://gitlab.com/bronzenews/bronze.git
cd bronze

# Start all services
docker-compose up -d

# Or run the API locally
pip install -e ".[dev]"
cp .env.example .env
uvicorn src.api.main:app --reload
```

## Tech Stack

| Component | Technology |
|-----------|------------|
| Backend | Python 3.11 + FastAPI |
| Database | PostgreSQL (Docker) |
| Website | Static HTML + nginx (Caddy reverse proxy) |
| Automation | n8n |
| Analytics | Self-hosted Matomo |
| Mobile | Expo (React Native) |
| Push | Firebase Cloud Messaging |

## URLs

| Service | URL |
|---------|-----|
| Website | https://bronze.news |
| API | https://api.bronze.news |

## Languages

EN-GB, FR, DE.

## Documentation

- [`CLAUDE.md`](CLAUDE.md) — Development rules and workflow
- [`docs/PROJECT.md`](docs/PROJECT.md) — Vision, product, business model
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — URL structure, categories, schema
- [`docs/INTEGRATIONS.md`](docs/INTEGRATIONS.md) — Third-party API references

## License

MIT License — See [LICENSE](LICENSE) for details.

---

**Website**: [bronze.news](https://bronze.news)
