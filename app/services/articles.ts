/**
 * Articles API service
 * Fetches news articles from api.neve26.com
 */

import type { Article, ArticleListResponse, ArticleFilters } from '../types';
import i18n from '../i18n';

// API configuration
const API_BASE_URL = __DEV__
  ? 'http://localhost:8000/api/v1'  // Local dev
  : 'https://api.neve26.com/api/v1'; // Production

/**
 * Get current language code for API requests
 */
function getCurrentLang(): string {
  const lang = i18n.language || 'en';
  // API expects 2-letter codes
  return lang.split('-')[0];
}

/**
 * Fetch articles list with optional filters
 */
export async function fetchArticles(
  filters?: ArticleFilters
): Promise<ArticleListResponse | null> {
  try {
    const searchParams = new URLSearchParams();

    // Always send current language
    searchParams.append('lang', filters?.lang || getCurrentLang());

    if (filters?.category) {
      searchParams.append('category', filters.category);
    }
    if (filters?.sport_code) {
      searchParams.append('sport_code', filters.sport_code);
    }
    if (filters?.country) {
      searchParams.append('country', filters.country);
    }
    if (filters?.limit) {
      searchParams.append('limit', filters.limit.toString());
    }
    if (filters?.offset) {
      searchParams.append('offset', filters.offset.toString());
    }

    const url = `${API_BASE_URL}/articles?${searchParams}`;

    const response = await fetch(url, {
      headers: {
        'Accept': 'application/json',
      },
    });

    if (!response.ok) {
      console.error('[Articles] Fetch failed:', response.status);
      return null;
    }

    const data: ArticleListResponse = await response.json();
    return data;
  } catch (error) {
    // Network errors are expected when offline
    const isNetworkError = error instanceof TypeError && error.message === 'Network request failed';
    if (!isNetworkError) {
      console.warn('[Articles] Fetch error:', error);
    }
    return null;
  }
}

/**
 * Fetch single article by slug
 */
export async function fetchArticleBySlug(
  slug: string,
  lang?: string
): Promise<Article | null> {
  try {
    const searchParams = new URLSearchParams();
    searchParams.append('lang', lang || getCurrentLang());

    const url = `${API_BASE_URL}/articles/${slug}?${searchParams}`;

    const response = await fetch(url, {
      headers: {
        'Accept': 'application/json',
      },
    });

    if (!response.ok) {
      if (response.status === 404) {
        return null;
      }
      console.error('[Articles] Fetch article failed:', response.status);
      return null;
    }

    const article: Article = await response.json();
    return article;
  } catch (error) {
    const isNetworkError = error instanceof TypeError && error.message === 'Network request failed';
    if (!isNetworkError) {
      console.warn('[Articles] Fetch article error:', error);
    }
    return null;
  }
}

/**
 * Fetch featured article
 */
export async function fetchFeaturedArticle(
  lang?: string
): Promise<Article | null> {
  try {
    const searchParams = new URLSearchParams();
    searchParams.append('lang', lang || getCurrentLang());

    const url = `${API_BASE_URL}/articles/featured?${searchParams}`;

    const response = await fetch(url, {
      headers: {
        'Accept': 'application/json',
      },
    });

    if (!response.ok) {
      console.error('[Articles] Fetch featured failed:', response.status);
      return null;
    }

    const article: Article = await response.json();
    return article;
  } catch (error) {
    const isNetworkError = error instanceof TypeError && error.message === 'Network request failed';
    if (!isNetworkError) {
      console.warn('[Articles] Fetch featured error:', error);
    }
    return null;
  }
}

/**
 * Get all unique sport codes from articles
 * For building the filter UI
 */
export async function fetchArticleSportCodes(): Promise<string[]> {
  try {
    const response = await fetchArticles({ limit: 100 });
    if (!response) return [];

    const sportCodes = new Set<string>();
    for (const article of response.articles) {
      if (article.sport_code) {
        sportCodes.add(article.sport_code);
      }
    }
    return Array.from(sportCodes).sort();
  } catch {
    return [];
  }
}
