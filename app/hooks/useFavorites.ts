/**
 * Centralized favorites management with server sync
 * AsyncStorage is source of truth, syncs to server when online
 * Also manages local notification reminders
 */

import { useState, useEffect, useCallback, useRef } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { api } from '../services/api';
import {
  scheduleEventReminder,
  cancelEventReminder,
  areNotificationsEnabled,
} from '../services/notifications';
import type { Event } from '../types';

const FAVORITES_KEY = '@neve26_favorites';
const FAVORITES_IDS_KEY = '@neve26_favorite_ids';
const PENDING_SYNC_KEY = '@neve26_pending_sync';
const SETTINGS_KEY = '@neve26_settings';

// Translation function placeholder (will be set by component)
let translationFn: ((key: string, options?: Record<string, unknown>) => string) | null = null;

export function setTranslationFunction(t: (key: string, options?: Record<string, unknown>) => string) {
  translationFn = t;
}

export interface FavoritesState {
  favorites: Event[];
  favoriteIds: Set<string>;
  loading: boolean;
  syncing: boolean;
  pendingSync: boolean;
  lastSyncError: string | null;
}

// Global state to share across components
let globalFavorites: Event[] = [];
let globalFavoriteIds: Set<string> = new Set();
let listeners: Set<() => void> = new Set();

function notifyListeners() {
  listeners.forEach((listener) => listener());
}

export function useFavorites() {
  const [state, setState] = useState<FavoritesState>({
    favorites: globalFavorites,
    favoriteIds: globalFavoriteIds,
    loading: true,
    syncing: false,
    pendingSync: false,
    lastSyncError: null,
  });

  const isMounted = useRef(true);

  // Subscribe to global state changes
  useEffect(() => {
    const listener = () => {
      if (isMounted.current) {
        setState((prev) => ({
          ...prev,
          favorites: globalFavorites,
          favoriteIds: globalFavoriteIds,
        }));
      }
    };

    listeners.add(listener);
    return () => {
      isMounted.current = false;
      listeners.delete(listener);
    };
  }, []);

  // Load favorites on mount
  useEffect(() => {
    loadFavorites();
    loadPendingSync();
  }, []);

  const loadFavorites = async () => {
    try {
      setState((prev) => ({ ...prev, loading: true }));

      const [storedFavorites, storedIds] = await Promise.all([
        AsyncStorage.getItem(FAVORITES_KEY),
        AsyncStorage.getItem(FAVORITES_IDS_KEY),
      ]);

      if (storedFavorites) {
        globalFavorites = JSON.parse(storedFavorites);
      }

      if (storedIds) {
        globalFavoriteIds = new Set(JSON.parse(storedIds));
      } else if (globalFavorites.length > 0) {
        // Migrate: if we have favorites but no IDs, extract them
        globalFavoriteIds = new Set(globalFavorites.map((e) => e.event_id));
        await AsyncStorage.setItem(FAVORITES_IDS_KEY, JSON.stringify([...globalFavoriteIds]));
      }

      notifyListeners();
    } catch (error) {
      console.error('Failed to load favorites:', error);
    } finally {
      if (isMounted.current) {
        setState((prev) => ({ ...prev, loading: false }));
      }
    }
  };

  const loadPendingSync = async () => {
    try {
      const pending = await AsyncStorage.getItem(PENDING_SYNC_KEY);
      if (isMounted.current) {
        setState((prev) => ({ ...prev, pendingSync: pending === 'true' }));
      }
    } catch {
      // Ignore
    }
  };

  const saveFavorites = async (favorites: Event[], ids: Set<string>) => {
    try {
      await Promise.all([
        AsyncStorage.setItem(FAVORITES_KEY, JSON.stringify(favorites)),
        AsyncStorage.setItem(FAVORITES_IDS_KEY, JSON.stringify([...ids])),
        AsyncStorage.setItem(PENDING_SYNC_KEY, 'true'),
      ]);

      globalFavorites = favorites;
      globalFavoriteIds = ids;
      notifyListeners();

      if (isMounted.current) {
        setState((prev) => ({ ...prev, pendingSync: true }));
      }
    } catch (error) {
      console.error('Failed to save favorites:', error);
    }
  };

  /**
   * Add event to favorites
   */
  const addFavorite = useCallback(async (event: Event) => {
    if (globalFavoriteIds.has(event.event_id)) {
      return; // Already a favorite
    }

    const newFavorites = [...globalFavorites, event];
    const newIds = new Set(globalFavoriteIds);
    newIds.add(event.event_id);

    await saveFavorites(newFavorites, newIds);

    // Schedule notification reminder if enabled
    try {
      const settingsStr = await AsyncStorage.getItem(SETTINGS_KEY);
      const settings = settingsStr ? JSON.parse(settingsStr) : {};
      const notificationsEnabled = await areNotificationsEnabled();

      if (settings.notifyReminders !== false && notificationsEnabled && translationFn) {
        await scheduleEventReminder(event, translationFn);
      }
    } catch (error) {
      console.error('Failed to schedule notification:', error);
    }
  }, []);

  /**
   * Remove event from favorites
   */
  const removeFavorite = useCallback(async (eventId: string) => {
    if (!globalFavoriteIds.has(eventId)) {
      return; // Not a favorite
    }

    const newFavorites = globalFavorites.filter((e) => e.event_id !== eventId);
    const newIds = new Set(globalFavoriteIds);
    newIds.delete(eventId);

    await saveFavorites(newFavorites, newIds);

    // Cancel notification reminder
    try {
      await cancelEventReminder(eventId);
    } catch (error) {
      console.error('Failed to cancel notification:', error);
    }
  }, []);

  /**
   * Toggle favorite status
   */
  const toggleFavorite = useCallback(async (event: Event) => {
    if (globalFavoriteIds.has(event.event_id)) {
      await removeFavorite(event.event_id);
    } else {
      await addFavorite(event);
    }
  }, [addFavorite, removeFavorite]);

  /**
   * Check if event is a favorite
   */
  const isFavorite = useCallback((eventId: string) => {
    return globalFavoriteIds.has(eventId);
  }, []);

  /**
   * Sync favorites to server
   */
  const syncToServer = useCallback(async (): Promise<boolean> => {
    if (!api.getDeviceId()) {
      console.warn('Cannot sync: device not registered');
      return false;
    }

    setState((prev) => ({ ...prev, syncing: true, lastSyncError: null }));

    try {
      const eventIds = [...globalFavoriteIds];
      const result = await api.syncFavorites(eventIds);

      if (result) {
        await AsyncStorage.setItem(PENDING_SYNC_KEY, 'false');
        if (isMounted.current) {
          setState((prev) => ({ ...prev, pendingSync: false, syncing: false }));
        }
        return true;
      } else {
        if (isMounted.current) {
          setState((prev) => ({
            ...prev,
            syncing: false,
            lastSyncError: 'Sync failed',
          }));
        }
        return false;
      }
    } catch (error) {
      console.error('Sync error:', error);
      if (isMounted.current) {
        setState((prev) => ({
          ...prev,
          syncing: false,
          lastSyncError: error instanceof Error ? error.message : 'Unknown error',
        }));
      }
      return false;
    }
  }, []);

  /**
   * Refresh favorites (reload from storage)
   */
  const refresh = useCallback(async () => {
    await loadFavorites();
  }, [loadFavorites]);

  return {
    favorites: state.favorites,
    favoriteIds: state.favoriteIds,
    loading: state.loading,
    syncing: state.syncing,
    pendingSync: state.pendingSync,
    lastSyncError: state.lastSyncError,
    addFavorite,
    removeFavorite,
    toggleFavorite,
    isFavorite,
    syncToServer,
    refresh,
  };
}

/**
 * Get favorite IDs synchronously (for components that just need to check)
 */
export function getFavoriteIds(): Set<string> {
  return globalFavoriteIds;
}

/**
 * Get favorites synchronously
 */
export function getFavorites(): Event[] {
  return globalFavorites;
}
