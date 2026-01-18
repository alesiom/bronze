/**
 * React hooks for articles
 * Provides data fetching and state management for news articles
 */

import { useState, useEffect, useCallback, useMemo } from 'react';
import type { Article, ArticleFilters, SportCode } from '../types';
import { fetchArticles, fetchArticleBySlug, fetchFeaturedArticle } from '../services/articles';

export interface ArticleFilterState {
  sport: SportCode | null;
  country: string | null;
}

/**
 * Main hook for fetching and filtering articles
 */
export function useArticles(filters?: Partial<ArticleFilterState>) {
  const [articles, setArticles] = useState<Article[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [refreshing, setRefreshing] = useState(false);

  // Build API filters from state
  const apiFilters = useMemo<ArticleFilters>(() => {
    const result: ArticleFilters = {
      limit: 20,
    };

    if (filters?.sport) {
      result.sport_code = filters.sport;
    }
    if (filters?.country) {
      result.country = filters.country;
    }

    return result;
  }, [filters?.sport, filters?.country]);

  // Fetch articles
  const loadArticles = useCallback(async () => {
    try {
      const response = await fetchArticles(apiFilters);

      if (response) {
        setArticles(response.articles);
        setTotal(response.total);
        setError(null);
      } else {
        setError('Failed to load articles');
      }
    } catch (err) {
      setError('Failed to load articles');
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  }, [apiFilters]);

  // Initial load
  useEffect(() => {
    setLoading(true);
    loadArticles();
  }, [loadArticles]);

  // Refresh function (pull-to-refresh)
  const refresh = useCallback(async () => {
    setRefreshing(true);
    await loadArticles();
  }, [loadArticles]);

  // Load more for pagination
  const loadMore = useCallback(async () => {
    if (articles.length >= total) return;

    try {
      const response = await fetchArticles({
        ...apiFilters,
        offset: articles.length,
      });

      if (response) {
        setArticles((prev) => [...prev, ...response.articles]);
      }
    } catch {
      // Silently fail for load more
    }
  }, [apiFilters, articles.length, total]);

  return {
    articles,
    total,
    loading,
    error,
    refreshing,
    refresh,
    loadMore,
    hasMore: articles.length < total,
  };
}

/**
 * Hook for a single article by slug
 */
export function useArticle(slug: string) {
  const [article, setArticle] = useState<Article | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!slug) {
      setLoading(false);
      return;
    }

    setLoading(true);
    setError(null);

    fetchArticleBySlug(slug)
      .then((data) => {
        setArticle(data);
        if (!data) {
          setError('Article not found');
        }
      })
      .catch(() => {
        setError('Failed to load article');
      })
      .finally(() => {
        setLoading(false);
      });
  }, [slug]);

  return { article, loading, error };
}

/**
 * Hook for the featured article
 */
export function useFeaturedArticle() {
  const [article, setArticle] = useState<Article | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const refresh = useCallback(async () => {
    setLoading(true);
    setError(null);

    try {
      const data = await fetchFeaturedArticle();
      setArticle(data);
      if (!data) {
        setError('No featured article');
      }
    } catch {
      setError('Failed to load featured article');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    refresh();
  }, [refresh]);

  return { article, loading, error, refresh };
}

/**
 * Hook to get available sports from articles
 * Returns sports that have at least one article
 */
export function useArticleSports() {
  const [sports, setSports] = useState<SportCode[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchArticles({ limit: 100 })
      .then((response) => {
        if (response) {
          const sportSet = new Set<SportCode>();
          for (const article of response.articles) {
            if (article.sport_code) {
              sportSet.add(article.sport_code);
            }
          }
          setSports(Array.from(sportSet).sort());
        }
      })
      .finally(() => {
        setLoading(false);
      });
  }, []);

  return { sports, loading };
}
