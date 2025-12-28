import { useEffect } from 'react';
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { I18nManager, useColorScheme } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { GestureHandlerRootView } from 'react-native-gesture-handler';

import '../i18n';
import { colors, darkColors } from '../theme';
import { isRTL } from '../i18n';
import i18n from '../i18n';

export default function RootLayout() {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  // Handle RTL languages
  useEffect(() => {
    const isRtlLanguage = isRTL(i18n.language);
    if (I18nManager.isRTL !== isRtlLanguage) {
      I18nManager.allowRTL(isRtlLanguage);
      I18nManager.forceRTL(isRtlLanguage);
    }
  }, []);

  return (
    <GestureHandlerRootView style={{ flex: 1 }}>
      <SafeAreaProvider>
        <StatusBar style={isDark ? 'light' : 'dark'} />
        <Stack
          screenOptions={{
            headerStyle: {
              backgroundColor: theme.primary,
            },
            headerTintColor: colors.snowWhite,
            headerTitleStyle: {
              fontWeight: '600',
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
