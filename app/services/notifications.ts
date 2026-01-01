/**
 * Local notification service for event reminders
 * Schedules notifications 2 hours before favorited events
 * Works completely offline - no server required
 */

import * as Notifications from 'expo-notifications';
import * as Device from 'expo-device';
import { Platform } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import type { Event } from '../types';

const SCHEDULED_NOTIFICATIONS_KEY = '@neve26_scheduled_notifications';
const REMINDER_MINUTES = 120; // 2 hours before event

// Configure notification behavior
Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: true,
    shouldSetBadge: false,
    shouldShowBanner: true,
    shouldShowList: true,
  }),
});

// Store mapping of event_id -> notification_id
interface ScheduledNotifications {
  [eventId: string]: string; // eventId -> notificationId
}

let scheduledNotifications: ScheduledNotifications = {};

/**
 * Initialize notifications - load scheduled notifications from storage
 */
export async function initNotifications(): Promise<void> {
  try {
    const stored = await AsyncStorage.getItem(SCHEDULED_NOTIFICATIONS_KEY);
    if (stored) {
      scheduledNotifications = JSON.parse(stored);
    }
  } catch (error) {
    console.error('Failed to load scheduled notifications:', error);
  }
}

/**
 * Request notification permissions
 * Returns true if granted, false otherwise
 */
export async function requestPermissions(): Promise<boolean> {
  // Check if this is a physical device
  if (!Device.isDevice) {
    console.log('Notifications require a physical device');
    return false;
  }

  // Check existing permissions
  const { status: existingStatus } = await Notifications.getPermissionsAsync();

  if (existingStatus === 'granted') {
    return true;
  }

  // Request permissions
  const { status } = await Notifications.requestPermissionsAsync();

  if (status !== 'granted') {
    console.log('Notification permissions not granted');
    return false;
  }

  // Set up Android notification channel
  if (Platform.OS === 'android') {
    await Notifications.setNotificationChannelAsync('reminders', {
      name: 'Event Reminders',
      importance: Notifications.AndroidImportance.HIGH,
      vibrationPattern: [0, 250, 250, 250],
      lightColor: '#1E5A9C', // Alpine blue
    });
  }

  return true;
}

/**
 * Check if notifications are enabled
 */
export async function areNotificationsEnabled(): Promise<boolean> {
  const { status } = await Notifications.getPermissionsAsync();
  return status === 'granted';
}

/**
 * Get the push token for this device (for FCM/APNs)
 */
export async function getPushToken(): Promise<string | null> {
  if (!Device.isDevice) {
    return null;
  }

  try {
    const { data: token } = await Notifications.getExpoPushTokenAsync({
      projectId: 'neve26', // Replace with actual Expo project ID
    });
    return token;
  } catch (error) {
    console.error('Failed to get push token:', error);
    return null;
  }
}

/**
 * Parse event start_time to a Date object
 */
function getEventDateTime(event: Event): Date | null {
  if (!event.start_time) {
    return null;
  }

  try {
    // Parse ISO datetime string (e.g., "2026-02-07T11:30:00")
    return new Date(event.start_time);
  } catch {
    console.error('Failed to parse event start_time:', event.start_time);
    return null;
  }
}

/**
 * Schedule a 2h reminder notification for an event
 */
export async function scheduleEventReminder(
  event: Event,
  t: (key: string, options?: Record<string, unknown>) => string
): Promise<boolean> {
  // Check if already scheduled
  if (scheduledNotifications[event.event_id]) {
    return true;
  }

  const eventTime = getEventDateTime(event);
  if (!eventTime) {
    console.log('Cannot schedule notification: no event time', event.event_id);
    return false;
  }

  // Calculate reminder time (2h before event)
  const reminderTime = new Date(eventTime.getTime() - REMINDER_MINUTES * 60 * 1000);
  const now = new Date();

  // Don't schedule if reminder time is in the past
  if (reminderTime <= now) {
    console.log('Reminder time already passed:', event.event_id);
    return false;
  }

  try {
    const notificationId = await Notifications.scheduleNotificationAsync({
      content: {
        title: t('notifications.reminderTitle', { sport: event.sport }),
        body: t('notifications.reminderBody', {
          eventName: event.event_name,
          venue: event.venue || event.location,
        }),
        data: {
          eventId: event.event_id,
          type: 'reminder',
        },
        sound: true,
        ...(Platform.OS === 'android' && { channelId: 'reminders' }),
      },
      trigger: {
        type: Notifications.SchedulableTriggerInputTypes.DATE,
        date: reminderTime,
      },
    });

    // Store the mapping
    scheduledNotifications[event.event_id] = notificationId;
    await saveScheduledNotifications();

    console.log('Scheduled reminder for', event.event_id, 'at', reminderTime);
    return true;
  } catch (error) {
    console.error('Failed to schedule notification:', error);
    return false;
  }
}

/**
 * Cancel a scheduled reminder for an event
 */
export async function cancelEventReminder(eventId: string): Promise<void> {
  const notificationId = scheduledNotifications[eventId];

  if (!notificationId) {
    return;
  }

  try {
    await Notifications.cancelScheduledNotificationAsync(notificationId);
    delete scheduledNotifications[eventId];
    await saveScheduledNotifications();
    console.log('Cancelled reminder for', eventId);
  } catch (error) {
    console.error('Failed to cancel notification:', error);
  }
}

/**
 * Reschedule a reminder (when event time changes)
 */
export async function rescheduleEventReminder(
  event: Event,
  t: (key: string, options?: Record<string, unknown>) => string
): Promise<boolean> {
  await cancelEventReminder(event.event_id);
  return scheduleEventReminder(event, t);
}

/**
 * Schedule reminders for all favorited events
 */
export async function scheduleAllReminders(
  events: Event[],
  t: (key: string, options?: Record<string, unknown>) => string
): Promise<void> {
  for (const event of events) {
    await scheduleEventReminder(event, t);
  }
}

/**
 * Cancel all scheduled reminders
 */
export async function cancelAllReminders(): Promise<void> {
  try {
    await Notifications.cancelAllScheduledNotificationsAsync();
    scheduledNotifications = {};
    await saveScheduledNotifications();
    console.log('Cancelled all reminders');
  } catch (error) {
    console.error('Failed to cancel all notifications:', error);
  }
}

/**
 * Get all scheduled notification IDs
 */
export function getScheduledEventIds(): string[] {
  return Object.keys(scheduledNotifications);
}

/**
 * Check if an event has a scheduled reminder
 */
export function hasScheduledReminder(eventId: string): boolean {
  return !!scheduledNotifications[eventId];
}

/**
 * Save scheduled notifications to storage
 */
async function saveScheduledNotifications(): Promise<void> {
  try {
    await AsyncStorage.setItem(
      SCHEDULED_NOTIFICATIONS_KEY,
      JSON.stringify(scheduledNotifications)
    );
  } catch (error) {
    console.error('Failed to save scheduled notifications:', error);
  }
}

/**
 * Clean up expired notifications (already fired)
 */
export async function cleanupExpiredNotifications(): Promise<void> {
  try {
    const scheduled = await Notifications.getAllScheduledNotificationsAsync();
    const activeIds = new Set(scheduled.map((n) => n.identifier));

    // Remove any stored notifications that are no longer scheduled
    let changed = false;
    for (const eventId of Object.keys(scheduledNotifications)) {
      if (!activeIds.has(scheduledNotifications[eventId])) {
        delete scheduledNotifications[eventId];
        changed = true;
      }
    }

    if (changed) {
      await saveScheduledNotifications();
    }
  } catch (error) {
    console.error('Failed to cleanup expired notifications:', error);
  }
}

/**
 * Add listener for notification responses (when user taps notification)
 */
export function addNotificationResponseListener(
  callback: (eventId: string) => void
): Notifications.EventSubscription {
  return Notifications.addNotificationResponseReceivedListener((response) => {
    const data = response.notification.request.content.data;
    if (data?.eventId) {
      callback(data.eventId as string);
    }
  });
}
