/**
 * Notifications hook for managing local event reminders
 */

import { useState, useEffect, useCallback, useRef } from 'react';
import { useTranslation } from 'react-i18next';
import { AppState, AppStateStatus } from 'react-native';
import {
  initNotifications,
  requestPermissions,
  areNotificationsEnabled,
  scheduleEventReminder,
  cancelEventReminder,
  scheduleAllReminders,
  cancelAllReminders,
  cleanupExpiredNotifications,
  addNotificationResponseListener,
} from '../services/notifications';
import { useSettings } from './useSettings';
import { getFavorites } from './useFavorites';
import type { Event } from '../types';

export interface NotificationState {
  permissionGranted: boolean;
  permissionChecked: boolean;
}

export function useNotifications() {
  const { t } = useTranslation();
  const { settings } = useSettings();
  const [state, setState] = useState<NotificationState>({
    permissionGranted: false,
    permissionChecked: false,
  });
  const appState = useRef(AppState.currentState);

  // Initialize notifications on mount
  useEffect(() => {
    const init = async () => {
      await initNotifications();
      const granted = await areNotificationsEnabled();
      setState({
        permissionGranted: granted,
        permissionChecked: true,
      });

      // Cleanup expired notifications
      await cleanupExpiredNotifications();

      // If reminders are enabled, schedule for all favorites
      if (granted && settings.notifyReminders) {
        const favorites = getFavorites();
        await scheduleAllReminders(favorites, t);
      }
    };

    init();
  }, []);

  // Handle settings changes - enable/disable all reminders
  useEffect(() => {
    const updateReminders = async () => {
      if (!state.permissionChecked) return;

      if (settings.notifyReminders && state.permissionGranted) {
        const favorites = getFavorites();
        await scheduleAllReminders(favorites, t);
      } else {
        await cancelAllReminders();
      }
    };

    updateReminders();
  }, [settings.notifyReminders, state.permissionGranted, state.permissionChecked, t]);

  // Cleanup notifications when app comes to foreground
  useEffect(() => {
    const subscription = AppState.addEventListener('change', (nextAppState: AppStateStatus) => {
      if (
        appState.current.match(/inactive|background/) &&
        nextAppState === 'active'
      ) {
        cleanupExpiredNotifications();
      }
      appState.current = nextAppState;
    });

    return () => {
      subscription.remove();
    };
  }, []);

  /**
   * Request notification permissions
   */
  const requestNotificationPermissions = useCallback(async (): Promise<boolean> => {
    const granted = await requestPermissions();
    setState((prev) => ({
      ...prev,
      permissionGranted: granted,
    }));
    return granted;
  }, []);

  /**
   * Schedule reminder for a single event
   */
  const scheduleReminder = useCallback(
    async (event: Event): Promise<boolean> => {
      if (!state.permissionGranted || !settings.notifyReminders) {
        return false;
      }
      return scheduleEventReminder(event, t);
    },
    [state.permissionGranted, settings.notifyReminders, t]
  );

  /**
   * Cancel reminder for a single event
   */
  const cancelReminder = useCallback(async (eventId: string): Promise<void> => {
    await cancelEventReminder(eventId);
  }, []);

  /**
   * Schedule reminders for multiple events
   */
  const scheduleReminders = useCallback(
    async (events: Event[]): Promise<void> => {
      if (!state.permissionGranted || !settings.notifyReminders) {
        return;
      }
      await scheduleAllReminders(events, t);
    },
    [state.permissionGranted, settings.notifyReminders, t]
  );

  return {
    ...state,
    requestNotificationPermissions,
    scheduleReminder,
    cancelReminder,
    scheduleReminders,
    cancelAllReminders,
  };
}

/**
 * Hook to handle notification taps (navigate to event)
 */
export function useNotificationNavigation(onEventTap: (eventId: string) => void) {
  useEffect(() => {
    const subscription = addNotificationResponseListener(onEventTap);
    return () => {
      subscription.remove();
    };
  }, [onEventTap]);
}
