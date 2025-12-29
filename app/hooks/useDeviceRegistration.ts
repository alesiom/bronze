/**
 * Device registration hook
 * Handles registering device with backend for push notifications
 */

import { useState, useEffect, useCallback } from 'react';
import { Platform } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { api } from '../services/api';

const DEVICE_TOKEN_KEY = '@neve26_push_token';

export interface DeviceRegistrationState {
  isRegistered: boolean;
  deviceId: string | null;
  loading: boolean;
  error: string | null;
}

export function useDeviceRegistration() {
  const [state, setState] = useState<DeviceRegistrationState>({
    isRegistered: false,
    deviceId: null,
    loading: true,
    error: null,
  });

  // Initialize API client and check registration
  useEffect(() => {
    initializeDevice();
  }, []);

  const initializeDevice = async () => {
    setState((prev) => ({ ...prev, loading: true, error: null }));

    try {
      // Initialize API client (loads stored device ID)
      await api.init();
      const existingDeviceId = api.getDeviceId();

      if (existingDeviceId) {
        setState({
          isRegistered: true,
          deviceId: existingDeviceId,
          loading: false,
          error: null,
        });
      } else {
        setState((prev) => ({
          ...prev,
          loading: false,
        }));
      }
    } catch (error) {
      console.error('Device initialization error:', error);
      setState((prev) => ({
        ...prev,
        loading: false,
        error: 'Failed to initialize device',
      }));
    }
  };

  /**
   * Register device with push notification token
   * Should be called after obtaining FCM/APNs token
   */
  const registerWithToken = useCallback(async (pushToken: string): Promise<boolean> => {
    setState((prev) => ({ ...prev, loading: true, error: null }));

    try {
      const platform = Platform.OS === 'ios' ? 'ios' : 'android';
      const result = await api.registerDevice(pushToken, platform);

      if (result) {
        // Store the push token for later reference
        await AsyncStorage.setItem(DEVICE_TOKEN_KEY, pushToken);

        setState({
          isRegistered: true,
          deviceId: result.id,
          loading: false,
          error: null,
        });
        return true;
      } else {
        setState((prev) => ({
          ...prev,
          loading: false,
          error: 'Registration failed',
        }));
        return false;
      }
    } catch (error) {
      console.error('Device registration error:', error);
      setState((prev) => ({
        ...prev,
        loading: false,
        error: error instanceof Error ? error.message : 'Unknown error',
      }));
      return false;
    }
  }, []);

  /**
   * Register with a placeholder token (for testing/development)
   * In production, this should use expo-notifications to get real token
   */
  const registerPlaceholder = useCallback(async (): Promise<boolean> => {
    // Generate a pseudo-unique placeholder token for development
    const platform = Platform.OS === 'ios' ? 'ios' : 'android';
    const placeholderToken = `dev_${platform}_${Date.now()}_${Math.random().toString(36).substring(7)}`;

    return registerWithToken(placeholderToken);
  }, [registerWithToken]);

  /**
   * Get stored push token
   */
  const getStoredToken = useCallback(async (): Promise<string | null> => {
    try {
      return await AsyncStorage.getItem(DEVICE_TOKEN_KEY);
    } catch {
      return null;
    }
  }, []);

  return {
    ...state,
    registerWithToken,
    registerPlaceholder,
    getStoredToken,
    refresh: initializeDevice,
  };
}
