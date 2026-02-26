"""Article endpoints for news content."""

import os
from datetime import datetime
from pathlib import Path
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from jinja2 import Environment, FileSystemLoader, select_autoescape
from pydantic import BaseModel
from sqlalchemy.ext.asyncio import AsyncSession
import structlog

from src.db import (
    get_session,
    get_articles,
    get_article_by_slug,
    get_featured_articles,
    create_article,
    update_article,
    publish_article,
)
from src.api.models import (
    ArticleListItem,
    ArticleDetail,
    ArticleListResponse,
    ArticleCreate,
    ArticleRaw,
    ArticleTranslationUpdate,
)
from src.api.validation import (
    validate_article_for_publish,
    validate_index_page,
    check_legal_blocklist,
    ValidationError,
    ValidationResult,
    get_validation_summary,
    log_validation_rejection,
    determine_rejection_type,
)

log = structlog.get_logger()
router = APIRouter(prefix="/articles", tags=["articles"])

# Supported languages
SUPPORTED_LANGS = {"en", "fr", "de"}

# =============================================================================
# Jinja2 Template Environment
# Templates are version-controlled files, not Python strings
# =============================================================================

TEMPLATES_PATH = Path(os.environ.get("TEMPLATES_PATH", "/app/website/templates"))

# Initialize Jinja2 environment
jinja_env = Environment(
    loader=FileSystemLoader(TEMPLATES_PATH),
    autoescape=select_autoescape(['html', 'xml', 'j2']),
    trim_blocks=True,
    lstrip_blocks=True,
)

# Flag to control template usage (allows gradual migration)
USE_JINJA_TEMPLATES = os.environ.get("USE_JINJA_TEMPLATES", "false").lower() == "true"

# i18n JSON files path
I18N_PATH = Path(os.environ.get("I18N_PATH", "/app/website/i18n"))

# Cache for loaded translations
_i18n_cache: dict = {}


def load_i18n(lang: str) -> dict:
    """
    Load translations from JSON file for a given language.

    Falls back to English if language file not found.
    Uses caching to avoid repeated file reads.
    """
    if lang in _i18n_cache:
        return _i18n_cache[lang]

    try:
        import json
        i18n_file = I18N_PATH / f"{lang}.json"
        if i18n_file.exists():
            with open(i18n_file, encoding="utf-8") as f:
                _i18n_cache[lang] = json.load(f)
                return _i18n_cache[lang]
    except Exception as e:
        log.warning(f"Failed to load i18n for {lang}: {e}")

    # Fallback to English
    if lang != "en":
        return load_i18n("en")

    # Ultimate fallback: return empty dict
    return {}


def render_article_jinja(
    article,
    lang: str,
    lang_config: dict,
    ui_strings: dict,
    category_config: dict,
    languages: list,
) -> str:
    """
    Render article HTML using Jinja2 templates.

    This replaces the inline HTML_TEMPLATE string formatting with
    version-controlled template files.

    Prefers i18n JSON files over hardcoded ui_strings when available.
    """
    template = jinja_env.get_template('article.html.j2')

    # Prefer JSON i18n over hardcoded ui_strings
    i18n = load_i18n(lang)
    if not i18n:
        i18n = ui_strings  # Fallback to passed ui_strings

    # Prepare localized content
    title = (article.title or {}).get(lang) or (article.title or {}).get("en", "")
    content = (article.content or {}).get(lang) or (article.content or {}).get("en", "")
    excerpt = (article.excerpt or {}).get(lang) or (article.excerpt or {}).get("en", "")
    meta_desc = (article.meta_description or {}).get(lang) or excerpt or ""

    # Calculate reading time
    word_count = len(content.replace("<", " <").split())
    reading_minutes = max(1, word_count // 200)
    reading_time = i18n.get("reading_time", "{min} min read").format(min=reading_minutes)

    # Format dates
    pub_date = article.published_at or datetime.utcnow()
    try:
        published_date = pub_date.strftime("%B %d, %Y")
    except Exception:
        published_date = str(pub_date.date())

    # Featured image HTML
    featured_image_html = ""
    if article.featured_image:
        img_alt = (article.image_alt or {}).get(lang) or (article.image_alt or {}).get("en", "")
        figcaption = ""
        if hasattr(article, 'image_credit') and article.image_credit:
            figcaption = f"<figcaption>{article.image_credit}</figcaption>"
        featured_image_html = f'''<figure class="article-image">
            <img src="{article.featured_image}" alt="{img_alt}" loading="lazy">
            {figcaption}
        </figure>'''

    # Generate hreflang links
    category_path = category_config["path"]
    hreflang_parts = []
    for alt_lang in languages:
        alt_code = alt_lang["code"]
        alt_path = alt_lang["path"]
        hreflang_parts.append(
            f'<link rel="alternate" hreflang="{alt_code}" href="https://bronze.news/{alt_path}{category_path}/{article.slug}/">'
        )
    hreflang_parts.append(f'<link rel="alternate" hreflang="x-default" href="https://bronze.news/{category_path}/{article.slug}/">')
    hreflang_links = "\n  ".join(hreflang_parts)

    # Render template
    html = template.render(
        # Language settings
        lang=lang,
        dir=lang_config["dir"],
        lang_path=lang_config["path"],
        languages=languages,

        # Article data
        article=article,
        title=title,
        content=content,
        meta_description=meta_desc,
        canonical_url=f"https://bronze.news/{lang_config['path']}{category_path}/{article.slug}/",

        # Category
        category_path=category_path,
        category_label=category_config["labels"].get(lang) or category_config["labels"].get("en", "News"),

        # Dates and reading time
        published_date=published_date,
        published_iso=pub_date.isoformat() if pub_date else "",
        reading_time=reading_time,

        # Optional sections
        featured_image_html=featured_image_html,
        hreflang_links=hreflang_links,

        # UI translations (from JSON files)
        i18n=i18n,
        current_nav="",  # Articles don't highlight nav items
    )

    return html


def render_index_jinja(
    page_config: dict,
    articles: list,
    lang: str,
    lang_config: dict,
    ui_strings: dict,
    languages: list,
    category_config: dict,
) -> str:
    """
    Render index page HTML using Jinja2 templates.

    Prefers i18n JSON files over hardcoded ui_strings when available.
    """
    template = jinja_env.get_template('index.html.j2')

    # Prefer JSON i18n over hardcoded ui_strings
    i18n = load_i18n(lang)
    if not i18n:
        i18n = ui_strings  # Fallback to passed ui_strings

    # Prepare headline if configured
    headline_article = None
    display_articles = articles
    if page_config.get("has_headline") and articles:
        headline_article = articles[0]
        display_articles = articles[1:]

    # Prepare articles with localized data
    prepared_articles = []
    for article in display_articles:
        art_title = (article.title or {}).get(lang) or (article.title or {}).get("en", "Untitled")
        art_excerpt = (article.excerpt or {}).get(lang) or (article.excerpt or {}).get("en", "")
        if len(art_excerpt) > 150:
            art_excerpt = art_excerpt[:147] + "..."

        art_category = article.category or "news"
        art_cat_config = category_config.get(art_category, category_config.get("news", {}))

        pub_date = article.published_at or datetime.utcnow()

        prepared_articles.append({
            "slug": article.slug,
            "title_localized": art_title,
            "excerpt_localized": art_excerpt,
            "category_path": art_cat_config.get("path", "news"),
            "category_label": art_cat_config.get("labels", {}).get(lang, "News"),
            "filter_category": FILTER_CATEGORY_MAP.get(art_category, "sport"),
            "date_iso": pub_date.strftime("%Y-%m-%d"),
            "date_formatted": pub_date.strftime("%b %d, %Y"),
        })

    # Prepare headline with localized data
    prepared_headline = None
    if headline_article:
        hl_title = (headline_article.title or {}).get(lang) or (headline_article.title or {}).get("en", "")
        hl_excerpt = (headline_article.excerpt or {}).get(lang) or (headline_article.excerpt or {}).get("en", "")
        if len(hl_excerpt) > 250:
            hl_excerpt = hl_excerpt[:247] + "..."

        hl_category = headline_article.category or "news"
        hl_cat_config = category_config.get(hl_category, category_config.get("news", {}))
        hl_pub_date = headline_article.published_at or datetime.utcnow()

        prepared_headline = {
            "slug": headline_article.slug,
            "title_localized": hl_title,
            "excerpt_localized": hl_excerpt,
            "category_path": hl_cat_config.get("path", "news"),
            "category_label": hl_cat_config.get("labels", {}).get(lang, "News"),
            "date_iso": hl_pub_date.strftime("%Y-%m-%d"),
            "date_formatted": hl_pub_date.strftime("%b %d, %Y"),
        }

    # Prepare filters
    prepared_filters = []
    if page_config.get("filters"):
        filter_key_to_data = {
            "all": "all", "biathlon": "sport", "alpine": "sport",
            "history": "history", "venue": "venue", "guide": "guide",
        }
        for filter_key in page_config["filters"]:
            prepared_filters.append({
                "data_filter": filter_key_to_data.get(filter_key, filter_key),
                "label": FILTER_LABELS.get(filter_key, {}).get(lang, filter_key.title()),
            })

    # Get page title
    page_title = page_config["heading"].get(lang) or page_config["heading"].get("en", "Bronze")
    meta_desc = page_config["meta"].get(lang) or page_config["meta"].get("en", "")

    html = template.render(
        lang=lang,
        dir=lang_config["dir"],
        lang_path=lang_config["path"],
        languages=languages,
        title=page_title,
        page_title=page_title,
        meta_description=meta_desc,
        canonical_url=f"https://bronze.news/{lang_config['path']}{page_config['slug']}",
        current_nav=page_config.get("nav_current", ""),
        i18n=i18n,  # From JSON files
        articles=prepared_articles,
        headline_article=prepared_headline,
        filters=prepared_filters if prepared_filters else None,
    )

    return html


# =============================================================================
# Internal HTML Generation Function
# Used by regeneration queue to generate HTML without HTTP context
# =============================================================================

async def generate_article_html_internal(slug: str) -> dict:
    """
    Generate static HTML files for an article in all languages.

    This is an internal function for the regeneration queue processor.
    It creates its own database session and handles errors without raising HTTPException.

    Args:
        slug: Article slug to generate HTML for

    Returns:
        dict with success status, files_generated count, and any error message
    """
    from src.db import get_session

    async with get_session() as session:
        article = await get_article_by_slug(session, slug)

        if not article:
            return {
                "success": False,
                "error": f"Article not found: {slug}",
                "files_generated": 0,
            }

        # Base path for HTML files
        base_path = Path(os.environ.get("HTML_OUTPUT_PATH", "/var/www/bronze.news"))
        generated_paths = []

        for lang_config in LANGUAGES:
            lang = lang_config["code"]
            lang_path = lang_config["path"]

            # Get localized content with English fallback
            title = (article.title or {}).get(lang) or (article.title or {}).get("en", "")
            content = (article.content or {}).get(lang) or (article.content or {}).get("en", "")

            # Skip if no content for this language
            if not title or not content:
                continue

            # Get category configuration
            category = article.category or "news"
            cat_config = CATEGORY_CONFIG.get(category, DEFAULT_CATEGORY)

            # Generate HTML using Jinja2 templates (or fallback to legacy)
            if USE_JINJA_TEMPLATES:
                html = render_article_jinja(
                    article=article,
                    lang=lang,
                    lang_config=lang_config,
                    ui_strings=load_i18n(lang),
                    category_config=cat_config,
                    languages=LANGUAGES,
                )
            else:
                # Legacy generation - use the same logic as the endpoint
                # but simplified since validation already passed at publish time
                ui = UI_STRINGS.get(lang, UI_STRINGS["en"])
                word_count = len(content.replace("<", " <").split())
                reading_minutes = max(1, word_count // 200)
                reading_time = ui["reading_time"].format(min=reading_minutes)

                pub_date = article.published_at or datetime.utcnow()
                try:
                    published_date = pub_date.strftime("%B %d, %Y")
                except Exception:
                    published_date = str(pub_date.date())

                excerpt = (article.excerpt or {}).get(lang) or (article.excerpt or {}).get("en", "")
                meta_desc = (article.meta_description or {}).get(lang) or excerpt or ""

                featured_image_section = ""
                if article.featured_image:
                    img_alt = (article.image_alt or {}).get(lang) or (article.image_alt or {}).get("en", "")
                    figcaption = ""
                    if hasattr(article, 'image_credit') and article.image_credit:
                        figcaption = f"<figcaption>{article.image_credit}</figcaption>"
                    featured_image_section = f'''<figure class="article-image">
                        <img src="{article.featured_image}" alt="{img_alt}" loading="lazy">
                        {figcaption}
                    </figure>'''

                category_path = cat_config["path"]
                category_label = cat_config["labels"].get(lang) or cat_config["labels"].get("en", "News")

                hreflang_parts = []
                for alt_lang in LANGUAGES:
                    alt_code = alt_lang["code"]
                    alt_path = alt_lang["path"]
                    hreflang_parts.append(
                        f'<link rel="alternate" hreflang="{alt_code}" href="https://bronze.news/{alt_path}{category_path}/{slug}/">'
                    )
                hreflang_parts.append(f'<link rel="alternate" hreflang="x-default" href="https://bronze.news/{category_path}/{slug}/">')
                hreflang_links = "\n  ".join(hreflang_parts)

                lang_selections = {
                    f"sel_{lc['code']}": "selected" if lc["code"] == lang else ""
                    for lc in LANGUAGES
                }

                html = HTML_TEMPLATE.format(
                    lang=lang,
                    dir=lang_config["dir"],
                    title=title,
                    meta_description=meta_desc[:155] if meta_desc else "",
                    lang_path=lang_path,
                    slug=slug,
                    published_iso=pub_date.isoformat() if pub_date else "",
                    published_date=published_date,
                    reading_time=reading_time,
                    featured_image_section=featured_image_section,
                    content=content,
                    category_path=category_path,
                    category_label=category_label,
                    hreflang_links=hreflang_links,
                    ui_skip=ui.get("skip", "Skip to main content"),
                    ui_nav_news=ui.get("nav_news", "News"),
                    ui_nav_alpine=ui.get("nav_alpine", "Alpine"),
                    ui_nav_biathlon=ui.get("nav_biathlon", "Biathlon"),
                    ui_nav_athletes=ui.get("nav_athletes", "Athletes"),
                    ui_nav_app=ui.get("nav_app", "Get App"),
                    ui_select_lang=ui.get("select_lang", "Select language"),
                    ui_footer_app=ui.get("footer_app", "Get the App"),
                    ui_footer_privacy=ui.get("footer_privacy", "Privacy"),
                    ui_footer_support=ui.get("footer_support", "Support"),
                    ui_footer_disclaimer=ui.get("footer_disclaimer", "Independent winter sports coverage."),
                    **lang_selections,
                )

            # Write HTML file
            output_path = base_path / lang_path / cat_config["path"] / slug / "index.html"
            try:
                output_path.parent.mkdir(parents=True, exist_ok=True)
                output_path.write_text(html, encoding="utf-8")
                generated_paths.append(str(output_path.relative_to(base_path)))
            except Exception as e:
                log.error("Failed to write HTML", path=str(output_path), error=str(e))
                return {
                    "success": False,
                    "error": f"Failed to write HTML for {lang}: {str(e)}",
                    "files_generated": len(generated_paths),
                }

        if not generated_paths:
            return {
                "success": False,
                "error": "No content available in any language",
                "files_generated": 0,
            }

        log.info("HTML generation complete (internal)", slug=slug, files=len(generated_paths))

        return {
            "success": True,
            "files_generated": len(generated_paths),
            "paths": generated_paths,
        }


async def get_db():
    """Dependency for database session."""
    async with get_session() as session:
        yield session


@router.get("", response_model=ArticleListResponse)
async def list_articles(
    lang: str = Query("en", description="Language code (en, de, fr, it, es, pt, nl, ar, ja, zh, ko)"),
    category: Optional[str] = Query(None, description="Filter by category (alpine-skiing, biathlon, etc.)"),
    sport_code: Optional[str] = Query(None, description="Filter by sport code (ALP, BTH, etc.)"),
    limit: int = Query(20, ge=1, le=100, description="Maximum articles to return"),
    offset: int = Query(0, ge=0, description="Offset for pagination"),
    session: AsyncSession = Depends(get_db),
):
    """
    Get published articles with optional filters.

    Returns articles in the requested language with fallback to English.
    """
    if lang not in SUPPORTED_LANGS:
        lang = "en"

    articles, total = await get_articles(
        session,
        category=category,
        sport_code=sport_code,
        limit=limit,
        offset=offset,
    )

    return ArticleListResponse(
        articles=[
            ArticleListItem(
                id=a.id,
                slug=a.slug,
                title=a.get_localized("title", lang),
                excerpt=a.get_localized("excerpt", lang),
                category=a.category,
                sport_code=a.sport_code,
                venue=a.venue,
                venue_city=a.venue_city,
                featured_image=a.featured_image,
                image_alt=a.get_localized("image_alt", lang),
                published_at=a.published_at,
            )
            for a in articles
        ],
        total=total,
        limit=limit,
        offset=offset,
    )


@router.get("/featured", response_model=list[ArticleListItem])
async def list_featured_articles(
    lang: str = Query("en", description="Language code"),
    limit: int = Query(5, ge=1, le=10, description="Maximum articles to return"),
    session: AsyncSession = Depends(get_db),
):
    """
    Get featured articles (most recent published).
    """
    if lang not in SUPPORTED_LANGS:
        lang = "en"

    articles = await get_featured_articles(session, limit=limit)

    return [
        ArticleListItem(
            id=a.id,
            slug=a.slug,
            title=a.get_localized("title", lang),
            excerpt=a.get_localized("excerpt", lang),
            category=a.category,
            sport_code=a.sport_code,
            venue=a.venue,
            venue_city=a.venue_city,
            featured_image=a.featured_image,
            image_alt=a.get_localized("image_alt", lang),
            published_at=a.published_at,
        )
        for a in articles
    ]


@router.get("/{slug}/raw", response_model=ArticleRaw)
async def get_article_raw(
    slug: str,
    session: AsyncSession = Depends(get_db),
):
    """
    Get raw article with JSONB fields intact (for n8n HTML generator).

    Returns the full multilingual content structure.
    """
    article = await get_article_by_slug(session, slug)

    if not article:
        raise HTTPException(status_code=404, detail="Article not found")

    return ArticleRaw(
        id=article.id,
        slug=article.slug,
        title=article.title or {},
        excerpt=article.excerpt,
        content=article.content or {},
        meta_description=article.meta_description,
        category=article.category,
        sport_code=article.sport_code,
        athlete_slugs=article.athlete_slugs or [],
        venue=article.venue,
        venue_city=article.venue_city,
        featured_image=article.featured_image,
        image_alt=article.image_alt,
        published_at=article.published_at,
        updated_at=article.updated_at,
        structured_data=article.structured_data,
    )


@router.get("/{slug}", response_model=ArticleDetail)
async def get_article(
    slug: str,
    lang: str = Query("en", description="Language code"),
    session: AsyncSession = Depends(get_db),
):
    """
    Get a single article by slug with full content.
    """
    if lang not in SUPPORTED_LANGS:
        lang = "en"

    article = await get_article_by_slug(session, slug)

    if not article:
        raise HTTPException(status_code=404, detail="Article not found")

    # Only return published articles publicly
    if article.status != "published":
        raise HTTPException(status_code=404, detail="Article not found")

    return ArticleDetail(
        id=article.id,
        slug=article.slug,
        title=article.get_localized("title", lang),
        excerpt=article.get_localized("excerpt", lang),
        content=article.get_localized("content", lang),
        category=article.category,
        sport_code=article.sport_code,
        athlete_slugs=article.athlete_slugs or [],
        venue=article.venue,
        venue_city=article.venue_city,
        featured_image=article.featured_image,
        image_alt=article.get_localized("image_alt", lang),
        published_at=article.published_at,
        updated_at=article.updated_at,
    )


@router.post("", response_model=ArticleDetail, status_code=201)
async def create_new_article(
    article_data: ArticleCreate,
    lang: str = Query("en", description="Language for response"),
    session: AsyncSession = Depends(get_db),
):
    """
    Create a new article (used by n8n webhook).

    Expects multilingual content in JSONB format.
    Validates against legal blocklist before saving (€2.5M fine prevention).
    """
    # CRITICAL: Legal blocklist check BEFORE database write
    # This is belt-and-suspenders - we also check during HTML generation
    all_text_parts = []
    article_dict = article_data.model_dump()

    # Collect all text content for legal check
    for lang_code in SUPPORTED_LANGS:
        if article_dict.get("title", {}).get(lang_code):
            all_text_parts.append(article_dict["title"][lang_code])
        if article_dict.get("excerpt", {}).get(lang_code):
            all_text_parts.append(article_dict["excerpt"][lang_code])
        if article_dict.get("content", {}).get(lang_code):
            all_text_parts.append(article_dict["content"][lang_code])

    all_text = " ".join(all_text_parts)
    legal_violations = check_legal_blocklist(all_text)

    if legal_violations:
        log.error(
            "LEGAL VIOLATION - Article creation blocked",
            slug=article_data.slug,
            violations=legal_violations,
        )

        # Log rejection to database for monitoring
        try:
            rejection_result = ValidationResult(
                passed=False,
                errors=[f"LEGAL: {v}" for v in legal_violations],
                warnings=[]
            )
            await log_validation_rejection(
                session=session,
                slug=article_data.slug,
                rejection_type="legal",
                result=rejection_result,
                raw_content={"title": article_dict.get("title", {}).get("en", "")},
                source="api"
            )
            await session.commit()
        except Exception as e:
            log.warning("Failed to log rejection to database", error=str(e))

        raise HTTPException(
            status_code=422,
            detail={
                "message": "Article contains banned terms (Italian Law 31/2020)",
                "violations": legal_violations,
                "fine_risk": "€100,000 to €2,500,000",
            }
        )

    # Check if slug already exists
    existing = await get_article_by_slug(session, article_data.slug)
    if existing:
        raise HTTPException(status_code=409, detail="Article with this slug already exists")

    article = await create_article(session, article_dict)
    await session.commit()

    log.info("Article created", slug=article.slug, status=article.status)

    return ArticleDetail(
        id=article.id,
        slug=article.slug,
        title=article.get_localized("title", lang),
        excerpt=article.get_localized("excerpt", lang),
        content=article.get_localized("content", lang),
        category=article.category,
        sport_code=article.sport_code,
        athlete_slugs=article.athlete_slugs or [],
        venue=article.venue,
        venue_city=article.venue_city,
        featured_image=article.featured_image,
        image_alt=article.get_localized("image_alt", lang),
        published_at=article.published_at,
        updated_at=article.updated_at,
    )


@router.post("/{slug}/publish", response_model=ArticleDetail)
async def publish_article_endpoint(
    slug: str,
    lang: str = Query("en", description="Language for response"),
    session: AsyncSession = Depends(get_db),
):
    """
    Publish a draft article.
    """
    article = await publish_article(session, slug)

    if not article:
        raise HTTPException(status_code=404, detail="Article not found")

    await session.commit()

    log.info("Article published", slug=article.slug)

    return ArticleDetail(
        id=article.id,
        slug=article.slug,
        title=article.get_localized("title", lang),
        excerpt=article.get_localized("excerpt", lang),
        content=article.get_localized("content", lang),
        category=article.category,
        sport_code=article.sport_code,
        athlete_slugs=article.athlete_slugs or [],
        venue=article.venue,
        venue_city=article.venue_city,
        featured_image=article.featured_image,
        image_alt=article.get_localized("image_alt", lang),
        published_at=article.published_at,
        updated_at=article.updated_at,
    )


@router.patch("/{slug}/translation", response_model=ArticleRaw)
async def update_article_translation(
    slug: str,
    translation: ArticleTranslationUpdate,
    session: AsyncSession = Depends(get_db),
):
    """
    Update article translation for a specific language.

    Used for adding/updating translations without affecting other languages.
    Validates against legal blocklist before saving.
    """
    # Validate language code
    if translation.lang not in SUPPORTED_LANGS:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid language code. Supported: {', '.join(sorted(SUPPORTED_LANGS))}"
        )

    if translation.lang == "en":
        raise HTTPException(
            status_code=400,
            detail="Cannot update English via translation endpoint. Use main article endpoints."
        )

    # Get existing article
    article = await get_article_by_slug(session, slug)
    if not article:
        raise HTTPException(status_code=404, detail="Article not found")

    # Legal blocklist check on new translation
    all_text = f"{translation.title} {translation.excerpt or ''} {translation.content}"
    legal_violations = check_legal_blocklist(all_text)

    if legal_violations:
        log.error(
            "LEGAL VIOLATION - Translation blocked",
            slug=slug,
            lang=translation.lang,
            violations=legal_violations,
        )
        raise HTTPException(
            status_code=422,
            detail={
                "message": "Translation contains banned terms (Italian Law 31/2020)",
                "violations": legal_violations,
                "fine_risk": "€100,000 to €2,500,000",
            }
        )

    # Update JSONB fields with new translation
    # Merge with existing translations
    title_dict = dict(article.title or {})
    title_dict[translation.lang] = translation.title

    content_dict = dict(article.content or {})
    content_dict[translation.lang] = translation.content

    excerpt_dict = dict(article.excerpt or {})
    if translation.excerpt:
        excerpt_dict[translation.lang] = translation.excerpt

    meta_desc_dict = dict(article.meta_description or {})
    if translation.meta_description:
        meta_desc_dict[translation.lang] = translation.meta_description

    # Update article with merged translations
    article_data = {
        "title": title_dict,
        "content": content_dict,
        "excerpt": excerpt_dict,
        "meta_description": meta_desc_dict,
    }

    updated_article = await update_article(session, slug, article_data)
    await session.commit()

    log.info("Translation updated", slug=slug, lang=translation.lang)

    return ArticleRaw(
        id=updated_article.id,
        slug=updated_article.slug,
        title=updated_article.title or {},
        excerpt=updated_article.excerpt,
        content=updated_article.content or {},
        meta_description=updated_article.meta_description,
        category=updated_article.category,
        sport_code=updated_article.sport_code,
        athlete_slugs=updated_article.athlete_slugs or [],
        venue=updated_article.venue,
        venue_city=updated_article.venue_city,
        featured_image=updated_article.featured_image,
        image_alt=updated_article.image_alt,
        published_at=updated_article.published_at,
        updated_at=updated_article.updated_at,
        structured_data=updated_article.structured_data,
    )


# ============================================================================
# HTML Generation
# ============================================================================

# Language configuration for HTML generation
LANGUAGES = [
    {"code": "en", "name": "English", "dir": "ltr", "path": ""},
    {"code": "de", "name": "Deutsch", "dir": "ltr", "path": "de/"},
    {"code": "fr", "name": "Français", "dir": "ltr", "path": "fr/"},
    {"code": "it", "name": "Italiano", "dir": "ltr", "path": "it/"},
    {"code": "es", "name": "Español", "dir": "ltr", "path": "es/"},
    {"code": "pt", "name": "Português", "dir": "ltr", "path": "pt/"},
    {"code": "nl", "name": "Nederlands", "dir": "ltr", "path": "nl/"},
    {"code": "ar", "name": "العربية", "dir": "rtl", "path": "ar/"},
    {"code": "ja", "name": "日本語", "dir": "ltr", "path": "ja/"},
    {"code": "zh", "name": "中文", "dir": "ltr", "path": "zh/"},
    {"code": "ko", "name": "한국어", "dir": "ltr", "path": "ko/"},
]

UI_STRINGS = {
    "en": {
        "reading_time": "{min} min read",
        "skip": "Skip to main content",
        "nav_news": "News",
        "nav_alpine": "Alpine",
        "nav_biathlon": "Biathlon",
        "nav_athletes": "Athletes",
        "nav_app": "Get App",
        "select_lang": "Select language",
        "footer_app": "Get the App",
        "footer_privacy": "Privacy",
        "footer_support": "Support",
        "footer_disclaimer": "Independent winter sports coverage.",
    },
    "de": {
        "reading_time": "{min} Min. Lesezeit",
        "skip": "Zum Hauptinhalt springen",
        "nav_news": "Nachrichten",
        "nav_alpine": "Ski Alpin",
        "nav_biathlon": "Biathlon",
        "nav_athletes": "Athleten",
        "nav_app": "App laden",
        "select_lang": "Sprache wählen",
        "footer_app": "App herunterladen",
        "footer_privacy": "Datenschutz",
        "footer_support": "Support",
        "footer_disclaimer": "Unabhängige Wintersport-Berichterstattung.",
    },
    "fr": {
        "reading_time": "{min} min de lecture",
        "skip": "Aller au contenu principal",
        "nav_news": "Actualités",
        "nav_alpine": "Ski Alpin",
        "nav_biathlon": "Biathlon",
        "nav_athletes": "Athlètes",
        "nav_app": "Télécharger",
        "select_lang": "Choisir la langue",
        "footer_app": "Télécharger l'app",
        "footer_privacy": "Confidentialité",
        "footer_support": "Assistance",
        "footer_disclaimer": "Couverture indépendante des sports d'hiver.",
    },
    "it": {
        "reading_time": "{min} min di lettura",
        "skip": "Vai al contenuto principale",
        "nav_news": "Notizie",
        "nav_alpine": "Sci Alpino",
        "nav_biathlon": "Biathlon",
        "nav_athletes": "Atleti",
        "nav_app": "Scarica App",
        "select_lang": "Seleziona lingua",
        "footer_app": "Scarica l'App",
        "footer_privacy": "Privacy",
        "footer_support": "Supporto",
        "footer_disclaimer": "Copertura indipendente degli sport invernali.",
    },
    "es": {
        "reading_time": "{min} min de lectura",
        "skip": "Ir al contenido principal",
        "nav_news": "Noticias",
        "nav_alpine": "Esquí Alpino",
        "nav_biathlon": "Biatlón",
        "nav_athletes": "Atletas",
        "nav_app": "Descargar",
        "select_lang": "Seleccionar idioma",
        "footer_app": "Descargar App",
        "footer_privacy": "Privacidad",
        "footer_support": "Soporte",
        "footer_disclaimer": "Cobertura independiente de deportes de invierno.",
    },
    "pt": {
        "reading_time": "{min} min de leitura",
        "skip": "Ir para o conteúdo principal",
        "nav_news": "Notícias",
        "nav_alpine": "Esqui Alpino",
        "nav_biathlon": "Biatlo",
        "nav_athletes": "Atletas",
        "nav_app": "Baixar App",
        "select_lang": "Selecionar idioma",
        "footer_app": "Baixar o App",
        "footer_privacy": "Privacidade",
        "footer_support": "Suporte",
        "footer_disclaimer": "Cobertura independente de esportes de inverno.",
    },
    "nl": {
        "reading_time": "{min} min leestijd",
        "skip": "Ga naar hoofdinhoud",
        "nav_news": "Nieuws",
        "nav_alpine": "Alpineskiën",
        "nav_biathlon": "Biathlon",
        "nav_athletes": "Atleten",
        "nav_app": "Download App",
        "select_lang": "Selecteer taal",
        "footer_app": "Download de App",
        "footer_privacy": "Privacy",
        "footer_support": "Ondersteuning",
        "footer_disclaimer": "Onafhankelijke wintersport verslaggeving.",
    },
    "ar": {
        "reading_time": "{min} دقيقة قراءة",
        "skip": "انتقل إلى المحتوى الرئيسي",
        "nav_news": "أخبار",
        "nav_alpine": "تزلج جبال الألب",
        "nav_biathlon": "البياثلون",
        "nav_athletes": "الرياضيون",
        "nav_app": "تحميل التطبيق",
        "select_lang": "اختر اللغة",
        "footer_app": "تحميل التطبيق",
        "footer_privacy": "الخصوصية",
        "footer_support": "الدعم",
        "footer_disclaimer": "تغطية مستقلة للرياضات الشتوية.",
    },
    "ja": {
        "reading_time": "{min}分で読めます",
        "skip": "メインコンテンツへスキップ",
        "nav_news": "ニュース",
        "nav_alpine": "アルペン",
        "nav_biathlon": "バイアスロン",
        "nav_athletes": "選手",
        "nav_app": "アプリ",
        "select_lang": "言語を選択",
        "footer_app": "アプリを入手",
        "footer_privacy": "プライバシー",
        "footer_support": "サポート",
        "footer_disclaimer": "独立したウィンタースポーツ報道。",
    },
    "zh": {
        "reading_time": "{min}分钟阅读",
        "skip": "跳至主要内容",
        "nav_news": "新闻",
        "nav_alpine": "高山滑雪",
        "nav_biathlon": "冬季两项",
        "nav_athletes": "运动员",
        "nav_app": "下载应用",
        "select_lang": "选择语言",
        "footer_app": "下载应用",
        "footer_privacy": "隐私",
        "footer_support": "支持",
        "footer_disclaimer": "独立的冬季运动报道。",
    },
    "ko": {
        "reading_time": "{min}분 소요",
        "skip": "주요 콘텐츠로 건너뛰기",
        "nav_news": "뉴스",
        "nav_alpine": "알파인",
        "nav_biathlon": "바이애슬론",
        "nav_athletes": "선수",
        "nav_app": "앱 다운로드",
        "select_lang": "언어 선택",
        "footer_app": "앱 다운로드",
        "footer_privacy": "개인정보",
        "footer_support": "지원",
        "footer_disclaimer": "독립적인 동계 스포츠 보도.",
    },
}

# Category to URL path mapping and labels
# See docs/ARCHITECTURE.md for full documentation
CATEGORY_CONFIG = {
    "athlete-profile": {
        "path": "athletes",
        "labels": {
            "en": "Athletes", "de": "Athleten", "fr": "Athlètes", "it": "Atleti",
            "es": "Atletas", "pt": "Atletas", "nl": "Atleten", "ar": "الرياضيون",
            "ja": "選手", "zh": "运动员", "ko": "선수"
        }
    },
    "venue-guide": {
        "path": "venues",
        "labels": {
            "en": "Venues", "de": "Austragungsorte", "fr": "Sites", "it": "Sedi",
            "es": "Sedes", "pt": "Locais", "nl": "Locaties", "ar": "الأماكن",
            "ja": "会場", "zh": "场地", "ko": "경기장"
        }
    },
    "sport-explainer": {
        "path": "guides",
        "labels": {
            "en": "Guides", "de": "Ratgeber", "fr": "Guides", "it": "Guide",
            "es": "Guías", "pt": "Guias", "nl": "Gidsen", "ar": "أدلة",
            "ja": "ガイド", "zh": "指南", "ko": "가이드"
        }
    },
    "historical": {
        "path": "history",
        "labels": {
            "en": "History", "de": "Geschichte", "fr": "Histoire", "it": "Storia",
            "es": "Historia", "pt": "História", "nl": "Geschiedenis", "ar": "التاريخ",
            "ja": "歴史", "zh": "历史", "ko": "역사"
        }
    },
    "biathlon": {
        "path": "biathlon",
        "labels": {
            "en": "Biathlon", "de": "Biathlon", "fr": "Biathlon", "it": "Biathlon",
            "es": "Biatlón", "pt": "Biatlo", "nl": "Biathlon", "ar": "البياثلون",
            "ja": "バイアスロン", "zh": "冬季两项", "ko": "바이애슬론"
        }
    },
    "alpine-skiing": {
        "path": "alpine-skiing",
        "labels": {
            "en": "Alpine Skiing", "de": "Ski Alpin", "fr": "Ski Alpin", "it": "Sci Alpino",
            "es": "Esquí Alpino", "pt": "Esqui Alpino", "nl": "Alpineskiën", "ar": "التزلج الألبي",
            "ja": "アルペンスキー", "zh": "高山滑雪", "ko": "알파인 스키"
        }
    },
    "cross-country": {
        "path": "cross-country",
        "labels": {
            "en": "Cross-Country", "de": "Langlauf", "fr": "Ski de Fond", "it": "Sci di Fondo",
            "es": "Esquí de Fondo", "pt": "Esqui Cross-Country", "nl": "Langlaufen", "ar": "التزلج الريفي",
            "ja": "クロスカントリー", "zh": "越野滑雪", "ko": "크로스컨트리"
        }
    },
    "ski-jumping": {
        "path": "ski-jumping",
        "labels": {
            "en": "Ski Jumping", "de": "Skispringen", "fr": "Saut à Ski", "it": "Salto con gli Sci",
            "es": "Salto de Esquí", "pt": "Salto de Esqui", "nl": "Schansspringen", "ar": "قفز التزلج",
            "ja": "スキージャンプ", "zh": "跳台滑雪", "ko": "スキ점프"
        }
    },
    "nordic-combined": {
        "path": "nordic-combined",
        "labels": {
            "en": "Nordic Combined", "de": "Nordische Kombination", "fr": "Combiné Nordique", "it": "Combinata Nordica",
            "es": "Combinada Nórdica", "pt": "Combinado Nórdico", "nl": "Noordse Combinatie", "ar": "الجمع الشمالي",
            "ja": "ノルディック複合", "zh": "北欧两项", "ko": "노르딕 복합"
        }
    },
    "freestyle": {
        "path": "freestyle",
        "labels": {
            "en": "Freestyle", "de": "Freestyle", "fr": "Freestyle", "it": "Freestyle",
            "es": "Freestyle", "pt": "Freestyle", "nl": "Freestyle", "ar": "فريستايل",
            "ja": "フリースタイル", "zh": "自由式", "ko": "프리스타일"
        }
    },
    "snowboard": {
        "path": "snowboard",
        "labels": {
            "en": "Snowboard", "de": "Snowboard", "fr": "Snowboard", "it": "Snowboard",
            "es": "Snowboard", "pt": "Snowboard", "nl": "Snowboard", "ar": "تزلج الجليد",
            "ja": "スノーボード", "zh": "单板滑雪", "ko": "스노보드"
        }
    },
    "news": {
        "path": "news",
        "labels": {
            "en": "News", "de": "Nachrichten", "fr": "Actualités", "it": "Notizie",
            "es": "Noticias", "pt": "Notícias", "nl": "Nieuws", "ar": "أخبار",
            "ja": "ニュース", "zh": "新闻", "ko": "뉴스"
        }
    },
}

# Default category for unmapped categories
DEFAULT_CATEGORY = {
    "path": "news",
    "labels": {
        "en": "News", "de": "Nachrichten", "fr": "Actualités", "it": "Notizie",
        "es": "Noticias", "pt": "Notícias", "nl": "Nieuws", "ar": "أخبار",
        "ja": "ニュース", "zh": "新闻", "ko": "뉴스"
    }
}

HTML_TEMPLATE = '''<!DOCTYPE html>
<html lang="{lang}" dir="{dir}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{title} - Bronze</title>
  <meta name="description" content="{meta_description}">

  <!-- Open Graph -->
  <meta property="og:title" content="{title} - Bronze">
  <meta property="og:description" content="{meta_description}">
  <meta property="og:type" content="article">
  <meta property="og:url" content="https://bronze.news/{lang_path}{category_path}/{slug}/">
  <meta property="og:site_name" content="Bronze">

  <!-- Twitter -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:site" content="@bronzenews">

  <!-- Canonical and alternates -->
  <link rel="canonical" href="https://bronze.news/{lang_path}{category_path}/{slug}/">
  {hreflang_links}

  <!-- Favicons -->
  <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32.png">
  <link rel="icon" type="image/png" sizes="64x64" href="/favicon-64.png">
  <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">

  <!-- Structured Data -->
  <script type="application/ld+json">
  {{
    "@context": "https://schema.org",
    "@type": "Article",
    "headline": "{title}",
    "datePublished": "{published_iso}",
    "author": {{"@type": "Organization", "name": "Bronze"}},
    "publisher": {{"@type": "Organization", "name": "Bronze", "logo": {{"@type": "ImageObject", "url": "https://bronze.news/logo-512.png"}}}}
  }}
  </script>

  <link rel="stylesheet" href="/static/style.css">
</head>
<body>
  <a href="#main-content" class="skip-link">{ui_skip}</a>

  <header class="site-header" role="banner">
    <div class="header-container">
      <a href="/{lang_path}" class="site-logo" aria-label="Bronze Home">
        <img src="/logo-128.png" alt="" width="40" height="40">
        <span>Bronze</span>
      </a>
      <nav class="header-nav" aria-label="Main navigation">
        <ul class="nav-links">
          <li><a href="/{lang_path}">{ui_nav_news}</a></li>
          <li><a href="/{lang_path}alpine-skiing/">{ui_nav_alpine}</a></li>
          <li><a href="/{lang_path}biathlon/">{ui_nav_biathlon}</a></li>
          <li><a href="/{lang_path}athletes/">{ui_nav_athletes}</a></li>
          <li><a href="/app">{ui_nav_app}</a></li>
        </ul>
        <label for="langSelect" class="visually-hidden">{ui_select_lang}</label>
        <select class="lang-selector" id="langSelect" aria-label="{ui_select_lang}" onchange="switchLang(this.value)">
          <option value="en" {sel_en}>English</option>
          <option value="de" {sel_de}>Deutsch</option>
          <option value="fr" {sel_fr}>Français</option>
          <option value="it" {sel_it}>Italiano</option>
          <option value="es" {sel_es}>Español</option>
          <option value="pt" {sel_pt}>Português</option>
          <option value="nl" {sel_nl}>Nederlands</option>
          <option value="ar" {sel_ar}>العربية</option>
          <option value="ja" {sel_ja}>日本語</option>
          <option value="zh" {sel_zh}>中文</option>
          <option value="ko" {sel_ko}>한국어</option>
        </select>
      </nav>
    </div>
  </header>

  <main id="main-content" role="main">
    <nav class="breadcrumb" aria-label="Breadcrumb">
      <a href="/{lang_path}">{ui_nav_news}</a>
      <span class="breadcrumb-separator" aria-hidden="true">›</span>
      <a href="/{lang_path}{category_path}/">{category_label}</a>
      <span class="breadcrumb-separator" aria-hidden="true">›</span>
      <span aria-current="page">{title}</span>
    </nav>

    <article>
      <header class="article-header">
        <span class="category-tag">{category_label}</span>
        <h1 class="article-title">{title}</h1>
        <div class="article-meta">
          <time datetime="{published_iso}">{published_date}</time>
          <span>·</span>
          <span>{reading_time}</span>
        </div>
      </header>

      {featured_image_section}

      <div class="article-content">
        {content}
      </div>
    </article>
  </main>

  <footer class="site-footer" role="contentinfo">
    <div class="footer-container">
      <nav class="footer-links" aria-label="Footer navigation">
        <a href="/app">{ui_footer_app}</a>
        <a href="/privacy">{ui_footer_privacy}</a>
        <a href="/support">{ui_footer_support}</a>
        <a href="https://x.com/bronzenews" target="_blank" rel="noopener noreferrer">X @bronzenews</a>
        <a href="https://instagram.com/bronzenews" target="_blank" rel="noopener noreferrer">Instagram</a>
      </nav>
      <p class="copyright">© 2026 Bronze. {ui_footer_disclaimer}</p>
    </div>
  </footer>

  <script>
    function switchLang(lang) {{
      const categoryPath = '{category_path}';
      const slug = '{slug}';
      const langPaths = {{ en: '', de: 'de/', fr: 'fr/', it: 'it/', es: 'es/', pt: 'pt/', nl: 'nl/', ar: 'ar/', ja: 'ja/', zh: 'zh/', ko: 'ko/' }};
      window.location.href = '/' + langPaths[lang] + categoryPath + '/' + slug + '/';
    }}
  </script>

  <!-- Matomo Analytics -->
  <script>
    var _paq = window._paq = window._paq || [];
    _paq.push(['trackPageView']);
    _paq.push(['enableLinkTracking']);
    (function() {{
      var u="//matomo.bronze.news/";
      _paq.push(['setTrackerUrl', u+'matomo.php']);
      _paq.push(['setSiteId', '1']);
      var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
      g.async=true; g.src=u+'matomo.js'; s.parentNode.insertBefore(g,s);
    }})();
  </script>
</body>
</html>'''


class HTMLGenerateResponse(BaseModel):
    """Response from HTML generation."""
    success: bool
    files_generated: int
    slug: str
    paths: list[str]


@router.post("/{slug}/generate-html", response_model=HTMLGenerateResponse)
async def generate_article_html(
    slug: str,
    session: AsyncSession = Depends(get_db),
):
    """
    Generate static HTML files for an article in all 11 languages.

    Files are written to /var/www/bronze.news/{lang_path}{slug}/index.html
    """
    article = await get_article_by_slug(session, slug)

    if not article:
        raise HTTPException(status_code=404, detail="Article not found")

    # Base path for HTML files
    base_path = Path(os.environ.get("HTML_OUTPUT_PATH", "/var/www/bronze.news"))
    generated_paths = []

    for lang_config in LANGUAGES:
        lang = lang_config["code"]
        lang_path = lang_config["path"]
        lang_dir = lang_config["dir"]

        # Get localized content with English fallback
        title = (article.title or {}).get(lang) or (article.title or {}).get("en", "")
        content = (article.content or {}).get(lang) or (article.content or {}).get("en", "")
        excerpt = (article.excerpt or {}).get(lang) or (article.excerpt or {}).get("en", "")
        meta_desc = (article.meta_description or {}).get(lang) or excerpt or ""

        # Skip if no content for this language
        if not title or not content:
            continue

        # Calculate reading time
        word_count = len(content.replace("<", " <").split())
        reading_minutes = max(1, word_count // 200)
        ui = UI_STRINGS.get(lang, UI_STRINGS["en"])
        reading_time = ui["reading_time"].format(min=reading_minutes)

        # Format published date
        pub_date = article.published_at or datetime.utcnow()
        try:
            published_date = pub_date.strftime("%B %d, %Y")
        except Exception:
            published_date = str(pub_date.date())

        # Generate featured image section
        featured_image_section = ""
        if article.featured_image:
            img_alt = (article.image_alt or {}).get(lang) or (article.image_alt or {}).get("en", "")
            figcaption = ""
            if hasattr(article, 'image_credit') and article.image_credit:
                figcaption = f"<figcaption>{article.image_credit}</figcaption>"
            featured_image_section = f'''<figure class="article-image">
                <img src="{article.featured_image}" alt="{img_alt}" loading="lazy">
                {figcaption}
            </figure>'''

        # Get category configuration
        category = article.category or "news"
        cat_config = CATEGORY_CONFIG.get(category, DEFAULT_CATEGORY)
        category_path = cat_config["path"]
        category_label = cat_config["labels"].get(lang) or cat_config["labels"].get("en", "News")

        # Generate hreflang links for SEO (hierarchical URLs)
        hreflang_parts = []
        for alt_lang in LANGUAGES:
            alt_code = alt_lang["code"]
            alt_path = alt_lang["path"]
            hreflang_parts.append(
                f'<link rel="alternate" hreflang="{alt_code}" href="https://bronze.news/{alt_path}{category_path}/{slug}/">'
            )
        hreflang_parts.append(f'<link rel="alternate" hreflang="x-default" href="https://bronze.news/{category_path}/{slug}/">')
        hreflang_links = "\n  ".join(hreflang_parts)

        # Generate HTML (Jinja2 templates or legacy inline template)
        if USE_JINJA_TEMPLATES:
            # Use version-controlled Jinja2 templates
            html = render_article_jinja(
                article=article,
                lang=lang,
                lang_config=lang_config,
                ui_strings=ui,
                category_config=cat_config,
                languages=LANGUAGES,
            )
        else:
            # Legacy: inline HTML_TEMPLATE (to be removed after migration)
            # Build language selector states (mark current language as selected)
            lang_selections = {
                f"sel_{lc['code']}": "selected" if lc["code"] == lang else ""
                for lc in LANGUAGES
            }

            html = HTML_TEMPLATE.format(
                lang=lang,
                dir=lang_dir,
                title=title,
                meta_description=meta_desc[:155] if meta_desc else "",
                lang_path=lang_path,
                slug=slug,
                published_iso=pub_date.isoformat() if pub_date else "",
                published_date=published_date,
                reading_time=reading_time,
                featured_image_section=featured_image_section,
                content=content,
                # Category info for breadcrumbs
                category_path=category_path,
                category_label=category_label,
                # SEO hreflang links
                hreflang_links=hreflang_links,
                # UI strings
                ui_skip=ui.get("skip", "Skip to main content"),
                ui_nav_news=ui.get("nav_news", "News"),
                ui_nav_alpine=ui.get("nav_alpine", "Alpine"),
                ui_nav_biathlon=ui.get("nav_biathlon", "Biathlon"),
                ui_nav_athletes=ui.get("nav_athletes", "Athletes"),
                ui_nav_app=ui.get("nav_app", "Get App"),
                ui_select_lang=ui.get("select_lang", "Select language"),
                ui_footer_app=ui.get("footer_app", "Get the App"),
                ui_footer_privacy=ui.get("footer_privacy", "Privacy"),
                ui_footer_support=ui.get("footer_support", "Support"),
                ui_footer_disclaimer=ui.get("footer_disclaimer", "Independent winter sports coverage."),
                # Language selector states
                **lang_selections,
            )

        # Determine output path (hierarchical: /{lang}/{category}/{slug}/index.html)
        output_path = base_path / lang_path / category_path / slug / "index.html"

        # Validate article and HTML before writing (CRITICAL - automated gatekeeper)
        # Only validate English version fully to avoid redundant checks
        if lang == "en":
            article_dict = {
                "slug": article.slug,
                "category": article.category,
                "title": article.title or {},
                "excerpt": article.excerpt or {},
                "content": article.content or {},
            }
            validation_result = validate_article_for_publish(article_dict, html)

            if not validation_result.passed:
                log.error(
                    "Article validation FAILED - blocking publish",
                    slug=slug,
                    errors=validation_result.errors,
                )

                # Log rejection to database for monitoring
                try:
                    rejection_type = determine_rejection_type(validation_result.errors)
                    await log_validation_rejection(
                        session=session,
                        slug=slug,
                        rejection_type=rejection_type,
                        result=validation_result,
                        raw_content=article_dict,
                        source="html_generation"
                    )
                    await session.commit()
                except Exception as e:
                    log.warning("Failed to log rejection to database", error=str(e))

                raise HTTPException(
                    status_code=422,
                    detail={
                        "message": "Article validation failed",
                        "errors": validation_result.errors,
                        "warnings": validation_result.warnings,
                    }
                )

            if validation_result.warnings:
                log.warning(
                    "Article validation passed with warnings",
                    slug=slug,
                    warnings=validation_result.warnings,
                )

        # Create directory and write file
        try:
            output_path.parent.mkdir(parents=True, exist_ok=True)
            output_path.write_text(html, encoding="utf-8")
            generated_paths.append(str(output_path.relative_to(base_path)))
            log.info("HTML generated", path=str(output_path), lang=lang)
        except Exception as e:
            log.error("Failed to write HTML", path=str(output_path), error=str(e))
            raise HTTPException(
                status_code=500,
                detail=f"Failed to write HTML for {lang}: {str(e)}"
            )

    if not generated_paths:
        raise HTTPException(
            status_code=400,
            detail="No content available in any language"
        )

    log.info("HTML generation complete", slug=slug, files=len(generated_paths))

    return HTMLGenerateResponse(
        success=True,
        files_generated=len(generated_paths),
        slug=slug,
        paths=generated_paths,
    )


# Index page template for homepage and category pages
INDEX_TEMPLATE = '''<!DOCTYPE html>
<html lang="{lang}" dir="{dir}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{page_title} - Bronze</title>
    <meta name="description" content="{meta_description}">
    <link rel="canonical" href="https://bronze.news/{lang_path}{page_slug}">
    <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32.png">
    <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
    <link rel="stylesheet" href="/static/style.css">
</head>
<body>
    <a href="#main" class="skip-link">Skip to main content</a>
    <header>
        <div class="header-inner">
            <a href="/{lang_path}" class="logo">
                <img src="/logo-128.png" alt="">
                <span>Bronze</span>
            </a>
            <nav aria-label="Main navigation">
                <ul>
                    <li><a href="/{lang_path}"{nav_home_current}>{nav_news}</a></li>
                    <li><a href="/{lang_path}alpine-skiing/"{nav_alpine_current}>{nav_alpine}</a></li>
                    <li><a href="/{lang_path}biathlon/"{nav_biathlon_current}>{nav_biathlon}</a></li>
                    <li><a href="/{lang_path}athletes/"{nav_athletes_current}>{nav_athletes}</a></li>
                    <li><a href="/app">{nav_app}</a></li>
                </ul>
            </nav>
        </div>
    </header>
    <main id="main">
        <h1>{heading}</h1>
        {filters_html}
        {headline_html}
        <div class="articles-grid">
            {articles_html}
        </div>
    </main>
    <footer>
        <nav class="footer-links" aria-label="Footer navigation">
            <a href="/app">Get App</a>
            <a href="/privacy">Privacy</a>
            <a href="/support">Support</a>
            <a href="https://x.com/bronzenews">X @bronzenews</a>
        </nav>
        <p class="copyright">&copy; 2026 Bronze. Independent winter sports coverage.</p>
    </footer>
    <script>
    (function() {{
        var filters = document.querySelector('.filters');
        if (!filters) return;

        var buttons = filters.querySelectorAll('.filter-btn');
        var articles = document.querySelectorAll('.article-card');

        buttons.forEach(function(btn) {{
            btn.addEventListener('click', function() {{
                var filter = this.getAttribute('data-filter');

                // Update active button
                buttons.forEach(function(b) {{ b.classList.remove('active'); }});
                this.classList.add('active');

                // Filter articles
                articles.forEach(function(article) {{
                    var category = article.getAttribute('data-filter');
                    if (filter === 'all' || category === filter || filter === category) {{
                        article.style.display = '';
                    }} else {{
                        article.style.display = 'none';
                    }}
                }});
            }});
        }});
    }})();
    </script>
</body>
</html>'''

ARTICLE_CARD_TEMPLATE = '''<article class="article-card" data-filter="{filter_category}">
    <span class="category-tag">{category_label}</span>
    <h2><a href="/{lang_path}{category_path}/{slug}/">{title}</a></h2>
    <p class="article-meta"><time datetime="{date_iso}">{date_formatted}</time></p>
    <p class="excerpt">{excerpt}</p>
</article>'''

HEADLINE_CARD_TEMPLATE = '''<article class="headline">
    <span class="category-tag">{category_label}</span>
    <h2><a href="/{lang_path}{category_path}/{slug}/">{title}</a></h2>
    <p class="article-meta"><time datetime="{date_iso}">{date_formatted}</time></p>
    <p class="excerpt">{excerpt}</p>
</article>'''

# Navigation translations
NAV_TRANSLATIONS = {
    "en": {"news": "News", "alpine": "Alpine", "biathlon": "Biathlon", "athletes": "Athletes", "app": "Get App"},
    "de": {"news": "Nachrichten", "alpine": "Ski Alpin", "biathlon": "Biathlon", "athletes": "Athleten", "app": "App laden"},
    "fr": {"news": "Actualités", "alpine": "Ski Alpin", "biathlon": "Biathlon", "athletes": "Athlètes", "app": "Télécharger"},
    "it": {"news": "Notizie", "alpine": "Sci Alpino", "biathlon": "Biathlon", "athletes": "Atleti", "app": "Scarica App"},
    "es": {"news": "Noticias", "alpine": "Esquí Alpino", "biathlon": "Biatlón", "athletes": "Atletas", "app": "Descargar"},
    "pt": {"news": "Notícias", "alpine": "Esqui Alpino", "biathlon": "Biatlo", "athletes": "Atletas", "app": "Baixar"},
    "nl": {"news": "Nieuws", "alpine": "Alpineskiën", "biathlon": "Biathlon", "athletes": "Atleten", "app": "Download"},
    "ar": {"news": "أخبار", "alpine": "تزلج جبال الألب", "biathlon": "البياثلون", "athletes": "الرياضيين", "app": "تحميل"},
    "ja": {"news": "ニュース", "alpine": "アルペン", "biathlon": "バイアスロン", "athletes": "選手", "app": "アプリ"},
    "zh": {"news": "新闻", "alpine": "高山滑雪", "biathlon": "冬季两项", "athletes": "运动员", "app": "下载"},
    "ko": {"news": "뉴스", "alpine": "알파인", "biathlon": "바이애슬론", "athletes": "선수", "app": "앱 다운로드"},
}

# Category labels in each language (used for article card tags)
# Maps to CATEGORY_CONFIG labels - using singular form for tags
CATEGORY_LABELS = {
    "athlete-profile": {
        "en": "Athlete", "de": "Athlet", "fr": "Athlète", "it": "Atleta",
        "es": "Atleta", "pt": "Atleta", "nl": "Atleet", "ar": "رياضي",
        "ja": "選手", "zh": "运动员", "ko": "선수"
    },
    "venue-guide": {
        "en": "Venue", "de": "Austragungsort", "fr": "Site", "it": "Sede",
        "es": "Sede", "pt": "Local", "nl": "Locatie", "ar": "مكان",
        "ja": "会場", "zh": "场地", "ko": "경기장"
    },
    "sport-explainer": {
        "en": "Guide", "de": "Ratgeber", "fr": "Guide", "it": "Guida",
        "es": "Guía", "pt": "Guia", "nl": "Gids", "ar": "دليل",
        "ja": "ガイド", "zh": "指南", "ko": "가이드"
    },
    "historical": {
        "en": "History", "de": "Geschichte", "fr": "Histoire", "it": "Storia",
        "es": "Historia", "pt": "História", "nl": "Geschiedenis", "ar": "تاريخ",
        "ja": "歴史", "zh": "历史", "ko": "역사"
    },
    "news": {
        "en": "News", "de": "Nachrichten", "fr": "Actualités", "it": "Notizie",
        "es": "Noticias", "pt": "Notícias", "nl": "Nieuws", "ar": "أخبار",
        "ja": "ニュース", "zh": "新闻", "ko": "뉴스"
    },
    "biathlon": {
        "en": "Biathlon", "de": "Biathlon", "fr": "Biathlon", "it": "Biathlon",
        "es": "Biatlón", "pt": "Biatlo", "nl": "Biathlon", "ar": "البياثلون",
        "ja": "バイアスロン", "zh": "冬季两项", "ko": "바이애슬론"
    },
    "alpine-skiing": {
        "en": "Alpine", "de": "Alpin", "fr": "Alpin", "it": "Alpino",
        "es": "Alpino", "pt": "Alpino", "nl": "Alpineskiën", "ar": "التزلج الألبي",
        "ja": "アルペン", "zh": "高山", "ko": "알파인"
    },
    "cross-country": {
        "en": "Cross-Country", "de": "Langlauf", "fr": "Fond", "it": "Fondo",
        "es": "Fondo", "pt": "Cross-Country", "nl": "Langlaufen", "ar": "التزلج الريفي",
        "ja": "クロカン", "zh": "越野", "ko": "크로스컨트리"
    },
    "ski-jumping": {
        "en": "Ski Jumping", "de": "Skispringen", "fr": "Saut", "it": "Salto",
        "es": "Salto", "pt": "Salto", "nl": "Schansspringen", "ar": "قفز التزلج",
        "ja": "ジャンプ", "zh": "跳台", "ko": "스키점프"
    },
    "nordic-combined": {
        "en": "Nordic Combined", "de": "Komb.", "fr": "Combiné", "it": "Combinata",
        "es": "Combinada", "pt": "Combinado", "nl": "Combinatie", "ar": "الجمع الشمالي",
        "ja": "複合", "zh": "两项", "ko": "복합"
    },
    "freestyle": {
        "en": "Freestyle", "de": "Freestyle", "fr": "Freestyle", "it": "Freestyle",
        "es": "Freestyle", "pt": "Freestyle", "nl": "Freestyle", "ar": "فريستايل",
        "ja": "フリー", "zh": "自由式", "ko": "프리스타일"
    },
    "snowboard": {
        "en": "Snowboard", "de": "Snowboard", "fr": "Snowboard", "it": "Snowboard",
        "es": "Snowboard", "pt": "Snowboard", "nl": "Snowboard", "ar": "تزلج الجليد",
        "ja": "スノボ", "zh": "单板", "ko": "스노보드"
    },
}

# Maps article categories to filter groups for sport pages
FILTER_CATEGORY_MAP = {
    "biathlon": "sport",
    "alpine-skiing": "sport",
    "cross-country": "sport",
    "ski-jumping": "sport",
    "nordic-combined": "sport",
    "freestyle": "sport",
    "snowboard": "sport",
    "news": "sport",
    "historical": "history",
    "venue-guide": "venue",
    "sport-explainer": "guide",
    "athlete-profile": "athlete",
}

# Filter labels for sport page filters
FILTER_LABELS = {
    "all": {
        "en": "All", "de": "Alle", "fr": "Tout", "it": "Tutto",
        "es": "Todo", "pt": "Tudo", "nl": "Alles", "ar": "الكل",
        "ja": "すべて", "zh": "全部", "ko": "전체"
    },
    "biathlon": {
        "en": "Biathlon", "de": "Biathlon", "fr": "Biathlon", "it": "Biathlon",
        "es": "Biatlón", "pt": "Biatlo", "nl": "Biathlon", "ar": "البياثلون",
        "ja": "バイアスロン", "zh": "冬季两项", "ko": "바이애슬론"
    },
    "alpine": {
        "en": "Alpine", "de": "Alpin", "fr": "Alpin", "it": "Alpino",
        "es": "Alpino", "pt": "Alpino", "nl": "Alpin", "ar": "الألبي",
        "ja": "アルペン", "zh": "高山", "ko": "알파인"
    },
    "history": {
        "en": "History", "de": "Geschichte", "fr": "Histoire", "it": "Storia",
        "es": "Historia", "pt": "História", "nl": "Geschiedenis", "ar": "تاريخ",
        "ja": "歴史", "zh": "历史", "ko": "역사"
    },
    "venue": {
        "en": "Venues", "de": "Orte", "fr": "Sites", "it": "Sedi",
        "es": "Sedes", "pt": "Locais", "nl": "Locaties", "ar": "الأماكن",
        "ja": "会場", "zh": "场地", "ko": "경기장"
    },
    "guide": {
        "en": "Guides", "de": "Ratgeber", "fr": "Guides", "it": "Guide",
        "es": "Guías", "pt": "Guias", "nl": "Gidsen", "ar": "أدلة",
        "ja": "ガイド", "zh": "指南", "ko": "가이드"
    },
}


class IndexGenerateResponse(BaseModel):
    """Response from index page generation."""
    success: bool
    pages_generated: int
    pages: list[str]


@router.post("/generate-index-pages", response_model=IndexGenerateResponse)
async def generate_index_pages(
    session: AsyncSession = Depends(get_db),
):
    """
    Generate index pages (homepage and category pages) for all languages.

    Generates:
    - Homepage (/) with all recent articles
    - /athletes/ with athlete profiles
    - /alpine-skiing/ with alpine skiing content
    - /biathlon/ with biathlon content
    """
    from sqlalchemy import select, or_, func
    from src.db.models import Article

    # Get all published articles
    query = select(Article).where(Article.status == "published").order_by(Article.published_at.desc())
    result = await session.execute(query)
    all_articles = result.scalars().all()

    if not all_articles:
        raise HTTPException(status_code=404, detail="No published articles found")

    # Categorize articles
    # See docs/ARCHITECTURE.md for filtering rules
    athlete_articles = [a for a in all_articles if a.category == "athlete-profile"]
    venue_articles = [a for a in all_articles if a.category == "venue-guide"]
    history_articles = [a for a in all_articles if a.category == "historical"]
    guide_articles = [a for a in all_articles if a.category == "sport-explainer"]
    news_articles = [a for a in all_articles if a.category == "news"]

    # Homepage news: excludes athletes and history, focuses on news/sport content
    homepage_news = [a for a in all_articles
                     if a.category not in ("athlete-profile", "historical")]

    # Sport pages EXCLUDE athlete profiles (critical rule!)
    alpine_articles = [a for a in all_articles
                       if a.category != "athlete-profile"
                       and (a.sport_code in ("AS", "ALP") or a.category == "alpine-skiing")]
    biathlon_articles = [a for a in all_articles
                         if a.category != "athlete-profile"
                         and (a.sport_code in ("BT", "BIA", "BTH") or a.category == "biathlon")]
    cross_country_articles = [a for a in all_articles
                              if a.category != "athlete-profile"
                              and (a.sport_code == "CC" or a.category == "cross-country")]
    ski_jumping_articles = [a for a in all_articles
                            if a.category != "athlete-profile"
                            and (a.sport_code == "SJ" or a.category == "ski-jumping")]
    nordic_combined_articles = [a for a in all_articles
                                if a.category != "athlete-profile"
                                and (a.sport_code == "NC" or a.category == "nordic-combined")]
    freestyle_articles = [a for a in all_articles
                          if a.category != "athlete-profile"
                          and (a.sport_code == "FS" or a.category == "freestyle")]
    snowboard_articles = [a for a in all_articles
                          if a.category != "athlete-profile"
                          and (a.sport_code == "SB" or a.category == "snowboard")]

    # Base path
    base_path = Path(os.environ.get("HTML_OUTPUT_PATH", "/var/www/bronze.news"))
    pages_path = base_path / "_pages"
    generated_pages = []

    # Page configurations - all category pages
    page_configs = [
        {
            "slug": "",
            "articles": homepage_news[:30],  # Latest 30 news (excludes athletes and history)
            "heading": {"en": "Winter Sports News", "de": "Wintersport-Nachrichten", "fr": "Actualités Sports d'Hiver",
                       "it": "Notizie Sport Invernali", "es": "Noticias Deportes de Invierno",
                       "pt": "Notícias Esportes de Inverno", "nl": "Wintersport Nieuws",
                       "ar": "أخبار الرياضات الشتوية", "ja": "ウィンタースポーツニュース",
                       "zh": "冬季运动新闻", "ko": "동계 스포츠 뉴스"},
            "meta": {"en": "Latest winter sports news - FIS World Cup, Biathlon race coverage and analysis."},
            "nav_current": "home",
            "has_headline": True  # Show first article as headline
        },
        {
            "slug": "athletes/",
            "articles": athlete_articles,
            "heading": CATEGORY_CONFIG["athlete-profile"]["labels"],
            "meta": {"en": "Winter sports athlete profiles - Alpine skiing, biathlon, cross-country stars."},
            "nav_current": "athletes"
        },
        {
            "slug": "venues/",
            "articles": venue_articles,
            "heading": CATEGORY_CONFIG["venue-guide"]["labels"],
            "meta": {"en": "Winter sports venues - Kitzbühel, Anterselva, Holmenkollen and more."},
            "nav_current": ""
        },
        {
            "slug": "history/",
            "articles": history_articles,
            "heading": CATEGORY_CONFIG["historical"]["labels"],
            "meta": {"en": "Winter sports history - The stories behind the greatest moments."},
            "nav_current": ""
        },
        {
            "slug": "guides/",
            "articles": guide_articles,
            "heading": CATEGORY_CONFIG["sport-explainer"]["labels"],
            "meta": {"en": "Sport guides - How alpine skiing, biathlon, and more sports work."},
            "nav_current": ""
        },
        {
            "slug": "news/",
            "articles": news_articles,
            "heading": CATEGORY_CONFIG["news"]["labels"],
            "meta": {"en": "Latest winter sports news and updates."},
            "nav_current": ""
        },
        {
            "slug": "alpine-skiing/",
            "articles": alpine_articles,
            "heading": CATEGORY_CONFIG["alpine-skiing"]["labels"],
            "meta": {"en": "Alpine skiing news - FIS World Cup coverage, slalom, giant slalom, downhill."},
            "nav_current": "alpine",
            "filters": ["all", "alpine", "history", "venue", "guide"]
        },
        {
            "slug": "biathlon/",
            "articles": biathlon_articles,
            "heading": CATEGORY_CONFIG["biathlon"]["labels"],
            "meta": {"en": "Biathlon news - IBU World Cup coverage, race analysis."},
            "nav_current": "biathlon",
            "filters": ["all", "biathlon", "history", "venue", "guide"]
        },
        {
            "slug": "cross-country/",
            "articles": cross_country_articles,
            "heading": CATEGORY_CONFIG["cross-country"]["labels"],
            "meta": {"en": "Cross-country skiing news - FIS World Cup, Tour de Ski coverage."},
            "nav_current": ""
        },
        {
            "slug": "ski-jumping/",
            "articles": ski_jumping_articles,
            "heading": CATEGORY_CONFIG["ski-jumping"]["labels"],
            "meta": {"en": "Ski jumping news - Four Hills Tournament, World Cup coverage."},
            "nav_current": ""
        },
        {
            "slug": "nordic-combined/",
            "articles": nordic_combined_articles,
            "heading": CATEGORY_CONFIG["nordic-combined"]["labels"],
            "meta": {"en": "Nordic combined news - FIS World Cup coverage."},
            "nav_current": ""
        },
        {
            "slug": "freestyle/",
            "articles": freestyle_articles,
            "heading": CATEGORY_CONFIG["freestyle"]["labels"],
            "meta": {"en": "Freestyle skiing news - moguls, aerials, halfpipe coverage."},
            "nav_current": ""
        },
        {
            "slug": "snowboard/",
            "articles": snowboard_articles,
            "heading": CATEGORY_CONFIG["snowboard"]["labels"],
            "meta": {"en": "Snowboard news - halfpipe, slopestyle, cross coverage."},
            "nav_current": ""
        },
    ]

    for page_config in page_configs:
        for lang_config in LANGUAGES:
            lang = lang_config["code"]
            lang_path = lang_config["path"]
            lang_dir = lang_config["dir"]

            nav = NAV_TRANSLATIONS.get(lang, NAV_TRANSLATIONS["en"])

            # Build headline for first article if has_headline is True
            headline_html = ""
            has_headline = page_config.get("has_headline", False)
            articles_to_process = page_config["articles"]

            if has_headline and articles_to_process:
                first_article = articles_to_process[0]
                title = (first_article.title or {}).get(lang) or (first_article.title or {}).get("en", "Untitled")
                excerpt = (first_article.excerpt or {}).get(lang) or (first_article.excerpt or {}).get("en", "")
                if len(excerpt) > 250:
                    excerpt = excerpt[:247] + "..."

                cat_labels = CATEGORY_LABELS.get(first_article.category, CATEGORY_LABELS.get("sport-explainer", {}))
                cat_label = cat_labels.get(lang, cat_labels.get("en", first_article.category or "Article"))

                article_category = first_article.category or "news"
                article_cat_config = CATEGORY_CONFIG.get(article_category, DEFAULT_CATEGORY)
                article_category_path = article_cat_config["path"]

                pub_date = first_article.published_at or datetime.utcnow()

                headline_html = HEADLINE_CARD_TEMPLATE.format(
                    category_label=cat_label,
                    lang_path=lang_path,
                    category_path=article_category_path,
                    slug=first_article.slug,
                    title=title,
                    date_iso=pub_date.strftime("%Y-%m-%d"),
                    date_formatted=pub_date.strftime("%b %d, %Y"),
                    excerpt=excerpt
                )
                # Skip first article in the grid (already shown as headline)
                articles_to_process = articles_to_process[1:]

            # Build filter buttons if page has filters defined
            filters_html = ""
            page_filters = page_config.get("filters", [])
            if page_filters:
                filter_buttons = []
                # Map filter keys to data-filter values (biathlon/alpine → sport)
                filter_key_to_data = {
                    "all": "all",
                    "biathlon": "sport",
                    "alpine": "sport",
                    "history": "history",
                    "venue": "venue",
                    "guide": "guide",
                }
                for i, filter_key in enumerate(page_filters):
                    filter_label = FILTER_LABELS.get(filter_key, {}).get(lang, filter_key.title())
                    data_filter = filter_key_to_data.get(filter_key, filter_key)
                    active_class = " active" if i == 0 else ""  # First filter (All) is active by default
                    filter_buttons.append(
                        f'<button class="filter-btn{active_class}" data-filter="{data_filter}">{filter_label}</button>'
                    )
                filters_html = f'<div class="filters" role="group" aria-label="Filter articles">\n    {"    ".join(filter_buttons)}\n</div>'

            # Build article cards
            articles_html_parts = []
            for article in articles_to_process:
                title = (article.title or {}).get(lang) or (article.title or {}).get("en", "Untitled")
                excerpt = (article.excerpt or {}).get(lang) or (article.excerpt or {}).get("en", "")
                if len(excerpt) > 150:
                    excerpt = excerpt[:147] + "..."

                cat_labels = CATEGORY_LABELS.get(article.category, CATEGORY_LABELS.get("sport-explainer", {}))
                cat_label = cat_labels.get(lang, cat_labels.get("en", article.category or "Article"))

                # Get category path for hierarchical URL
                article_category = article.category or "news"
                article_cat_config = CATEGORY_CONFIG.get(article_category, DEFAULT_CATEGORY)
                article_category_path = article_cat_config["path"]

                # Get filter category for client-side filtering
                filter_category = FILTER_CATEGORY_MAP.get(article_category, "sport")

                pub_date = article.published_at or datetime.utcnow()

                card = ARTICLE_CARD_TEMPLATE.format(
                    category_label=cat_label,
                    lang_path=lang_path,
                    category_path=article_category_path,
                    slug=article.slug,
                    title=title,
                    date_iso=pub_date.strftime("%Y-%m-%d"),
                    date_formatted=pub_date.strftime("%b %d, %Y"),
                    excerpt=excerpt,
                    filter_category=filter_category
                )
                articles_html_parts.append(card)

            articles_html = "\n".join(articles_html_parts)

            # Nav current states
            nav_current = page_config["nav_current"]

            # Generate page HTML (Jinja2 templates or legacy inline template)
            page_title = page_config["heading"].get(lang) or page_config["heading"].get("en", "Bronze")
            meta_desc = page_config["meta"].get(lang) or page_config["meta"].get("en", "")

            if USE_JINJA_TEMPLATES:
                # Use version-controlled Jinja2 templates
                # Pass original articles, not articles_to_process (which gets sliced for legacy template)
                html = render_index_jinja(
                    page_config=page_config,
                    articles=page_config["articles"],  # Original articles - Jinja2 handles headline splitting
                    lang=lang,
                    lang_config=lang_config,
                    ui_strings=load_i18n(lang),
                    languages=LANGUAGES,
                    category_config=CATEGORY_CONFIG,
                )
            else:
                # Legacy: inline INDEX_TEMPLATE (to be removed after migration)
                html = INDEX_TEMPLATE.format(
                    lang=lang,
                    dir=lang_dir,
                    page_title=page_title,
                    meta_description=meta_desc,
                    lang_path=lang_path,
                    page_slug=page_config["slug"],
                    heading=page_title,
                    nav_news=nav["news"],
                    nav_alpine=nav["alpine"],
                    nav_biathlon=nav["biathlon"],
                    nav_athletes=nav["athletes"],
                    nav_app=nav["app"],
                    nav_home_current=' aria-current="page"' if nav_current == "home" else "",
                    nav_alpine_current=' aria-current="page"' if nav_current == "alpine" else "",
                    nav_biathlon_current=' aria-current="page"' if nav_current == "biathlon" else "",
                    nav_athletes_current=' aria-current="page"' if nav_current == "athletes" else "",
                    filters_html=filters_html,
                    headline_html=headline_html,
                    articles_html=articles_html
                )

            # Determine output path
            if page_config["slug"]:
                output_path = pages_path / lang_path / page_config["slug"] / "index.html"
            else:
                # Homepage
                output_path = pages_path / lang_path / "index.html" if lang_path else pages_path / "index.html"

            # Validate index page before writing (WCAG compliance check)
            # Only validate English version to avoid redundant checks
            if lang == "en":
                page_type = "homepage" if not page_config["slug"] else "category"
                validation_result = validate_index_page(html, page_type)

                if not validation_result.passed:
                    log.error(
                        "Index page validation FAILED",
                        page=page_config["slug"] or "homepage",
                        errors=validation_result.errors,
                    )
                    # For index pages, log but continue - don't block all pages
                    # Individual errors are less critical than article legal issues

                if validation_result.warnings:
                    log.warning(
                        "Index page validation warnings",
                        page=page_config["slug"] or "homepage",
                        warnings=validation_result.warnings,
                    )

            # Write file
            try:
                output_path.parent.mkdir(parents=True, exist_ok=True)
                output_path.write_text(html, encoding="utf-8")
                generated_pages.append(str(output_path.relative_to(pages_path)))
                log.info("Index page generated", path=str(output_path), lang=lang)
            except Exception as e:
                log.error("Failed to write index page", path=str(output_path), error=str(e))

    log.info("Index generation complete", pages=len(generated_pages))

    return IndexGenerateResponse(
        success=True,
        pages_generated=len(generated_pages),
        pages=generated_pages
    )
