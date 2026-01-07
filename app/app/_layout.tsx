import { useEffect, useRef, useCallback } from 'react';
import { Stack, useRouter } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { I18nManager, useColorScheme, AppState, AppStateStatus } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { useTranslation } from 'react-i18next';

import '../i18n';
import { colors, darkColors } from '../theme';
import { isRTL } from '../i18n';
import i18n from '../i18n';
import { api } from '../services/api';
import { initNotifications, requestPermissions, getPushToken } from '../services/notifications';
import {
  useDeviceRegistration,
  useFavorites,
  useNetworkStatus,
  useNotificationNavigation,
  setTranslationFunction,
} from '../hooks';

export default function RootLayout() {
  const { t } = useTranslation();
  const router = useRouter();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  const { isRegistered, registerWithToken, registerPlaceholder } = useDeviceRegistration();
  const { syncToServer, pendingSync } = useFavorites();
  const { isConnected, isServerReachable } = useNetworkStatus();
  const appState = useRef(AppState.currentState);

  // Set translation function for favorites notifications
  useEffect(() => {
    setTranslationFunction(t);
  }, [t]);

  // Handle notification taps - navigate to event
  const handleNotificationTap = useCallback((eventId: string) => {
    router.push(`/event/${eventId}`);
  }, [router]);

  useNotificationNavigation(handleNotificationTap);

  // Handle RTL languages
  useEffect(() => {
    const isRtlLanguage = isRTL(i18n.language);
    if (I18nManager.isRTL !== isRtlLanguage) {
      I18nManager.allowRTL(isRtlLanguage);
      I18nManager.forceRTL(isRtlLanguage);
    }
  }, []);

  // Initialize API, notifications, and register device on first load
  useEffect(() => {
    const initializeApp = async () => {
      // Initialize API
      await api.init();

      // Initialize notifications
      await initNotifications();

      // Request notification permissions
      const permissionGranted = await requestPermissions();

      // Get push token and register device
      if (permissionGranted) {
        const pushToken = await getPushToken();
        if (pushToken && !api.getDeviceId()) {
          await registerWithToken(pushToken);
        }
      }

      // Fallback: register with placeholder if no push token
      if (!isRegistered && !api.getDeviceId()) {
        await registerPlaceholder();
      }
    };

    initializeApp();
  }, []);

  // Sync favorites when coming online or returning to app
  useEffect(() => {
    const subscription = AppState.addEventListener('change', (nextAppState: AppStateStatus) => {
      if (
        appState.current.match(/inactive|background/) &&
        nextAppState === 'active' &&
        pendingSync &&
        isConnected &&
        isServerReachable
      ) {
        syncToServer();
      }
      appState.current = nextAppState;
    });

    return () => {
      subscription.remove();
    };
  }, [pendingSync, isConnected, isServerReachable, syncToServer]);

  // Sync when network becomes available
  useEffect(() => {
    if (isConnected && isServerReachable && pendingSync) {
      syncToServer();
    }
  }, [isConnected, isServerReachable, pendingSync, syncToServer]);

  return (
    <GestureHandlerRootView style={{ flex: 1 }}>
      <SafeAreaProvider>
        <StatusBar style={isDark ? 'light' : 'dark'} />
        <Stack
          screenOptions={{
            headerStyle: {
              backgroundColor: colors.alpineGreenDark, // AAA compliant dark green
            },
            headerTintColor: colors.snowWhite,
            headerTitleStyle: {
              fontWeight: '700',
            },
            contentStyle: {
              backgroundColor: theme.background,
            },
          }}
        >
          <Stack.Screen
            name="(tabs)"
            options={{
              headerShown: false,
            }}
          />
          <Stack.Screen
            name="event/[id]"
            options={{
              presentation: 'modal',
              headerTitle: '',
            }}
          />
          <Stack.Screen
            name="session/[code]"
            options={{
              presentation: 'modal',
              headerTitle: '',
            }}
          />
        </Stack>
      </SafeAreaProvider>
    </GestureHandlerRootView>
  );
}
