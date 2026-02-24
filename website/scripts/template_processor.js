/**
 * Bronze Template Processor
 *
 * This script processes the article template with content and locale data
 * to generate complete HTML files for all 3 languages.
 *
 * Usage in n8n Code node:
 * - Input: article data (title, content, slug, etc.)
 * - Output: array of file objects with path and HTML content
 */

const locales = {
  "en": {
    "lang_code": "en",
    "lang_name": "English",
    "dir": "ltr",
    "lang_path": "",
    "nav_news": "News",
    "nav_athletes": "Athletes",
    "nav_app": "Get the App",
    "nav_label": "Main navigation",
    "skip_link": "Skip to content",
    "select_lang": "Select language",
    "reading_time_template": "{{minutes}} min read",
    "app_banner_title": "Never Miss a Match",
    "app_banner_text": "Get notifications for schedule changes and save your favorites.",
    "app_banner_cta": "Download the App",
    "footer_app": "Get the App",
    "footer_privacy": "Privacy",
    "footer_support": "Support",
    "footer_disclaimer": "Independent sports coverage.",
    "date_format": "MMMM D, YYYY"
  },
  "de": {
    "lang_code": "de",
    "lang_name": "Deutsch",
    "dir": "ltr",
    "lang_path": "de/",
    "nav_news": "Nachrichten",
    "nav_athletes": "Athleten",
    "nav_app": "App herunterladen",
    "nav_label": "Hauptnavigation",
    "skip_link": "Zum Inhalt springen",
    "select_lang": "Sprache wählen",
    "reading_time_template": "{{minutes}} Min. Lesezeit",
    "app_banner_title": "Verpasse kein Spiel",
    "app_banner_text": "Erhalte Benachrichtigungen bei Programmänderungen und speichere deine Favoriten.",
    "app_banner_cta": "App herunterladen",
    "footer_app": "App herunterladen",
    "footer_privacy": "Datenschutz",
    "footer_support": "Support",
    "footer_disclaimer": "Unabhängige Sportberichterstattung.",
    "date_format": "D. MMMM YYYY"
  },
  "fr": {
    "lang_code": "fr",
    "lang_name": "Français",
    "dir": "ltr",
    "lang_path": "fr/",
    "nav_news": "Actualités",
    "nav_athletes": "Athlètes",
    "nav_app": "Télécharger l'app",
    "nav_label": "Navigation principale",
    "skip_link": "Aller au contenu",
    "select_lang": "Choisir la langue",
    "reading_time_template": "{{minutes}} min de lecture",
    "app_banner_title": "Ne ratez aucun match",
    "app_banner_text": "Recevez des notifications pour les changements d'horaire et sauvegardez vos favoris.",
    "app_banner_cta": "Télécharger l'app",
    "footer_app": "Télécharger l'app",
    "footer_privacy": "Confidentialité",
    "footer_support": "Assistance",
    "footer_disclaimer": "Couverture sportive indépendante.",
    "date_format": "D MMMM YYYY"
  }
};

const categoryNames = {
  "en": {
    "news": "News",
    "athlete-profile": "Athlete Profile",
    "sport-explainer": "Sport Explainer",
    "football": "Football",
    "tennis": "Tennis",
    "athletics": "Athletics",
    "cycling": "Cycling",
    "motorsport": "Motorsport",
    "winter-sports": "Winter Sports",
    "swimming": "Swimming",
    "other": "Other Sports"
  },
  "de": {
    "news": "Nachrichten",
    "athlete-profile": "Athletenprofil",
    "sport-explainer": "Sport-Erklärer",
    "football": "Fußball",
    "tennis": "Tennis",
    "athletics": "Leichtathletik",
    "cycling": "Radsport",
    "motorsport": "Motorsport",
    "winter-sports": "Wintersport",
    "swimming": "Schwimmen",
    "other": "Andere Sportarten"
  },
  "fr": {
    "news": "Actualités",
    "athlete-profile": "Profil d'athlète",
    "sport-explainer": "Sport expliqué",
    "football": "Football",
    "tennis": "Tennis",
    "athletics": "Athlétisme",
    "cycling": "Cyclisme",
    "motorsport": "Sport automobile",
    "winter-sports": "Sports d'hiver",
    "swimming": "Natation",
    "other": "Autres sports"
  }
};

/**
 * Generate structured data JSON-LD for article
 */
function generateStructuredData(article, lang, locale) {
  return JSON.stringify({
    "@context": "https://schema.org",
    "@type": "NewsArticle",
    "headline": article.title,
    "description": article.description,
    "datePublished": article.published_iso,
    "dateModified": article.published_iso,
    "author": {
      "@type": "Organization",
      "name": "Bronze",
      "url": "https://bronze.news"
    },
    "publisher": {
      "@type": "Organization",
      "name": "Bronze",
      "logo": {
        "@type": "ImageObject",
        "url": "https://bronze.news/logo-512.png"
      }
    },
    "mainEntityOfPage": {
      "@type": "WebPage",
      "@id": `https://bronze.news/${locale.lang_path}${article.slug}/`
    },
    "inLanguage": lang
  }, null, 2);
}

/**
 * Format date for display based on locale
 */
function formatDate(isoDate, lang) {
  const date = new Date(isoDate);
  const options = { year: 'numeric', month: 'long', day: 'numeric' };
  return date.toLocaleDateString(lang, options);
}

/**
 * Process template with article data and locale
 */
function processTemplate(template, article, lang) {
  const locale = locales[lang];
  const categoryName = (categoryNames[lang] || categoryNames['en'])[article.category] || article.category;

  const now = new Date().toISOString();
  const publishedDate = formatDate(now, lang);
  const readingTime = locale.reading_time_template.replace('{{minutes}}', article.reading_time || '4');

  // Build selected attributes for language dropdown
  const langSelections = {};
  Object.keys(locales).forEach(l => {
    langSelections[`LANG_${l.toUpperCase()}_SELECTED`] = (l === lang) ? 'selected' : '';
  });

  const replacements = {
    // Language & Direction
    'LANG': lang,
    'DIR': locale.dir,
    'LANG_PATH': locale.lang_path,

    // Article content
    'TITLE': article.title,
    'META_DESCRIPTION': article.description,
    'EXCERPT': article.description,
    'SLUG': article.slug,
    'CATEGORY_SLUG': article.category,
    'CATEGORY_NAME': categoryName,
    'CONTENT': article.content,

    // Dates
    'PUBLISHED_ISO': now,
    'PUBLISHED_DATE': publishedDate,
    'READING_TIME': readingTime,

    // Structured data
    'STRUCTURED_DATA': generateStructuredData(article, lang, locale),

    // Navigation
    'NAV_LABEL': locale.nav_label,
    'NAV_NEWS': locale.nav_news,
    'NAV_ATHLETES': locale.nav_athletes,
    'NAV_APP': locale.nav_app,

    // Accessibility
    'SKIP_LINK_TEXT': locale.skip_link,
    'SELECT_LANG': locale.select_lang,

    // App banner
    'APP_BANNER_TITLE': locale.app_banner_title,
    'APP_BANNER_TEXT': locale.app_banner_text,
    'APP_BANNER_CTA': locale.app_banner_cta,

    // Footer
    'FOOTER_APP': locale.footer_app,
    'FOOTER_PRIVACY': locale.footer_privacy,
    'FOOTER_SUPPORT': locale.footer_support,
    'FOOTER_DISCLAIMER': locale.footer_disclaimer,

    // Language selections
    ...langSelections
  };

  let html = template;
  for (const [key, value] of Object.entries(replacements)) {
    html = html.replace(new RegExp(`\\{\\{${key}\\}\\}`, 'g'), value);
  }

  return html;
}

/**
 * Generate all language versions of an article
 *
 * @param {string} template - HTML template content
 * @param {object} englishArticle - Original English article data
 * @param {object} translations - Object with language codes as keys, translated articles as values
 * @returns {array} Array of file objects with path and content
 */
function generateAllVersions(template, englishArticle, translations) {
  const files = [];

  // Generate English version
  files.push({
    lang: 'en',
    path: `${englishArticle.slug}/index.html`,
    content: processTemplate(template, englishArticle, 'en')
  });

  // Generate translated versions
  for (const [lang, translation] of Object.entries(translations)) {
    const article = {
      ...englishArticle,
      title: translation.title,
      description: translation.description,
      content: translation.content
    };

    files.push({
      lang: lang,
      path: `${locales[lang].lang_path}${englishArticle.slug}/index.html`,
      content: processTemplate(template, article, lang)
    });
  }

  return files;
}

// Export for n8n Code node
module.exports = {
  locales,
  categoryNames,
  processTemplate,
  generateAllVersions,
  generateStructuredData,
  formatDate
};

// For testing in Node.js
if (require.main === module) {
  const testArticle = {
    title: "Mbappé Scores Hat-Trick in Champions League Thriller",
    description: "Kylian Mbappé delivers a stunning three-goal performance as his side advance to the quarter-finals.",
    content: "<h2>Match Summary</h2><p>Kylian Mbappé delivered another masterclass...</p>",
    slug: "mbappe-hat-trick-champions-league-2026",
    category: "football",
    reading_time: 4
  };

  const testTemplate = `<!DOCTYPE html>
<html lang="{{LANG}}" dir="{{DIR}}">
<head><title>{{TITLE}} - Bronze</title></head>
<body>
<h1>{{TITLE}}</h1>
<p>{{CATEGORY_NAME}} | {{READING_TIME}}</p>
{{CONTENT}}
</body>
</html>`;

  const result = processTemplate(testTemplate, testArticle, 'en');
  console.log(result);
}
