import { useEffect, useRef } from 'react';
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { I18nManager, useColorScheme, AppState, AppStateStatus } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { GestureHandlerRootView } from 'react-native-gesture-handler';

import '../i18n';
import { colors, darkColors } from '../theme';
import { isRTL } from '../i18n';
import i18n from '../i18n';
import { api } from '../services/api';
import { useDeviceRegistration, useFavorites, useNetworkStatus } from '../hooks';

export default function RootLayout() {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  const { isRegistered, registerPlaceholder } = useDeviceRegistration();
  const { syncToServer, pendingSync } = useFavorites();
  const { isConnected, isServerReachable } = useNetworkStatus();
  const appState = useRef(AppState.currentState);

  // Handle RTL languages
  useEffect(() => {
    const isRtlLanguage = isRTL(i18n.language);
    if (I18nManager.isRTL !== isRtlLanguage) {
      I18nManager.allowRTL(isRtlLanguage);
      I18nManager.forceRTL(isRtlLanguage);
    }
  }, []);

  // Initialize API and register device on first load
  useEffect(() => {
    const initializeApp = async () => {
      await api.init();

      // If not registered, register with placeholder token
      // In production, this would use expo-notifications to get real FCM/APNs token
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
        </Stack>
      </SafeAreaProvider>
    </GestureHandlerRootView>
  );
}
