/**
 * API client for Bronze backend
 * Handles all server communication with offline-first support
 */

import AsyncStorage from '@react-native-async-storage/async-storage';
import type { Event } from '../types';

// API configuration
const API_BASE_URL = __DEV__
  ? 'http://localhost:8000/api/v1'  // Local dev
  : 'https://api.bronze.news/api/v1'; // Production

const DEVICE_ID_KEY = '@bronze_device_id';
const LAST_SYNC_KEY = '@bronze_last_sync';

// Type definitions matching backend
export interface DeviceRegisterRequest {
  token: string;
  platform: 'ios' | 'android';
}

export interface DeviceResponse {
  id: string;
  platform: string;
}

export interface FavoritesSyncRequest {
  event_ids: string[];
}

export interface FavoritesSyncResponse {
  synced: number;
  event_ids: string[];
}

export interface EventListResponse {
  events: Event[];
  total: number;
}

export interface ApiError {
  detail: string;
}

class ApiClient {
  private deviceId: string | null = null;

  /**
   * Initialize API client - load stored device ID
   */
  async init(): Promise<void> {
    try {
      this.deviceId = await AsyncStorage.getItem(DEVICE_ID_KEY);
    } catch (error) {
      console.error('Failed to load device ID:', error);
    }
  }

  /**
   * Get stored device ID
   */
  getDeviceId(): string | null {
    return this.deviceId;
  }

  /**
   * Register device with backend for push notifications
   */
  async registerDevice(token: string, platform: 'ios' | 'android'): Promise<DeviceResponse | null> {
    try {
      const response = await fetch(`${API_BASE_URL}/devices`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ token, platform }),
      });

      if (!response.ok) {
        const error: ApiError = await response.json();
        console.error('Device registration failed:', error.detail);
        return null;
      }

      const device: DeviceResponse = await response.json();
      this.deviceId = device.id;
      await AsyncStorage.setItem(DEVICE_ID_KEY, device.id);
      return device;
    } catch (error) {
      // Network errors are expected when offline - handled silently
      const isNetworkError = error instanceof TypeError && error.message === 'Network request failed';
      if (!isNetworkError) {
        console.warn('[API] Device registration error:', error);
      }
      return null;
    }
  }

  /**
   * Fetch all events from server
   */
  async getEvents(params?: {
    sport_code?: string;
    venue_city?: string;
    date?: string;
    medal_only?: boolean;
    include_past?: boolean;
  }): Promise<Event[] | null> {
    try {
      const searchParams = new URLSearchParams();
      if (params?.sport_code) searchParams.append('sport_code', params.sport_code);
      if (params?.venue_city) searchParams.append('venue_city', params.venue_city);
      if (params?.date) searchParams.append('date', params.date);
      if (params?.medal_only) searchParams.append('medal_only', 'true');
      if (params?.include_past) searchParams.append('include_past', 'true');

      const url = `${API_BASE_URL}/events${searchParams.toString() ? `?${searchParams}` : ''}`;
      const response = await fetch(url);

      if (!response.ok) {
        console.error('Failed to fetch events:', response.status);
        return null;
      }

      const data: EventListResponse = await response.json();
      return data.events;
    } catch (error) {
      console.error('Fetch events error:', error);
      return null;
    }
  }

  /**
   * Fetch single event by ID
   */
  async getEvent(eventId: string): Promise<Event | null> {
    try {
      const response = await fetch(`${API_BASE_URL}/events/${eventId}`);

      if (!response.ok) {
        if (response.status === 404) {
          return null;
        }
        console.error('Failed to fetch event:', response.status);
        return null;
      }

      return await response.json();
    } catch (error) {
      console.error('Fetch event error:', error);
      return null;
    }
  }

  /**
   * Sync favorites to server (replaces all server-side favorites)
   */
  async syncFavorites(eventIds: string[]): Promise<FavoritesSyncResponse | null> {
    if (!this.deviceId) {
      console.warn('Cannot sync favorites: no device ID');
      return null;
    }

    try {
      const response = await fetch(`${API_BASE_URL}/devices/${this.deviceId}/favorites`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ event_ids: eventIds }),
      });

      if (!response.ok) {
        const error: ApiError = await response.json();
        console.error('Favorites sync failed:', error.detail);
        return null;
      }

      const result: FavoritesSyncResponse = await response.json();
      await AsyncStorage.setItem(LAST_SYNC_KEY, new Date().toISOString());
      return result;
    } catch (error) {
      console.error('Favorites sync error:', error);
      return null;
    }
  }

  /**
   * Get server-stored favorites (for reconciliation)
   */
  async getServerFavorites(): Promise<string[] | null> {
    if (!this.deviceId) {
      return null;
    }

    try {
      const response = await fetch(`${API_BASE_URL}/devices/${this.deviceId}/favorites`);

      if (!response.ok) {
        console.error('Failed to fetch server favorites:', response.status);
        return null;
      }

      const data: FavoritesSyncResponse = await response.json();
      return data.event_ids;
    } catch (error) {
      console.error('Fetch server favorites error:', error);
      return null;
    }
  }

  /**
   * Get last sync timestamp
   */
  async getLastSyncTime(): Promise<Date | null> {
    try {
      const stored = await AsyncStorage.getItem(LAST_SYNC_KEY);
      return stored ? new Date(stored) : null;
    } catch {
      return null;
    }
  }

  /**
   * Health check - test server connectivity
   */
  async healthCheck(): Promise<boolean> {
    try {
      const response = await fetch(`${API_BASE_URL}/health`, {
        method: 'GET',
        // Short timeout for health check
        signal: AbortSignal.timeout(5000),
      });
      return response.ok;
    } catch {
      return false;
    }
  }
}

// Singleton instance
export const api = new ApiClient();
