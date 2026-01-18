/**
 * Article types for the News feature
 * Matches the API response format from api.neve26.com
 */

import type { SportCode } from './event';

export type ArticleCategory =
  | 'alpine-skiing'
  | 'biathlon'
  | 'bobsleigh'
  | 'cross-country'
  | 'curling'
  | 'figure-skating'
  | 'freestyle-skiing'
  | 'ice-hockey'
  | 'luge'
  | 'nordic-combined'
  | 'short-track'
  | 'skeleton'
  | 'ski-jumping'
  | 'ski-mountaineering'
  | 'snowboard'
  | 'speed-skating'
  | 'athletes'
  | 'general';

// Map from sport code to article category
export const SPORT_CODE_TO_CATEGORY: Record<SportCode, ArticleCategory> = {
  ALP: 'alpine-skiing',
  BTH: 'biathlon',
  BOB: 'bobsleigh',
  CCS: 'cross-country',
  CER: 'general',
  CUR: 'curling',
  FSK: 'figure-skating',
  FRS: 'freestyle-skiing',
  IHO: 'ice-hockey',
  LUG: 'luge',
  NCB: 'nordic-combined',
  SKN: 'skeleton',
  STK: 'short-track',
  SJP: 'ski-jumping',
  SMT: 'ski-mountaineering',
  SBD: 'snowboard',
  SSK: 'speed-skating',
};

// Map from article category to sport code
export const CATEGORY_TO_SPORT_CODE: Partial<Record<ArticleCategory, SportCode>> = {
  'alpine-skiing': 'ALP',
  'biathlon': 'BTH',
  'bobsleigh': 'BOB',
  'cross-country': 'CCS',
  'curling': 'CUR',
  'figure-skating': 'FSK',
  'freestyle-skiing': 'FRS',
  'ice-hockey': 'IHO',
  'luge': 'LUG',
  'nordic-combined': 'NCB',
  'short-track': 'STK',
  'skeleton': 'SKN',
  'ski-jumping': 'SJP',
  'ski-mountaineering': 'SMT',
  'snowboard': 'SBD',
  'speed-skating': 'SSK',
};

export interface Article {
  slug: string;
  title: string;
  excerpt: string;
  content: string;
  category: ArticleCategory;
  sport_code: SportCode | null;
  athlete_slugs: string[];
  published_at: string;
  image_url: string | null;
  reading_time_minutes: number;
}

export interface ArticleListResponse {
  articles: Article[];
  total: number;
  page: number;
  limit: number;
}

export interface ArticleFilters {
  lang?: string;
  category?: ArticleCategory;
  sport_code?: SportCode;
  country?: string;
  limit?: number;
  offset?: number;
}
