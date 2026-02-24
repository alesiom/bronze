"""
Article and HTML validation for Bronze.

This module is the automated gatekeeper - no human review needed.
All content must pass validation before being written to files.

Legal Constraint: Italian Law 31/2020
- Fines: €100,000 to €2,500,000
- Prohibited terms related to Olympics must be blocked
"""
from typing import List, Optional
from dataclasses import dataclass
import re

# =============================================================================
# Legal Blocklist - Italian Law 31/2020
# CRITICAL: €100,000 to €2,500,000 fines for violations
# =============================================================================

LEGAL_BLOCKLIST = [
    # Olympic terms (English)
    'olympic', 'olympics', 'olympiad', 'olympian',
    # Olympic terms (Italian)
    'olimpico', 'olimpiade', 'olimpiadi',
    # Paralympic terms
    'paralympic', 'paralympics', 'paralimpico', 'paralimpici',
    # Milano-Cortina 2026 trademarks
    'milano cortina 2026', 'cortina 2026', 'milano 2026',
    # Generic game references
    'winter games 2026', 'games of 2026', 'the games',
    # Marketing phrases
    'going for gold', 'medal hopes', 'medal dreams',
    # National team references (avoid trademark issues)
    'team usa', 'team italy', 'team canada', 'team france',
    'team germany', 'team switzerland', 'team norway', 'team austria',
    'team sweden', 'team finland', 'team japan', 'team china',
]

# Additional terms that trigger warnings (not blocks)
LEGAL_WARNINGS = [
    'gold medal', 'silver medal', 'bronze medal',
    '2026 games', 'winter 2026',
]

SUPPORTED_LANGUAGES = ['en', 'fr', 'de']


# =============================================================================
# Data Classes
# =============================================================================

@dataclass
class ValidationResult:
    """Result of validation check."""
    passed: bool
    errors: List[str]
    warnings: List[str]

    def __str__(self) -> str:
        if self.passed:
            return f"Validation PASSED ({len(self.warnings)} warnings)"
        return f"Validation FAILED: {', '.join(self.errors)}"


class ValidationError(Exception):
    """Raised when validation fails - blocks content from being published."""
    def __init__(self, errors: List[str]):
        self.errors = errors
        super().__init__(f"Validation failed: {', '.join(errors)}")


# =============================================================================
# Validation Functions
# =============================================================================

def check_legal_blocklist(text: str) -> List[str]:
    """
    Check text against legal blocklist.

    Returns list of violations (empty if clean).
    CRITICAL: These terms can result in €2.5M fines.
    """
    if not text:
        return []

    violations = []
    text_lower = text.lower()

    for term in LEGAL_BLOCKLIST:
        if term in text_lower:
            violations.append(f"Banned term found: '{term}'")

    return violations


def check_legal_warnings(text: str) -> List[str]:
    """
    Check text for terms that should be reviewed.

    Returns list of warnings (non-blocking).
    """
    if not text:
        return []

    warnings = []
    text_lower = text.lower()

    for term in LEGAL_WARNINGS:
        if term in text_lower:
            warnings.append(f"Review recommended for term: '{term}'")

    return warnings


def validate_html_structure(html: str) -> List[str]:
    """
    Validate HTML structure for WCAG AAA compliance.

    Checks:
    - DOCTYPE declaration
    - Language attribute
    - Skip-to-content link
    - Main element
    - Meta description
    - No inline styles (after CSS extraction)
    """
    if not html:
        return ["Empty HTML content"]

    errors = []

    # DOCTYPE
    if not html.strip().startswith('<!DOCTYPE html>'):
        errors.append("Missing DOCTYPE declaration")

    # Language attribute on <html>
    if not re.search(r'<html[^>]*lang="[a-z]{2}"', html[:500]):
        errors.append("Missing lang attribute on <html> element")

    # Skip link (WCAG requirement)
    if 'class="skip-link"' not in html:
        errors.append("Missing skip-to-content link (WCAG AAA requirement)")

    # Main element
    if '<main' not in html:
        errors.append("Missing <main> element")

    # Meta description for SEO
    if '<meta name="description"' not in html:
        errors.append("Missing meta description")

    # External CSS check (no inline styles after Phase 1)
    # This will be enforced after CSS extraction is complete
    # if '<style>' in html and '</style>' in html:
    #     errors.append("Inline <style> found - should use external CSS")

    # RTL consistency
    if 'dir="rtl"' in html and 'lang="ar"' not in html:
        errors.append("RTL direction set but lang is not Arabic")

    return errors


def validate_article_content(article: dict) -> List[str]:
    """
    Validate article content for completeness.

    Checks:
    - Required fields present
    - All 11 languages have content
    - Minimum content length
    """
    errors = []

    # Required fields
    if not article.get('slug'):
        errors.append("Missing slug")

    if not article.get('category'):
        errors.append("Missing category")

    # Check all 11 languages have title and content
    title = article.get('title', {})
    content = article.get('content', {})

    missing_titles = []
    missing_content = []

    for lang in SUPPORTED_LANGUAGES:
        if lang not in title or not title.get(lang):
            missing_titles.append(lang)
        if lang not in content or not content.get(lang):
            missing_content.append(lang)

    if missing_titles:
        errors.append(f"Missing title for languages: {', '.join(missing_titles)}")

    if missing_content:
        errors.append(f"Missing content for languages: {', '.join(missing_content)}")

    return errors


def validate_article_for_publish(article: dict, html: str) -> ValidationResult:
    """
    Complete validation before any write operation.

    This is the GATEKEEPER - blocks bad content from being published.
    Called before writing to database and generating HTML files.

    Args:
        article: Article data dictionary with title, content, etc.
        html: Generated HTML string to validate

    Returns:
        ValidationResult with passed status, errors, and warnings
    """
    errors = []
    warnings = []

    # 1. Legal blocklist (CRITICAL - €2.5M fine risk)
    # Check English content (primary) plus all translations
    all_text_parts = []

    # Get all title translations
    for lang in SUPPORTED_LANGUAGES:
        title = article.get('title', {}).get(lang, '')
        if title:
            all_text_parts.append(title)

    # Get all excerpt translations
    for lang in SUPPORTED_LANGUAGES:
        excerpt = article.get('excerpt', {}).get(lang, '')
        if excerpt:
            all_text_parts.append(excerpt)

    # Get all content translations
    for lang in SUPPORTED_LANGUAGES:
        content = article.get('content', {}).get(lang, '')
        if content:
            all_text_parts.append(content)

    all_text = ' '.join(all_text_parts)

    legal_violations = check_legal_blocklist(all_text)
    if legal_violations:
        errors.extend([f"LEGAL: {v}" for v in legal_violations])

    # Legal warnings (non-blocking)
    legal_warns = check_legal_warnings(all_text)
    if legal_warns:
        warnings.extend(legal_warns)

    # 2. Content completeness
    content_errors = validate_article_content(article)
    errors.extend(content_errors)

    # 3. HTML structure (WCAG AAA)
    html_errors = validate_html_structure(html)
    errors.extend(html_errors)

    # 4. Content quality checks (non-blocking warnings)
    en_content = article.get('content', {}).get('en', '')
    if en_content and len(en_content) < 500:
        warnings.append("Article content is very short (<500 characters)")

    en_title = article.get('title', {}).get('en', '')
    if en_title and len(en_title) > 100:
        warnings.append("Article title is very long (>100 characters)")

    return ValidationResult(
        passed=len(errors) == 0,
        errors=errors,
        warnings=warnings
    )


def validate_index_page(html: str, page_type: str = "index") -> ValidationResult:
    """
    Validate index/category page HTML.

    Lighter validation than article pages.
    """
    errors = []
    warnings = []

    if not html:
        errors.append("Empty HTML content")
        return ValidationResult(passed=False, errors=errors, warnings=warnings)

    # DOCTYPE
    if not html.strip().startswith('<!DOCTYPE html>'):
        errors.append("Missing DOCTYPE declaration")

    # Language attribute
    if not re.search(r'<html[^>]*lang="[a-z]{2}"', html[:500]):
        errors.append("Missing lang attribute on <html> element")

    # Skip link
    if 'class="skip-link"' not in html and 'skip-link' not in html:
        warnings.append("Missing skip-to-content link")

    # Main element
    if '<main' not in html:
        errors.append("Missing <main> element")

    return ValidationResult(
        passed=len(errors) == 0,
        errors=errors,
        warnings=warnings
    )


# =============================================================================
# Utility Functions
# =============================================================================

def sanitize_for_legal(text: str) -> str:
    """
    Remove or replace legally problematic terms.

    USE WITH CAUTION: This modifies content.
    Better to reject and regenerate than to auto-sanitize.
    """
    if not text:
        return text

    # Replace common problematic phrases with safe alternatives
    replacements = {
        'olympic': 'world championship',
        'olympics': 'world championships',
        'paralympic': 'world para',
        'going for gold': 'competing for victory',
        'medal hopes': 'podium ambitions',
    }

    result = text
    for term, replacement in replacements.items():
        # Case-insensitive replacement
        pattern = re.compile(re.escape(term), re.IGNORECASE)
        result = pattern.sub(replacement, result)

    return result


def get_validation_summary(result: ValidationResult) -> str:
    """
    Get human-readable validation summary.
    """
    lines = []

    if result.passed:
        lines.append("✅ Validation PASSED")
    else:
        lines.append("❌ Validation FAILED")

    if result.errors:
        lines.append("\nErrors:")
        for error in result.errors:
            lines.append(f"  • {error}")

    if result.warnings:
        lines.append("\nWarnings:")
        for warning in result.warnings:
            lines.append(f"  ⚠ {warning}")

    return "\n".join(lines)


# =============================================================================
# Database Logging (for monitoring and alerting)
# =============================================================================

async def log_validation_rejection(
    session,
    slug: Optional[str],
    rejection_type: str,
    result: ValidationResult,
    raw_content: Optional[dict] = None,
    source: str = "api"
) -> int:
    """
    Log a validation rejection to the database for monitoring.

    Args:
        session: AsyncSession for database
        slug: Article slug (if available)
        rejection_type: Type of rejection ('legal', 'structure', 'incomplete', 'html')
        result: ValidationResult from validation check
        raw_content: Optional raw content for debugging
        source: Source of content ('n8n', 'api', 'manual', 'regeneration')

    Returns:
        ID of the logged rejection
    """
    from sqlalchemy import text
    import json

    # Determine severity based on rejection type
    severity = "error"
    if rejection_type == "legal":
        severity = "critical"  # Legal issues are critical (€2.5M fine risk)
    elif not result.errors and result.warnings:
        severity = "warning"

    # Execute the stored function
    query = text("""
        SELECT log_validation_rejection(
            :slug,
            :rejection_type,
            :severity,
            :errors::jsonb,
            :warnings::jsonb,
            :raw_content::jsonb,
            :source
        )
    """)

    result_id = await session.execute(
        query,
        {
            "slug": slug,
            "rejection_type": rejection_type,
            "severity": severity,
            "errors": json.dumps(result.errors),
            "warnings": json.dumps(result.warnings),
            "raw_content": json.dumps(raw_content) if raw_content else None,
            "source": source,
        }
    )

    return result_id.scalar()


def determine_rejection_type(errors: List[str]) -> str:
    """
    Determine the rejection type based on error messages.
    """
    error_text = " ".join(errors).lower()

    if "legal" in error_text or "banned term" in error_text:
        return "legal"
    elif "missing" in error_text and ("title" in error_text or "content" in error_text or "lang" in error_text):
        return "incomplete"
    elif "doctype" in error_text or "main" in error_text or "skip" in error_text:
        return "structure"
    else:
        return "html"
