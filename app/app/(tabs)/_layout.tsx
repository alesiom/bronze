import { Tabs } from 'expo-router';
import { useColorScheme, StyleSheet, View, Text } from 'react-native';
import { useTranslation } from 'react-i18next';

import { colors, darkColors, sizing, typography } from '../../theme';

// Simple icon components (we'll use text-based for now, can swap for proper icons later)
function TabIcon({
  name,
  focused,
  color,
}: {
  name: 'schedule' | 'favorites' | 'settings';
  focused: boolean;
  color: string;
}) {
  const icons: Record<string, string> = {
    schedule: '📅',
    favorites: focused ? '❤️' : '🤍',
    settings: '⚙️',
  };

  return (
    <View style={styles.iconContainer}>
      <Text style={[styles.icon, { opacity: focused ? 1 : 0.7 }]}>
        {icons[name]}
      </Text>
    </View>
  );
}

export default function TabLayout() {
  const { t } = useTranslation();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  return (
    <Tabs
      screenOptions={{
        tabBarActiveTintColor: theme.primary,
        tabBarInactiveTintColor: theme.textMuted,
        tabBarStyle: {
          backgroundColor: theme.background,
          borderTopColor: isDark ? '#2A3A4A' : '#E5E5E5',
          height: sizing.touchTarget.comfort + 20,
          paddingBottom: 8,
          paddingTop: 8,
        },
        tabBarLabelStyle: {
          fontSize: typography.fontSize.sm,
          fontWeight: '600',
        },
        headerStyle: {
          backgroundColor: theme.primary,
        },
        headerTintColor: colors.snowWhite,
        headerTitleStyle: {
          fontWeight: '700',
          fontSize: typography.fontSize.xl,
        },
      }}
    >
      <Tabs.Screen
        name="index"
        options={{
          title: t('tabs.schedule'),
          tabBarIcon: ({ focused, color }) => (
            <TabIcon name="schedule" focused={focused} color={color} />
          ),
        }}
      />
      <Tabs.Screen
        name="favorites"
        options={{
          title: t('tabs.favorites'),
          tabBarIcon: ({ focused, color }) => (
            <TabIcon name="favorites" focused={focused} color={color} />
          ),
        }}
      />
      <Tabs.Screen
        name="settings"
        options={{
          title: t('tabs.settings'),
          tabBarIcon: ({ focused, color }) => (
            <TabIcon name="settings" focused={focused} color={color} />
          ),
        }}
      />
    </Tabs>
  );
}

const styles = StyleSheet.create({
  iconContainer: {
    alignItems: 'center',
    justifyContent: 'center',
    width: sizing.icon.large,
    height: sizing.icon.large,
  },
  icon: {
    fontSize: 24,
  },
});
