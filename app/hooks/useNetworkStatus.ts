/**
 * Network status hook for offline-first support
 * Provides connection state and last sync information
 */

import { useState, useEffect, useCallback } from 'react';
import NetInfo, { NetInfoState } from '@react-native-community/netinfo';
import { api } from '../services/api';

export interface NetworkStatus {
  isConnected: boolean;
  isInternetReachable: boolean | null;
  connectionType: string | null;
  lastSyncTime: Date | null;
  isServerReachable: boolean;
}

export function useNetworkStatus() {
  const [status, setStatus] = useState<NetworkStatus>({
    isConnected: true, // Assume connected initially
    isInternetReachable: null,
    connectionType: null,
    lastSyncTime: null,
    isServerReachable: false,
  });
  const [checking, setChecking] = useState(false);

  // Update status from NetInfo state
  const updateFromNetInfo = useCallback((state: NetInfoState) => {
    setStatus((prev) => ({
      ...prev,
      isConnected: state.isConnected ?? false,
      isInternetReachable: state.isInternetReachable,
      connectionType: state.type,
    }));
  }, []);

  // Check server reachability
  const checkServerReachability = useCallback(async () => {
    if (checking) return;

    setChecking(true);
    try {
      const reachable = await api.healthCheck();
      const lastSync = await api.getLastSyncTime();

      setStatus((prev) => ({
        ...prev,
        isServerReachable: reachable,
        lastSyncTime: lastSync,
      }));
    } catch {
      setStatus((prev) => ({
        ...prev,
        isServerReachable: false,
      }));
    } finally {
      setChecking(false);
    }
  }, [checking]);

  // Subscribe to network changes
  useEffect(() => {
    const unsubscribe = NetInfo.addEventListener(updateFromNetInfo);

    // Initial fetch
    NetInfo.fetch().then(updateFromNetInfo);

    return () => {
      unsubscribe();
    };
  }, [updateFromNetInfo]);

  // Check server when connection changes
  useEffect(() => {
    if (status.isConnected && status.isInternetReachable) {
      checkServerReachability();
    } else {
      setStatus((prev) => ({
        ...prev,
        isServerReachable: false,
      }));
    }
  }, [status.isConnected, status.isInternetReachable]);

  // Refresh last sync time
  const refreshLastSync = useCallback(async () => {
    const lastSync = await api.getLastSyncTime();
    setStatus((prev) => ({
      ...prev,
      lastSyncTime: lastSync,
    }));
  }, []);

  return {
    ...status,
    checking,
    checkServerReachability,
    refreshLastSync,
  };
}

/**
 * Format relative time for "Last synced X ago" display
 */
export function formatRelativeTime(
  date: Date | null,
  t: (key: string, options?: Record<string, unknown>) => string
): string {
  if (!date) {
    return t('sync.never');
  }

  const now = new Date();
  const diffMs = now.getTime() - date.getTime();
  const diffMins = Math.floor(diffMs / 60000);
  const diffHours = Math.floor(diffMins / 60);
  const diffDays = Math.floor(diffHours / 24);

  if (diffMins < 1) {
    return t('sync.justNow');
  } else if (diffMins < 60) {
    return t('sync.minutesAgo', { count: diffMins });
  } else if (diffHours < 24) {
    return t('sync.hoursAgo', { count: diffHours });
  } else {
    return t('sync.daysAgo', { count: diffDays });
  }
}
