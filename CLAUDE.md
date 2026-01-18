# CLAUDE.md

Behavioral rules for Claude Code when working on Neve26.

## Quick Reference

| Document | Purpose |
|----------|---------|
| `docs/PROJECT.md` | Vision, product structure, business model, differentiators |
| `docs/ARCHITECTURE.md` | URL structure, content filtering, database schema |
| `docs/INTEGRATIONS.md` | API examples for Late.dev, Firebase, Matomo, etc. |

## Repository Structure

Neve26 is a **single repo** with multiple components:

```
neve26/
├── CLAUDE.md             ← This file (behavioral rules)
├── app/                  ← Mobile app (Expo/React Native)
│   ├── app/             # Screens (file-based routing)
│   ├── components/      # UI components
│   ├── hooks/           # Custom hooks
│   ├── services/        # API services
│   └── locales/         # i18n (11 languages)
├── website/              ← Static website (nginx)
│   ├── templates/       # Jinja2 templates
│   ├── i18n/            # Template translations
│   ├── scripts/         # Sitemap generator, utilities
│   └── static/          # Assets (CSS, images)
├── src/                  ← Backend (Python/FastAPI)
│   ├── api/             # FastAPI routes
│   ├── db/              # SQLAlchemy models
│   ├── scraper/         # FIS/IBU scrapers
│   └── notifications/   # Push notification service
├── migrations/           ← SQL migrations
├── docs/                 ← Documentation (see Quick Reference)
├── n8n-workflows/        ← Exported n8n workflow JSON
└── docker-compose.yml
```

## Development Environment

### Services (Docker)

```bash
# Start all services
docker-compose up -d

# Check status
docker-compose ps

# Follow API logs
docker-compose logs -f api
```

### Local URLs

| Service | URL |
|---------|-----|
| Website | http://localhost:80 |
| API | http://localhost:8000 |
| n8n | http://localhost:5678 |
| PostgreSQL | localhost:5432 |

### Production URLs

| Service | URL |
|---------|-----|
| Website | https://neve26.com |
| API | https://api.neve26.com |
| n8n | https://n8n.neve26.com |
| Matomo | https://matomo.neve26.com |

### VPS Access

```bash
ssh neve26   # Alias configured in ~/.ssh/config
cd /home/ubuntu/neve26/
```

## Legal Compliance

**CRITICAL: Italian Law 31/2020 prohibits using Olympic-related terms.**
**Fines: €100,000 to €2,500,000**

### Blocked Terms (NEVER use)

| Term | Category |
|------|----------|
| olympic, olympics, olympiad | Olympic |
| olimpico, olimpiade | Olympic (IT) |
| paralympic, paralimpico | Paralympic |
| milano cortina 2026, cortina 2026, milano 2026 | Trademark |
| winter games 2026, games of 2026, the games | Trademark |
| going for gold, medal hopes | Marketing |
| team usa, team italy, team canada, etc. | Team names |

### Safe Alternatives

- "FIS World Cup" instead of "Olympics"
- "IBU World Cup" instead of "the games"
- "Norway's national team" instead of "Team Norway"
- "France's athletes" instead of "French Team"
- Athlete names, career stats, venue names (without 2026)

### Validation

All content MUST pass `legal_blocklist` validation before publishing.
Check exists in n8n workflow and API create/update endpoints.

## Code Standards

### Python (Backend)

- **Style**: Black + isort
- **Typing**: Use type hints for all functions
- **Docstrings**: Brief, purpose-focused
- **Max lines**: 400 per file (soft), 500 (hard)

### TypeScript (Mobile App)

- **Style**: Prettier + ESLint (Expo defaults)
- **Components**: Functional with hooks
- **Accessibility**: All interactive elements need accessible labels

### HTML Templates (Website)

- **System**: Jinja2 templates (`USE_JINJA_TEMPLATES=true`)
- **Path**: `website/templates/`
- **i18n**: `website/i18n/`
- **CSS**: External file at `/static/styles.css` (not inline)

## Content Standards

### WCAG AAA Compliance

All content must meet WCAG AAA accessibility standards:
- Contrast ratio: 7:1 minimum
- All images: descriptive alt text
- All interactive elements: keyboard accessible
- Screen reader friendly structure

### Multilingual Content

11 languages supported: EN, DE, FR, IT, ES, PT, NL, AR, JA, ZH, KO

- Content stored as JSONB: `{"en": "...", "de": "...", ...}`
- URLs: `/article/` (EN), `/{lang}/article/` (others)
- RTL support required for Arabic (`ar`)

## GitLab Workflow

### Branching

- **Branch naming**: `feat-<description>` or `fix-<description>`
- `main` is protected - always production-ready
- **ALL work on branches** - no exceptions

```bash
# Start new feature/fix
git checkout -b feat-article-images

# Work, commit incrementally
git add . && git commit -m "Add image support to articles"
```

### Commits

- **Never** mention "Claude" or "AI" in commit messages
- Reference issue: `Closes #N` or `Fixes #N`
- Keep messages concise and descriptive

### Before Committing Code

1. Tests pass (`pytest tests/`)
2. Lint passes (`ruff check src/`)
3. **Alex confirms it works** (manual testing)

### Merge to Main

```bash
# On feature branch, after testing
git checkout main
git merge feat-article-images

# Test main locally
docker-compose up -d
# Verify functionality

# Push when confirmed working
git push origin main
```

### Deployment

```bash
# SSH to VPS
ssh neve26

# Pull and restart
cd /home/ubuntu/neve26
git pull
docker-compose up -d --build
```

## Project Management

### GitLab CLI

```bash
# List issues
glab issue list -R neve-26/neve26-backend

# View issue
glab issue view 42

# Create issue
glab issue create -t "Add image generation workflow" -d "..."
```

### Milestone Rules

- **NEVER work on tickets in `backlog`** - these are unprioritized
- Only work on tickets in active milestones (P1, P2, P3)
- Complete all issues in current phase before moving to next
- New ideas: create ticket in backlog, don't auto-assign

### Issue Template

```markdown
## Context
[Why this is needed]

## Proposal
[The solution or approach]

## Todos
- [ ] Todo 1
- [ ] Todo 2
```

### Labels

| Label | Usage |
|-------|-------|
| `bug` | Something is broken |
| `content` | Content-related (articles, translations) |
| `infra` | Infrastructure, deployment |
| `mobile` | Mobile app specific |
| `website` | Website specific |

## Session Workflow

### Session Start

1. Check for uncommitted work:
```bash
cd /Users/alex/kDrive/Privé/Neve26 && git status -s
```

2. If uncommitted changes exist: ask Alex before proceeding

3. Check current milestone progress:
```bash
glab issue list -R neve-26/neve26-backend --state opened
```

4. Read relevant docs for context:
   - `docs/KNOWLEDGE.md` for recent decisions
   - `docs/PROGRESS.md` for ticket status

### Session End

- If work is complete: commit with proper message
- If work is incomplete: commit as WIP: `git commit -m "WIP: partial progress on #N"`
- Push to remote as backup
- Update `docs/KNOWLEDGE.md` with any new discoveries

**Never leave uncommitted changes across sessions.**

### During Work

- Complete task: close issue
- Discover new task: create issue in backlog
- Find blocker: document in `docs/KNOWLEDGE.md`
- Make architectural decision: document in `docs/ARCHITECTURE.md`

## Key Technical Details

### n8n Workflows

| Workflow | ID | Purpose |
|----------|-----|---------|
| FIS Article Generator | `kBp7MyP9YugCOMC3` | Generate articles from FIS results |
| Social Media Posting | `2ITk8EuErxxlBHsE` | Post to X and Instagram via Late.dev |

### API Endpoints

```
GET  /api/v1/articles              # List articles
GET  /api/v1/articles/{slug}       # Single article
POST /api/v1/articles              # Create article
POST /api/v1/articles/{slug}/generate-html  # Generate HTML

GET  /api/v1/events                # List events
GET  /api/v1/events/upcoming       # Next events
GET  /api/v1/events/live           # Currently happening
```

### Docker Volumes

| Volume | Mount Point | Purpose |
|--------|-------------|---------|
| `html_content` | `/var/www/neve26.com` | Generated HTML articles |
| `html_content_images` | `/var/www/neve26.com/images` | Article and social images |

### Late.dev Social Media

- **Profile ID**: `6961bcd2da641c56044760a5`
- **X Account**: `6961bcdc4207e06f4ca84a79` (@neve2026)
- **Instagram Account**: `6961bd064207e06f4ca84a7a` (@neve.2026)
- Instagram requires `mediaItems` - text-only posts only work on X
