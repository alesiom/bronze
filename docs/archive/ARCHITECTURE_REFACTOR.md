# Website Architecture Refactor

**Goal:** Extract templates, CSS, and translations from Python code to files. Add automated validation as the gatekeeper (replacing human review).

**Constraint:** PostgreSQL + n8n API must stay (data reused for mobile app + social media).

---

## Summary

| Issue | Current | After Refactor |
|-------|---------|----------------|
| Templates | 1,180 LOC Python strings | Jinja2 `.html.j2` files |
| CSS | 480 LOC duplicated in 2 templates | Single `/style.css` file |
| Translations | 5 dicts, 320 LOC hardcoded | JSON files per language |
| Validation | None (human gatekeeper) | Automated checks before write |
| Legal check | n8n workflow only | n8n + API double-check |

---

## Target Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  /website/templates/           # STRUCTURE (git-versioned)  │
│  ├─ base.html.j2               # Shared: head, nav, footer  │
│  ├─ article.html.j2            # Single article page        │
│  ├─ index.html.j2              # Homepage & category pages  │
│  └─ partials/                                               │
│      ├─ header.html.j2         # Nav, language selector     │
│      ├─ footer.html.j2         # Footer links               │
│      ├─ card.html.j2           # Article card component     │
│      └─ headline.html.j2       # Headline card              │
├─────────────────────────────────────────────────────────────┤
│  /website/static/style.css     # STYLES (single file)       │
├─────────────────────────────────────────────────────────────┤
│  /website/i18n/                # TRANSLATIONS               │
│  ├─ en.json                    # {"nav_news": "News", ...}  │
│  ├─ de.json, fr.json, ...      # 11 languages total         │
├─────────────────────────────────────────────────────────────┤
│  /src/api/validation.py        # GATEKEEPER                 │
│  └─ validate_article()         # Legal + structure + WCAG   │
├─────────────────────────────────────────────────────────────┤
│  PostgreSQL (UNCHANGED)        # CONTENT                    │
│  n8n API (UNCHANGED)           # AUTOMATION                 │
│  Mobile App (UNCHANGED)        # Consumes JSON from API     │
└─────────────────────────────────────────────────────────────┘
```

---

## Ticket Overview

| Phase | Tickets | Dependencies | Priority |
|-------|---------|--------------|----------|
| **Phase 1: CSS** | R01-R03 | None | HIGH |
| **Phase 2: Validation** | R04-R06 | None | HIGH |
| **Phase 3: Templates** | R07-R12 | R01, R04 | HIGH |
| **Phase 4: Translations** | R13-R15 | R07 | MEDIUM |
| **Phase 5: Scalability** | R16-R18 | R07 | LOW (future) |
| **Phase 6: Monitoring** | R19-R21 | R04 | LOW (future) |

---

## Phase 1: Extract CSS

### R01: Create Consolidated CSS File
**Priority:** HIGH | **Blocks:** R03
**Time:** 1-2 hours

**Create file:** `/website/static/style.css`

**Instructions:**
1. Read current CSS from `src/api/routes/articles.py`:
   - `HTML_TEMPLATE` contains ~255 lines of CSS (around line 100-355)
   - `INDEX_TEMPLATE` contains ~225 lines of CSS (around line 600-825)
2. Merge both CSS blocks, removing duplicates
3. Ensure WCAG AAA compliance preserved (contrast ratios, focus states)
4. Add header comment: `/* Bronze Unified Styles - Generated from refactor */`

**CSS must include:**
- Skip link styles (`.skip-link`)
- RTL support (`[dir="rtl"]` rules)
- Dark theme (current theme)
- Article layout (`.article-content`, `.article-meta`)
- Index layout (`.article-grid`, `.filters`, `.headline-card`)
- Responsive breakpoints
- Focus states for accessibility

**Verify:** File exists, valid CSS syntax

---

### R02: Deploy CSS to Production
**Priority:** HIGH | **Depends:** R01 | **Blocks:** R03
**Time:** 15 min

**Instructions:**
1. Copy CSS to VPS:
   ```bash
   scp website/static/style.css ubuntu@bronze:/home/ubuntu/bronze/website/static/
   ```

2. Update `docker-compose.yml` to mount static directory (if not already):
   ```yaml
   website:
     volumes:
       - ./website/static:/usr/share/nginx/html/static:ro
   ```

3. Restart website container:
   ```bash
   ssh bronze "cd /home/ubuntu/bronze && docker compose restart website"
   ```

**Verify:** `curl -I https://bronze.news/static/style.css` returns 200

---

### R03: Update Templates to Use External CSS
**Priority:** HIGH | **Depends:** R01, R02
**Time:** 30 min

**Edit file:** `src/api/routes/articles.py`

**Instructions:**
1. In `HTML_TEMPLATE`, replace the entire `<style>...</style>` block with:
   ```html
   <link rel="stylesheet" href="/static/style.css">
   ```

2. In `INDEX_TEMPLATE`, replace the entire `<style>...</style>` block with:
   ```html
   <link rel="stylesheet" href="/static/style.css">
   ```

3. Deploy updated articles.py:
   ```bash
   scp src/api/routes/articles.py ubuntu@bronze:/home/ubuntu/bronze/src/api/routes/
   ssh bronze "cd /home/ubuntu/bronze && docker compose restart api"
   ```

4. Regenerate all HTML files:
   ```bash
   curl -X POST https://api.bronze.news/api/v1/articles/regenerate-all
   ```

**Verify:**
- `curl bronze.news/ | grep 'href="/static/style.css"'` → Found
- `curl bronze.news/ | grep '<style>' | wc -l` → 0
- Visual check: pages look the same as before

---

## Phase 2: Add Validation Layer

### R04: Create Validation Module
**Priority:** HIGH | **Blocks:** R05, R06
**Time:** 1-2 hours

**Create file:** `/src/api/validation.py`

```python
"""
Article and HTML validation for Bronze.
This module is the automated gatekeeper - no human review needed.
"""
from typing import List, Optional
from dataclasses import dataclass
import re

# Legal blocklist - Italian Law 31/2020
# Fines: €100,000 to €2,500,000
LEGAL_BLOCKLIST = [
    'olympic', 'olympics', 'olympiad', 'olimpico', 'olimpiade',
    'paralympic', 'paralimpico',
    'milano cortina 2026', 'cortina 2026', 'milano 2026',
    'winter games 2026', 'games of 2026', 'the games',
    'going for gold', 'medal hopes',
    'team usa', 'team italy', 'team canada', 'team france',
    'team germany', 'team switzerland', 'team norway', 'team austria'
]

SUPPORTED_LANGUAGES = ['en', 'de', 'fr', 'it', 'es', 'pt', 'nl', 'ar', 'ja', 'zh', 'ko']


@dataclass
class ValidationResult:
    passed: bool
    errors: List[str]
    warnings: List[str]


class ValidationError(Exception):
    """Raised when validation fails."""
    def __init__(self, errors: List[str]):
        self.errors = errors
        super().__init__(f"Validation failed: {', '.join(errors)}")


def check_legal_blocklist(text: str) -> List[str]:
    """Check text against legal blocklist. Returns list of violations."""
    violations = []
    text_lower = text.lower()
    for term in LEGAL_BLOCKLIST:
        if term in text_lower:
            violations.append(f"Banned term found: '{term}'")
    return violations


def validate_html_structure(html: str) -> List[str]:
    """Validate HTML structure for WCAG AAA compliance."""
    errors = []

    # DOCTYPE
    if not html.strip().startswith('<!DOCTYPE html>'):
        errors.append("Missing DOCTYPE declaration")

    # Language attribute
    if not re.search(r'<html[^>]*lang="[a-z]{2}"', html[:500]):
        errors.append("Missing lang attribute on <html>")

    # Skip link (WCAG)
    if 'class="skip-link"' not in html:
        errors.append("Missing skip-to-content link (WCAG requirement)")

    # Main element
    if '<main' not in html:
        errors.append("Missing <main> element")

    # Meta description
    if '<meta name="description"' not in html:
        errors.append("Missing meta description")

    # External CSS (no inline styles after Phase 1)
    if '<style>' in html and '</style>' in html:
        errors.append("Inline <style> found - should use external CSS")

    # RTL consistency
    if 'dir="rtl"' in html and 'lang="ar"' not in html:
        errors.append("RTL direction set but lang is not Arabic")

    return errors


def validate_article_content(article: dict) -> List[str]:
    """Validate article content completeness."""
    errors = []

    # Required fields
    if not article.get('slug'):
        errors.append("Missing slug")
    if not article.get('category'):
        errors.append("Missing category")

    # All 11 languages required
    title = article.get('title', {})
    content = article.get('content', {})

    for lang in SUPPORTED_LANGUAGES:
        if lang not in title or not title[lang]:
            errors.append(f"Missing title for language: {lang}")
        if lang not in content or not content[lang]:
            errors.append(f"Missing content for language: {lang}")

    return errors


def validate_article_for_publish(article: dict, html: str) -> ValidationResult:
    """
    Complete validation before any write.
    This is the GATEKEEPER - blocks bad content from being published.
    """
    errors = []
    warnings = []

    # 1. Legal blocklist (CRITICAL)
    all_text = ' '.join([
        str(article.get('title', {}).get('en', '')),
        str(article.get('excerpt', {}).get('en', '')),
        str(article.get('content', {}).get('en', '')),
    ])
    legal_violations = check_legal_blocklist(all_text)
    if legal_violations:
        errors.extend([f"LEGAL: {v}" for v in legal_violations])

    # 2. Content completeness
    content_errors = validate_article_content(article)
    errors.extend(content_errors)

    # 3. HTML structure
    html_errors = validate_html_structure(html)
    errors.extend(html_errors)

    # 4. Warnings (non-blocking)
    en_content = article.get('content', {}).get('en', '')
    if len(en_content) < 500:
        warnings.append("Article content is very short (<500 chars)")

    return ValidationResult(
        passed=len(errors) == 0,
        errors=errors,
        warnings=warnings
    )
```

**Verify:** `python -c "from src.api.validation import validate_article_for_publish; print('OK')"`

---

### R05: Integrate Validation into Article Generation
**Priority:** HIGH | **Depends:** R04
**Time:** 30 min

**Edit file:** `src/api/routes/articles.py`

**Instructions:**
1. Add import at top:
   ```python
   from src.api.validation import validate_article_for_publish, ValidationError
   ```

2. In the `generate_article_html()` function, add validation before writing:
   ```python
   def generate_article_html(article, lang: str) -> str:
       # ... existing template rendering ...
       html = HTML_TEMPLATE.format(...)

       # NEW: Validate before writing
       if lang == 'en':  # Only validate once per article
           result = validate_article_for_publish(article.__dict__, html)
           if not result.passed:
               raise ValidationError(result.errors)
           if result.warnings:
               logger.warning(f"Validation warnings for {article.slug}: {result.warnings}")

       return html
   ```

3. In the API endpoint that creates/publishes articles, catch ValidationError:
   ```python
   @router.post("/articles/{slug}/publish")
   async def publish_article(slug: str):
       try:
           # ... existing logic ...
           generate_all_html_for_article(article)
       except ValidationError as e:
           raise HTTPException(status_code=400, detail={
               "error": "Validation failed",
               "violations": e.errors
           })
   ```

**Verify:** Try creating an article with "olympic" in the title → Should be rejected

---

### R06: Create Validation Rejection Logging
**Priority:** MEDIUM | **Depends:** R04
**Time:** 30 min

**Create migration:** `migrations/010_validation_rejections.sql`

```sql
-- Track validation rejections for debugging and monitoring
CREATE TABLE IF NOT EXISTS validation_rejections (
    id SERIAL PRIMARY KEY,
    article_slug VARCHAR(255),
    rejection_type VARCHAR(50),  -- 'legal', 'structure', 'incomplete'
    errors JSONB NOT NULL,
    raw_content JSONB,           -- For debugging
    source VARCHAR(50),          -- 'api', 'n8n'
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_rejections_slug ON validation_rejections(article_slug);
CREATE INDEX idx_rejections_type ON validation_rejections(rejection_type);
CREATE INDEX idx_rejections_date ON validation_rejections(created_at);
```

**Run migration:**
```bash
ssh bronze "docker exec -i bronze-db psql -U postgres -d bronze" < migrations/010_validation_rejections.sql
```

**Verify:** Table exists in database

---

## Phase 3: Extract Templates to Jinja2

### R07: Set Up Jinja2 Environment
**Priority:** HIGH | **Depends:** R01, R04 | **Blocks:** R08-R12
**Time:** 30 min

**Edit file:** `src/api/routes/articles.py`

**Instructions:**
1. Add Jinja2 import:
   ```python
   from jinja2 import Environment, FileSystemLoader, select_autoescape
   ```

2. Create Jinja2 environment after imports:
   ```python
   # Template environment
   TEMPLATE_DIR = Path(__file__).parent.parent.parent.parent / 'website' / 'templates'

   jinja_env = Environment(
       loader=FileSystemLoader(TEMPLATE_DIR),
       autoescape=select_autoescape(['html', 'xml']),
       trim_blocks=True,
       lstrip_blocks=True
   )
   ```

3. Add Jinja2 to requirements.txt (if not present):
   ```
   Jinja2>=3.1.0
   ```

**Verify:** Import works without error

---

### R08: Create Base Template
**Priority:** HIGH | **Depends:** R07 | **Blocks:** R09, R10
**Time:** 1-2 hours

**Create file:** `/website/templates/base.html.j2`

**Instructions:**
1. Extract the common structure from `HTML_TEMPLATE`:
   - DOCTYPE, html tag with lang
   - Head section (meta, title, CSS link, hreflang)
   - Skip link
   - Header/nav
   - Main wrapper
   - Footer
   - Scripts

2. Add Jinja2 blocks:
   ```html
   <!DOCTYPE html>
   <html lang="{{ lang }}" {% if lang == 'ar' %}dir="rtl"{% endif %}>
   <head>
       <meta charset="UTF-8">
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <title>{% block title %}{{ title }} | Bronze{% endblock %}</title>
       <meta name="description" content="{{ meta_description }}">
       <link rel="stylesheet" href="/static/style.css">
       {% block head_extra %}{% endblock %}

       {# Hreflang tags #}
       {% for alt_lang in languages %}
       <link rel="alternate" hreflang="{{ alt_lang }}" href="{{ base_url }}{{ get_url(alt_lang) }}">
       {% endfor %}
   </head>
   <body>
       <a href="#main-content" class="skip-link">{{ i18n.skip_to_content }}</a>

       {% include 'partials/header.html.j2' %}

       <main id="main-content">
           {% block content %}{% endblock %}
       </main>

       {% include 'partials/footer.html.j2' %}

       {% block scripts %}{% endblock %}
   </body>
   </html>
   ```

**Verify:** Template syntax valid (no Jinja2 errors on load)

---

### R09: Create Article Template
**Priority:** HIGH | **Depends:** R08
**Time:** 1 hour

**Create file:** `/website/templates/article.html.j2`

```html
{% extends 'base.html.j2' %}

{% block title %}{{ article.title }} | Bronze{% endblock %}

{% block head_extra %}
{# Structured data for SEO #}
<script type="application/ld+json">
{{ structured_data | tojson }}
</script>
{% endblock %}

{% block content %}
<article class="article" itemscope itemtype="https://schema.org/NewsArticle">
    <header class="article-header">
        <nav class="breadcrumbs" aria-label="Breadcrumb">
            <ol>
                <li><a href="{{ home_url }}">{{ i18n.home }}</a></li>
                <li><a href="{{ category_url }}">{{ category_label }}</a></li>
                <li aria-current="page">{{ article.title }}</li>
            </ol>
        </nav>

        <h1 itemprop="headline">{{ article.title }}</h1>

        <p class="article-meta">
            <time datetime="{{ article.published_at }}" itemprop="datePublished">
                {{ article.published_at | format_date(lang) }}
            </time>
            <span class="reading-time">{{ reading_time }} {{ i18n.min_read }}</span>
        </p>
    </header>

    {% if article.featured_image %}
    <figure class="article-image">
        <img src="{{ article.featured_image }}"
             alt="{{ article.image_alt }}"
             loading="lazy"
             itemprop="image">
        {% if article.image_credit %}
        <figcaption>{{ article.image_credit }}</figcaption>
        {% endif %}
    </figure>
    {% endif %}

    <div class="article-content" itemprop="articleBody">
        {{ article.content | safe }}
    </div>
</article>
{% endblock %}

{% block scripts %}
{# Social embed scripts if needed #}
{% if has_instagram_embed %}
<script async src="//www.instagram.com/embed.js"></script>
{% endif %}
{% if has_twitter_embed %}
<script async src="https://platform.twitter.com/widgets.js"></script>
{% endif %}
{% endblock %}
```

**Verify:** Template renders without error with sample data

---

### R10: Create Index Template
**Priority:** HIGH | **Depends:** R08
**Time:** 1 hour

**Create file:** `/website/templates/index.html.j2`

```html
{% extends 'base.html.j2' %}

{% block title %}{{ page_title }} | Bronze{% endblock %}

{% block content %}
<section class="index-page">
    <header class="page-header">
        <h1>{{ page_title }}</h1>
        {% if page_description %}
        <p class="page-description">{{ page_description }}</p>
        {% endif %}
    </header>

    {% if show_filters %}
    <nav class="filters" aria-label="Content filters">
        {% for filter in filters %}
        <button class="filter-btn {% if filter.active %}active{% endif %}"
                data-filter="{{ filter.value }}"
                {% if filter.active %}aria-pressed="true"{% endif %}>
            {{ filter.label }}
        </button>
        {% endfor %}
    </nav>
    {% endif %}

    <div class="article-grid">
        {% if headline_article %}
        {% include 'partials/headline.html.j2' %}
        {% endif %}

        {% for article in articles %}
        {% include 'partials/card.html.j2' %}
        {% endfor %}
    </div>
</section>
{% endblock %}

{% block scripts %}
{% if show_filters %}
<script>
(function() {
    var filters = document.querySelector('.filters');
    if (!filters) return;

    filters.addEventListener('click', function(e) {
        if (e.target.classList.contains('filter-btn')) {
            var filter = e.target.dataset.filter;
            var cards = document.querySelectorAll('.article-card');

            document.querySelectorAll('.filter-btn').forEach(function(btn) {
                btn.classList.remove('active');
                btn.setAttribute('aria-pressed', 'false');
            });
            e.target.classList.add('active');
            e.target.setAttribute('aria-pressed', 'true');

            cards.forEach(function(card) {
                if (filter === 'all' || card.dataset.category === filter) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        }
    });
})();
</script>
{% endif %}
{% endblock %}
```

**Verify:** Template renders without error

---

### R11: Create Partial Templates
**Priority:** HIGH | **Depends:** R08
**Time:** 1 hour

**Create files:**

**`/website/templates/partials/header.html.j2`**
```html
<header class="site-header">
    <nav class="main-nav" aria-label="Main navigation">
        <a href="{{ home_url }}" class="logo">Bronze</a>
        <ul class="nav-links">
            <li><a href="{{ url_for('news') }}">{{ i18n.nav_news }}</a></li>
            <li><a href="{{ url_for('alpine') }}">{{ i18n.nav_alpine }}</a></li>
            <li><a href="{{ url_for('biathlon') }}">{{ i18n.nav_biathlon }}</a></li>
            <li><a href="{{ url_for('athletes') }}">{{ i18n.nav_athletes }}</a></li>
            <li><a href="/app" class="nav-cta">{{ i18n.nav_app }}</a></li>
        </ul>

        <div class="lang-selector">
            <select aria-label="{{ i18n.select_language }}" onchange="location.href=this.value">
                {% for l in languages %}
                <option value="{{ get_url(l) }}" {% if l == lang %}selected{% endif %}>
                    {{ l | upper }}
                </option>
                {% endfor %}
            </select>
        </div>
    </nav>
</header>
```

**`/website/templates/partials/footer.html.j2`**
```html
<footer class="site-footer">
    <nav aria-label="Footer navigation">
        <a href="/privacy">{{ i18n.footer_privacy }}</a>
        <a href="/support">{{ i18n.footer_support }}</a>
    </nav>
    <p class="copyright">&copy; 2026 Bronze</p>
</footer>
```

**`/website/templates/partials/card.html.j2`**
```html
<article class="article-card" data-category="{{ article.category }}">
    <a href="{{ article.url }}">
        {% if article.featured_image %}
        <img src="{{ article.featured_image }}" alt="" loading="lazy">
        {% endif %}
        <h2>{{ article.title }}</h2>
        <p class="excerpt">{{ article.excerpt }}</p>
        <span class="category-tag">{{ article.category_label }}</span>
    </a>
</article>
```

**`/website/templates/partials/headline.html.j2`**
```html
<article class="headline-card" data-category="{{ headline_article.category }}">
    <a href="{{ headline_article.url }}">
        {% if headline_article.featured_image %}
        <img src="{{ headline_article.featured_image }}" alt="" loading="lazy">
        {% endif %}
        <div class="headline-content">
            <span class="headline-label">{{ i18n.latest_news }}</span>
            <h2>{{ headline_article.title }}</h2>
            <p class="excerpt">{{ headline_article.excerpt }}</p>
        </div>
    </a>
</article>
```

**Verify:** All partials exist and have valid Jinja2 syntax

---

### R12: Migrate Generation Functions to Jinja2
**Priority:** HIGH | **Depends:** R07-R11
**Time:** 2-3 hours

**Edit file:** `src/api/routes/articles.py`

**Instructions:**
1. Replace `generate_article_html()` function:
   ```python
   def generate_article_html(article, lang: str) -> str:
       template = jinja_env.get_template('article.html.j2')

       # Build context
       context = {
           'article': article,
           'lang': lang,
           'i18n': load_i18n(lang),
           'languages': SUPPORTED_LANGUAGES,
           'home_url': get_home_url(lang),
           'category_url': get_category_url(article.category, lang),
           'category_label': get_category_label(article.category, lang),
           'reading_time': calculate_reading_time(article.content.get(lang, '')),
           'structured_data': build_structured_data(article, lang),
           'has_instagram_embed': 'instagram-media' in article.content.get(lang, ''),
           'has_twitter_embed': 'twitter-tweet' in article.content.get(lang, ''),
           # ... helper functions ...
       }

       html = template.render(**context)

       # Validate (gatekeeper)
       if lang == 'en':
           result = validate_article_for_publish(article.__dict__, html)
           if not result.passed:
               raise ValidationError(result.errors)

       return html
   ```

2. Replace `generate_index_html()` function similarly

3. Remove the old `HTML_TEMPLATE` and `INDEX_TEMPLATE` string variables (after verification)

**Verify:**
- Generate a test article → HTML looks correct
- `git diff src/api/routes/articles.py` shows template strings removed
- All existing articles still render correctly

---

## Phase 4: Extract Translations

### R13: Create Translation JSON Files
**Priority:** MEDIUM | **Depends:** R07 | **Blocks:** R14, R15
**Time:** 1-2 hours

**Create directory:** `/website/i18n/`

**Create files for each language:**

**`/website/i18n/en.json`**
```json
{
  "nav_news": "News",
  "nav_alpine": "Alpine",
  "nav_biathlon": "Biathlon",
  "nav_athletes": "Athletes",
  "nav_app": "Get App",
  "skip_to_content": "Skip to content",
  "select_language": "Select language",
  "home": "Home",
  "min_read": "min read",
  "latest_news": "Latest",
  "footer_privacy": "Privacy",
  "footer_support": "Support",
  "filter_all": "All",
  "filter_news": "News",
  "filter_athletes": "Athletes",
  "filter_venues": "Venues",
  "filter_history": "History",
  "filter_guides": "Guides"
}
```

**Create similar files for:** de.json, fr.json, it.json, es.json, pt.json, nl.json, ar.json, ja.json, zh.json, ko.json

**Source translations from:** Current `UI_STRINGS`, `NAV_TRANSLATIONS`, `CATEGORY_LABELS`, `FILTER_LABELS` dicts in articles.py

**Verify:** All 11 JSON files exist and are valid JSON

---

### R14: Create Translation Loader
**Priority:** MEDIUM | **Depends:** R13
**Time:** 30 min

**Edit file:** `src/api/routes/articles.py`

**Instructions:**
1. Add translation loading function:
   ```python
   import json
   from functools import lru_cache

   I18N_DIR = Path(__file__).parent.parent.parent.parent / 'website' / 'i18n'

   @lru_cache(maxsize=20)
   def load_i18n(lang: str) -> dict:
       """Load translation strings for a language."""
       file_path = I18N_DIR / f'{lang}.json'
       if not file_path.exists():
           file_path = I18N_DIR / 'en.json'  # Fallback to English

       with open(file_path, 'r', encoding='utf-8') as f:
           return json.load(f)
   ```

2. Update template rendering to use `load_i18n(lang)` in context

**Verify:** Translations load correctly for all 11 languages

---

### R15: Remove Hardcoded Translation Dicts
**Priority:** MEDIUM | **Depends:** R14
**Time:** 30 min

**Edit file:** `src/api/routes/articles.py`

**Instructions:**
1. Remove these dictionaries after confirming R14 works:
   - `UI_STRINGS` (~155 lines)
   - `NAV_TRANSLATIONS` (~13 lines)
   - `CATEGORY_LABELS` (~61 lines)
   - `FILTER_LABELS` (~32 lines)
   - `CATEGORY_CONFIG` (if translations moved to JSON)

2. Search for any remaining hardcoded strings and move to JSON

**Verify:**
- `grep -n "UI_STRINGS\|NAV_TRANSLATIONS" src/api/routes/articles.py` → No matches
- All pages still render with correct translations

---

## Phase 5: Scalability (Future)

### R16: Create Regeneration Queue Table
**Priority:** LOW | **Depends:** R07
**Time:** 30 min

**Create migration:** `migrations/011_regeneration_queue.sql`

```sql
CREATE TABLE IF NOT EXISTS regeneration_queue (
    id SERIAL PRIMARY KEY,
    article_slug VARCHAR(255) NOT NULL,
    priority VARCHAR(20) DEFAULT 'normal',  -- 'immediate', 'normal', 'low'
    status VARCHAR(20) DEFAULT 'pending',   -- 'pending', 'processing', 'completed', 'failed'
    error_message TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ
);

CREATE INDEX idx_regen_status ON regeneration_queue(status, priority);
```

---

### R17: Create Background Worker
**Priority:** LOW | **Depends:** R16
**Time:** 2-3 hours

Create a simple background worker that processes the regeneration queue.

---

### R18: Add CDN Integration
**Priority:** LOW
**Time:** 1-2 hours

Set up Cloudflare (free tier) for edge caching of static HTML files.

---

## Phase 6: Monitoring (Future)

### R19: Create Health Check Endpoint
**Priority:** LOW | **Depends:** R04
**Time:** 30 min

Add endpoint that checks:
- Database connectivity
- Template files exist
- Recent validation rejections

---

### R20: Create Daily Report n8n Workflow
**Priority:** LOW | **Depends:** R06
**Time:** 1-2 hours

n8n workflow that sends daily email with:
- Articles published
- Validation rejections
- Any errors

---

### R21: Add Alert Webhook
**Priority:** LOW | **Depends:** R06
**Time:** 30 min

n8n webhook endpoint that sends email on legal violation detection.

---

## Dependency Graph

```
R01 (CSS file)
 └─> R02 (Deploy CSS)
      └─> R03 (Update templates to use CSS)

R04 (Validation module)
 ├─> R05 (Integrate validation)
 └─> R06 (Rejection logging)

R01 + R04
 └─> R07 (Jinja2 setup)
      ├─> R08 (Base template)
      │    ├─> R09 (Article template)
      │    └─> R10 (Index template)
      ├─> R11 (Partials)
      └─> R12 (Migrate functions) ← R08, R09, R10, R11

R07
 └─> R13 (Translation JSONs)
      └─> R14 (Translation loader)
           └─> R15 (Remove old dicts)
```

---

## Verification Checklist

After completing all phases:

- [ ] `curl bronze.news/ | grep 'href="/static/style.css"'` → Found
- [ ] `curl bronze.news/ | grep '<style>' | wc -l` → 0
- [ ] Create article with "olympic" → Rejected with error
- [ ] `ls website/templates/` shows .html.j2 files
- [ ] `ls website/i18n/` shows 11 .json files
- [ ] Visual check: all pages look correct
- [ ] Mobile app still works (API unchanged)
- [ ] n8n workflows still work (API unchanged)

---

## Parallel Execution Guide

### Wave Structure

Based on dependencies, tickets can be distributed across multiple Claude instances:

| Wave | Parallel Instances | Tickets | Dependencies |
|------|-------------------|---------|--------------|
| **Wave 1** | 2 | R01, R04 | None (start immediately) |
| **Wave 2** | 4 | R02, R05, R06, R07 | Wave 1 complete |
| **Wave 3** | 2 | R08, R13 | R07 complete |
| **Wave 4** | 3 | R09, R10, R11 | R08 complete |
| **Wave 5** | 3 | R03, R12, R14/R15 | Various |

### Maximum Parallelism

- **Wave 1**: 2 instances working simultaneously
- **Wave 2**: Up to 4 instances (R07 can start once R01+R04 done)
- **Wave 3-5**: 2-3 instances each

### What Each Instance Needs to Read

**All tickets require:**
1. `docs/ARCHITECTURE_REFACTOR.md` (this file)
2. `CLAUDE.md` (project context, legal rules)

**Code tickets (R01, R04, R05, R07, R12, R14, R15) also require:**
3. `src/api/routes/articles.py` (current implementation)

**Template tickets (R08-R11) also require:**
3. `src/api/routes/articles.py` (to see current template structure)
4. `website/nginx.conf` (URL routing patterns)

**Translation tickets (R13-R15) also require:**
3. `src/api/routes/articles.py` (to extract current translation dicts)

---

## How to Use This Document

### Starting a new Claude instance for a ticket:

```
I'm working on the Bronze website architecture refactor.
Project: /Users/alex/kDrive/Privé/Bronze/

Please read these files first:
- docs/ARCHITECTURE_REFACTOR.md (this file)
- src/api/routes/articles.py (current implementation)
- CLAUDE.md (project context)

Work on ticket: R[XX]
```

### Critical files to understand:
- `src/api/routes/articles.py` - Current templates and generation logic
- `website/nginx.conf` - URL routing
- `docs/ARCHITECTURE.md` - URL structure and categories

---

## Progress Tracker

| Ticket | Description | Status | Notes |
|--------|-------------|--------|-------|
| R01 | Create consolidated CSS file | [x] | `/website/static/style.css` |
| R02 | Deploy CSS to production | [x] | Live on bronze.news |
| R03 | Update templates for external CSS | [x] | CSS link in templates |
| R04 | Create validation module | [x] | `src/api/validation.py` |
| R05 | Integrate validation | [x] | Called in articles.py |
| R06 | Rejection logging table | [x] | Migration 081 |
| R07 | Jinja2 environment setup | [x] | `USE_JINJA_TEMPLATES=true` |
| R08 | Base template | [x] | `website/templates/base.html.j2` |
| R09 | Article template | [x] | `website/templates/article.html.j2` |
| R10 | Index template | [x] | `website/templates/index.html.j2` |
| R11 | Partial templates | [x] | `website/templates/partials/` |
| R12 | Migrate generation functions | [x] | `render_article_jinja()`, `render_index_jinja()` |
| R13 | Translation JSON files | [x] | 11 files in `website/i18n/` |
| R14 | Translation loader | [x] | `load_i18n()` in articles.py |
| R15 | Remove hardcoded dicts | [ ] | UI_STRINGS still in articles.py (fallback) |
| R16 | Regeneration queue (future) | [ ] | Low priority |
| R17 | Background worker (future) | [ ] | Low priority |
| R18 | CDN integration (future) | [ ] | Low priority |
| R19 | Health check endpoint (future) | [ ] | Low priority |
| R20 | Daily report workflow (future) | [ ] | Low priority |
| R21 | Alert webhook (future) | [ ] | Low priority |

---

*Created: 2026-01-11*
*Last updated: 2026-01-12 (R04-R14 complete, tracker updated)*
