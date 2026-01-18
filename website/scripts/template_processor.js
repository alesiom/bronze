/**
 * Neve26 Template Processor
 *
 * This script processes the article template with content and locale data
 * to generate complete HTML files for all 11 languages.
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
    "nav_alpine": "Alpine Skiing",
    "nav_biathlon": "Biathlon",
    "nav_athletes": "Athletes",
    "nav_app": "Get the App",
    "nav_label": "Main navigation",
    "skip_link": "Skip to content",
    "select_lang": "Select language",
    "reading_time_template": "{{minutes}} min read",
    "app_banner_title": "Never Miss a Race",
    "app_banner_text": "Get notifications for schedule changes and save your favorites.",
    "app_banner_cta": "Download the App",
    "footer_app": "Get the App",
    "footer_privacy": "Privacy",
    "footer_support": "Support",
    "footer_disclaimer": "Independent winter sports coverage.",
    "date_format": "MMMM D, YYYY"
  },
  "de": {
    "lang_code": "de",
    "lang_name": "Deutsch",
    "dir": "ltr",
    "lang_path": "de/",
    "nav_news": "Nachrichten",
    "nav_alpine": "Ski Alpin",
    "nav_biathlon": "Biathlon",
    "nav_athletes": "Athleten",
    "nav_app": "App herunterladen",
    "nav_label": "Hauptnavigation",
    "skip_link": "Zum Inhalt springen",
    "select_lang": "Sprache wählen",
    "reading_time_template": "{{minutes}} Min. Lesezeit",
    "app_banner_title": "Verpasse kein Rennen",
    "app_banner_text": "Erhalte Benachrichtigungen bei Programmänderungen und speichere deine Favoriten.",
    "app_banner_cta": "App herunterladen",
    "footer_app": "App herunterladen",
    "footer_privacy": "Datenschutz",
    "footer_support": "Support",
    "footer_disclaimer": "Unabhängige Wintersport-Berichterstattung.",
    "date_format": "D. MMMM YYYY"
  },
  "fr": {
    "lang_code": "fr",
    "lang_name": "Français",
    "dir": "ltr",
    "lang_path": "fr/",
    "nav_news": "Actualités",
    "nav_alpine": "Ski Alpin",
    "nav_biathlon": "Biathlon",
    "nav_athletes": "Athlètes",
    "nav_app": "Télécharger l'app",
    "nav_label": "Navigation principale",
    "skip_link": "Aller au contenu",
    "select_lang": "Choisir la langue",
    "reading_time_template": "{{minutes}} min de lecture",
    "app_banner_title": "Ne ratez aucune course",
    "app_banner_text": "Recevez des notifications pour les changements d'horaire et sauvegardez vos favoris.",
    "app_banner_cta": "Télécharger l'app",
    "footer_app": "Télécharger l'app",
    "footer_privacy": "Confidentialité",
    "footer_support": "Assistance",
    "footer_disclaimer": "Couverture indépendante des sports d'hiver.",
    "date_format": "D MMMM YYYY"
  },
  "it": {
    "lang_code": "it",
    "lang_name": "Italiano",
    "dir": "ltr",
    "lang_path": "it/",
    "nav_news": "Notizie",
    "nav_alpine": "Sci Alpino",
    "nav_biathlon": "Biathlon",
    "nav_athletes": "Atleti",
    "nav_app": "Scarica l'app",
    "nav_label": "Navigazione principale",
    "skip_link": "Vai al contenuto",
    "select_lang": "Seleziona lingua",
    "reading_time_template": "{{minutes}} min di lettura",
    "app_banner_title": "Non perdere nessuna gara",
    "app_banner_text": "Ricevi notifiche per i cambiamenti di programma e salva i tuoi preferiti.",
    "app_banner_cta": "Scarica l'app",
    "footer_app": "Scarica l'app",
    "footer_privacy": "Privacy",
    "footer_support": "Supporto",
    "footer_disclaimer": "Copertura indipendente degli sport invernali.",
    "date_format": "D MMMM YYYY"
  },
  "es": {
    "lang_code": "es",
    "lang_name": "Español",
    "dir": "ltr",
    "lang_path": "es/",
    "nav_news": "Noticias",
    "nav_alpine": "Esquí Alpino",
    "nav_biathlon": "Biatlón",
    "nav_athletes": "Atletas",
    "nav_app": "Descargar app",
    "nav_label": "Navegación principal",
    "skip_link": "Ir al contenido",
    "select_lang": "Seleccionar idioma",
    "reading_time_template": "{{minutes}} min de lectura",
    "app_banner_title": "No te pierdas ninguna carrera",
    "app_banner_text": "Recibe notificaciones de cambios de horario y guarda tus favoritos.",
    "app_banner_cta": "Descargar app",
    "footer_app": "Descargar app",
    "footer_privacy": "Privacidad",
    "footer_support": "Soporte",
    "footer_disclaimer": "Cobertura independiente de deportes de invierno.",
    "date_format": "D [de] MMMM [de] YYYY"
  },
  "pt": {
    "lang_code": "pt",
    "lang_name": "Português",
    "dir": "ltr",
    "lang_path": "pt/",
    "nav_news": "Notícias",
    "nav_alpine": "Esqui Alpino",
    "nav_biathlon": "Biatlo",
    "nav_athletes": "Atletas",
    "nav_app": "Baixar app",
    "nav_label": "Navegação principal",
    "skip_link": "Ir para o conteúdo",
    "select_lang": "Selecionar idioma",
    "reading_time_template": "{{minutes}} min de leitura",
    "app_banner_title": "Não perca nenhuma corrida",
    "app_banner_text": "Receba notificações de mudanças de horário e salve seus favoritos.",
    "app_banner_cta": "Baixar app",
    "footer_app": "Baixar app",
    "footer_privacy": "Privacidade",
    "footer_support": "Suporte",
    "footer_disclaimer": "Cobertura independente de esportes de inverno.",
    "date_format": "D [de] MMMM [de] YYYY"
  },
  "nl": {
    "lang_code": "nl",
    "lang_name": "Nederlands",
    "dir": "ltr",
    "lang_path": "nl/",
    "nav_news": "Nieuws",
    "nav_alpine": "Alpineskiën",
    "nav_biathlon": "Biatlon",
    "nav_athletes": "Atleten",
    "nav_app": "Download de app",
    "nav_label": "Hoofdnavigatie",
    "skip_link": "Ga naar inhoud",
    "select_lang": "Kies taal",
    "reading_time_template": "{{minutes}} min leestijd",
    "app_banner_title": "Mis geen wedstrijd",
    "app_banner_text": "Ontvang meldingen bij wijzigingen en bewaar je favorieten.",
    "app_banner_cta": "Download de app",
    "footer_app": "Download de app",
    "footer_privacy": "Privacy",
    "footer_support": "Ondersteuning",
    "footer_disclaimer": "Onafhankelijke wintersportverslaggeving.",
    "date_format": "D MMMM YYYY"
  },
  "ar": {
    "lang_code": "ar",
    "lang_name": "العربية",
    "dir": "rtl",
    "lang_path": "ar/",
    "nav_news": "الأخبار",
    "nav_alpine": "التزلج الألبي",
    "nav_biathlon": "البياتلون",
    "nav_athletes": "الرياضيون",
    "nav_app": "حمّل التطبيق",
    "nav_label": "التنقل الرئيسي",
    "skip_link": "انتقل إلى المحتوى",
    "select_lang": "اختر اللغة",
    "reading_time_template": "{{minutes}} دقائق للقراءة",
    "app_banner_title": "لا تفوّت أي سباق",
    "app_banner_text": "احصل على إشعارات بتغييرات الجدول واحفظ مفضلاتك.",
    "app_banner_cta": "حمّل التطبيق",
    "footer_app": "حمّل التطبيق",
    "footer_privacy": "الخصوصية",
    "footer_support": "الدعم",
    "footer_disclaimer": "تغطية مستقلة للرياضات الشتوية.",
    "date_format": "D MMMM YYYY"
  },
  "ja": {
    "lang_code": "ja",
    "lang_name": "日本語",
    "dir": "ltr",
    "lang_path": "ja/",
    "nav_news": "ニュース",
    "nav_alpine": "アルペンスキー",
    "nav_biathlon": "バイアスロン",
    "nav_athletes": "選手",
    "nav_app": "アプリを入手",
    "nav_label": "メインナビゲーション",
    "skip_link": "コンテンツへスキップ",
    "select_lang": "言語を選択",
    "reading_time_template": "{{minutes}}分で読めます",
    "app_banner_title": "レースを見逃さない",
    "app_banner_text": "スケジュール変更の通知を受け取り、お気に入りを保存できます。",
    "app_banner_cta": "アプリをダウンロード",
    "footer_app": "アプリを入手",
    "footer_privacy": "プライバシー",
    "footer_support": "サポート",
    "footer_disclaimer": "独立したウィンタースポーツ報道。",
    "date_format": "YYYY年M月D日"
  },
  "zh": {
    "lang_code": "zh",
    "lang_name": "中文",
    "dir": "ltr",
    "lang_path": "zh/",
    "nav_news": "新闻",
    "nav_alpine": "高山滑雪",
    "nav_biathlon": "冬季两项",
    "nav_athletes": "运动员",
    "nav_app": "获取应用",
    "nav_label": "主导航",
    "skip_link": "跳转到内容",
    "select_lang": "选择语言",
    "reading_time_template": "{{minutes}}分钟阅读",
    "app_banner_title": "不错过任何比赛",
    "app_banner_text": "获取赛程变更通知，保存您的收藏。",
    "app_banner_cta": "下载应用",
    "footer_app": "获取应用",
    "footer_privacy": "隐私政策",
    "footer_support": "支持",
    "footer_disclaimer": "独立的冬季运动报道。",
    "date_format": "YYYY年M月D日"
  },
  "ko": {
    "lang_code": "ko",
    "lang_name": "한국어",
    "dir": "ltr",
    "lang_path": "ko/",
    "nav_news": "뉴스",
    "nav_alpine": "알파인 스키",
    "nav_biathlon": "바이애슬론",
    "nav_athletes": "선수",
    "nav_app": "앱 다운로드",
    "nav_label": "메인 내비게이션",
    "skip_link": "콘텐츠로 건너뛰기",
    "select_lang": "언어 선택",
    "reading_time_template": "{{minutes}}분 소요",
    "app_banner_title": "경기를 놓치지 마세요",
    "app_banner_text": "일정 변경 알림을 받고 즐겨찾기를 저장하세요.",
    "app_banner_cta": "앱 다운로드",
    "footer_app": "앱 다운로드",
    "footer_privacy": "개인정보처리방침",
    "footer_support": "지원",
    "footer_disclaimer": "독립적인 동계 스포츠 보도.",
    "date_format": "YYYY년 M월 D일"
  }
};

const categoryNames = {
  "en": {
    "alpine-skiing": "Alpine Skiing",
    "biathlon": "Biathlon",
    "cross-country": "Cross-Country",
    "figure-skating": "Figure Skating",
    "ice-hockey": "Ice Hockey",
    "winter-sports": "Winter Sports",
    "ski-jumping": "Ski Jumping",
    "freestyle": "Freestyle",
    "snowboard": "Snowboard"
  },
  "de": {
    "alpine-skiing": "Ski Alpin",
    "biathlon": "Biathlon",
    "cross-country": "Langlauf",
    "figure-skating": "Eiskunstlauf",
    "ice-hockey": "Eishockey",
    "winter-sports": "Wintersport",
    "ski-jumping": "Skispringen",
    "freestyle": "Freestyle",
    "snowboard": "Snowboard"
  },
  "fr": {
    "alpine-skiing": "Ski Alpin",
    "biathlon": "Biathlon",
    "cross-country": "Ski de Fond",
    "figure-skating": "Patinage Artistique",
    "ice-hockey": "Hockey sur Glace",
    "winter-sports": "Sports d'Hiver",
    "ski-jumping": "Saut à Ski",
    "freestyle": "Freestyle",
    "snowboard": "Snowboard"
  },
  "it": {
    "alpine-skiing": "Sci Alpino",
    "biathlon": "Biathlon",
    "cross-country": "Sci di Fondo",
    "figure-skating": "Pattinaggio Artistico",
    "ice-hockey": "Hockey su Ghiaccio",
    "winter-sports": "Sport Invernali",
    "ski-jumping": "Salto con gli Sci",
    "freestyle": "Freestyle",
    "snowboard": "Snowboard"
  }
  // Add other languages as needed
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
      "name": "Neve26",
      "url": "https://neve26.com"
    },
    "publisher": {
      "@type": "Organization",
      "name": "Neve26",
      "logo": {
        "@type": "ImageObject",
        "url": "https://neve26.com/logo-512.png"
      }
    },
    "mainEntityOfPage": {
      "@type": "WebPage",
      "@id": `https://neve26.com/${locale.lang_path}${article.slug}/`
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
    'NAV_ALPINE': locale.nav_alpine,
    'NAV_BIATHLON': locale.nav_biathlon,
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
    title: "Odermatt Wins Adelboden Giant Slalom",
    description: "Marco Odermatt claims his 40th World Cup victory with dominant performance in Switzerland.",
    content: "<h2>Race Summary</h2><p>Marco Odermatt delivered another masterclass...</p>",
    slug: "odermatt-adelboden-giant-slalom-2026",
    category: "alpine-skiing",
    reading_time: 4
  };

  const testTemplate = `<!DOCTYPE html>
<html lang="{{LANG}}" dir="{{DIR}}">
<head><title>{{TITLE}} - Neve26</title></head>
<body>
<h1>{{TITLE}}</h1>
<p>{{CATEGORY_NAME}} | {{READING_TIME}}</p>
{{CONTENT}}
</body>
</html>`;

  const result = processTemplate(testTemplate, testArticle, 'en');
  console.log(result);
}
