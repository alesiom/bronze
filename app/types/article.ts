/**
 * Article types for the News feature
 * Matches the API response format from api.bronze.news
 */

import type { SportCode } from './event';

export type ArticleCategory =
  | 'football'
  | 'tennis'
  | 'athletics'
  | 'cycling'
  | 'motorsport'
  | 'winter-sports'
  | 'swimming'
  | 'other'
  | 'athlete-profile'
  | 'sport-explainer'
  | 'news'
  | 'general';

// Map from sport code to article category (1-to-1 for sport categories)
export const SPORT_CODE_TO_CATEGORY: Record<SportCode, ArticleCategory> = {
  football: 'football',
  tennis: 'tennis',
  athletics: 'athletics',
  cycling: 'cycling',
  motorsport: 'motorsport',
  'winter-sports': 'winter-sports',
  swimming: 'swimming',
  other: 'general',
};

// Map from article category back to sport code (only sport categories)
export const CATEGORY_TO_SPORT_CODE: Partial<Record<ArticleCategory, SportCode>> = {
  football: 'football',
  tennis: 'tennis',
  athletics: 'athletics',
  cycling: 'cycling',
  motorsport: 'motorsport',
  'winter-sports': 'winter-sports',
  swimming: 'swimming',
};

export interface Article {
  id: number;
  slug: string;
  title: string;
  excerpt: string | null;
  content?: string;  // Only in detail response
  category: string;
  sport_code: string | null;
  athlete_slugs?: string[];
  published_at: string;
  featured_image: string | null;
  image_alt: string | null;
  venue: string | null;
  venue_city: string | null;
}

export interface ArticleListResponse {
  articles: Article[];
  total: number;
  limit: number;
  offset: number;
}

export interface ArticleFilters {
  lang?: string;
  category?: ArticleCategory;
  sport_code?: SportCode;
  country?: string;
  limit?: number;
  offset?: number;
}
