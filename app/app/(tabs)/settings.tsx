import { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Switch,
  useColorScheme,
  Alert,
} from 'react-native';
import { useTranslation } from 'react-i18next';
import { SafeAreaView } from 'react-native-safe-area-context';
import AsyncStorage from '@react-native-async-storage/async-storage';

import { colors, darkColors, spacing, sizing, typography, presets } from '../../theme';
import type { ViewStyle } from 'react-native';
import { supportedLanguages, type LanguageCode } from '../../i18n';
import i18n from '../../i18n';
import { useSettings, type ThemeMode } from '../../hooks/useSettings';
import { useFavorites } from '../../hooks';
import { Icons, SyncStatusIndicator } from '../../components';

function SettingRow({
  label,
  value,
  onPress,
  showChevron = true,
  opensUp = false,
}: {
  label: string;
  value?: string;
  onPress?: () => void;
  showChevron?: boolean;
  opensUp?: boolean;  // Shows up arrow for expandable sections
}) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  // Determine which chevron to show
  const ChevronIcon = opensUp ? Icons.ChevronUp : Icons.ChevronDown;

  return (
    <TouchableOpacity
      style={[styles.settingRow, { borderBottomColor: theme.border }]}
      onPress={onPress}
      activeOpacity={onPress ? 0.8 : 1}
      disabled={!onPress}
    >
      <Text style={[styles.settingLabel, { color: theme.text }]}>{label}</Text>
      <View style={styles.settingValue}>
        {value && (
          <Text style={[styles.settingValueText, { color: theme.textMuted }]}>
            {value}
          </Text>
        )}
        {showChevron && onPress && (
          <ChevronIcon size={20} color={theme.textMuted} />
        )}
      </View>
    </TouchableOpacity>
  );
}

function SettingToggle({
  label,
  hint,
  value,
  onValueChange,
}: {
  label: string;
  hint?: string;
  value: boolean;
  onValueChange: (value: boolean) => void;
}) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  return (
    <View style={[styles.settingRow, styles.toggleRow, { borderBottomColor: theme.border }]}>
      <View style={styles.toggleInfo}>
        <Text style={[styles.settingLabel, { color: theme.text }]}>{label}</Text>
        {hint && (
          <Text style={[styles.settingHint, { color: theme.textMuted }]}>{hint}</Text>
        )}
      </View>
      <Switch
        value={value}
        onValueChange={onValueChange}
        trackColor={{ false: theme.textMuted, true: colors.primary }}
        thumbColor={value ? colors.snowWhite : colors.snowWhite}
      />
    </View>
  );
}

function SectionHeader({ title }: { title: string }) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  return (
    <View style={styles.sectionHeader}>
      <Text style={[styles.sectionTitle, { color: theme.textSecondary }]}>
        {title.toUpperCase()}
      </Text>
    </View>
  );
}

export default function SettingsScreen() {
  const { t } = useTranslation();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  const { settings, updateSettings, loading } = useSettings();
  const { favorites, refresh: refreshFavorites } = useFavorites();
  const [showLanguagePicker, setShowLanguagePicker] = useState(false);

  const currentLanguage = supportedLanguages.find((l) => l.code === i18n.language);

  const handleClearFavorites = async () => {
    Alert.alert(
      'Clear All Favorites',
      `This will remove all ${favorites.length} favorites. Are you sure?`,
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Clear All',
          style: 'destructive',
          onPress: async () => {
            try {
              await AsyncStorage.removeItem('@bronze_favorites');
              await AsyncStorage.removeItem('@bronze_favorite_ids');
              await AsyncStorage.removeItem('@bronze_pending_sync');
              await refreshFavorites();
              Alert.alert('Done', 'All favorites cleared');
            } catch (error) {
              console.error('Failed to clear favorites:', error);
              Alert.alert('Error', 'Failed to clear favorites');
            }
          },
        },
      ]
    );
  };

  const handleDebugFavorites = async () => {
    const stored = await AsyncStorage.getItem('@bronze_favorites');
    const storedIds = await AsyncStorage.getItem('@bronze_favorite_ids');
    console.log('[DEBUG] Stored favorites raw:', stored);
    console.log('[DEBUG] Stored favorite IDs raw:', storedIds);
    const parsed = stored ? JSON.parse(stored) : [];
    Alert.alert(
      'Debug Info',
      `Favorites in memory: ${favorites.length}\nFavorites in storage: ${parsed.length}\nIDs: ${parsed.map((e: any) => e.event_id?.substring(0, 20)).join(', ')}`
    );
  };

  const handleLanguageChange = (code: LanguageCode) => {
    i18n.changeLanguage(code);
    updateSettings({ language: code });
    setShowLanguagePicker(false);
  };

  const handleThemeChange = () => {
    const modes: ThemeMode[] = ['system', 'light', 'dark'];
    const currentIndex = modes.indexOf(settings.themeMode);
    const newMode = modes[(currentIndex + 1) % modes.length];
    updateSettings({ themeMode: newMode });
    Alert.alert(
      t('settings.theme'),
      'Theme changes will apply on next app restart.',
      [{ text: 'OK' }]
    );
  };

  const getThemeLabel = (mode: ThemeMode) => {
    switch (mode) {
      case 'light':
        return t('settings.themeLight');
      case 'dark':
        return t('settings.themeDark');
      case 'system':
        return t('settings.themeSystem');
    }
  };

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top', 'left', 'right']}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        {/* Appearance Section */}
        <SectionHeader title={t('settings.appearance')} />
        <View style={[styles.section, { backgroundColor: theme.surface }, presets.hardShadow as ViewStyle]}>
          <SettingRow
            label={t('settings.theme')}
            value={getThemeLabel(settings.themeMode)}
            onPress={handleThemeChange}
          />
        </View>

        {/* Display Section */}
        <SectionHeader title={t('settings.display')} />
        <View style={[styles.section, { backgroundColor: theme.surface }, presets.hardShadow as ViewStyle]}>
          <SettingToggle
            label={t('settings.comfortMode')}
            hint={t('settings.comfortModeHint')}
            value={settings.comfortMode}
            onValueChange={(value) => updateSettings({ comfortMode: value })}
          />
        </View>

        {/* Language Section */}
        <SectionHeader title={t('settings.language')} />
        <View style={[styles.section, { backgroundColor: theme.surface }, presets.hardShadow as ViewStyle]}>
          <SettingRow
            label={t('settings.language')}
            value={currentLanguage?.nativeName ?? 'English'}
            onPress={() => setShowLanguagePicker(!showLanguagePicker)}
            opensUp={!showLanguagePicker}
          />
          {showLanguagePicker && (
            <View style={styles.languageList}>
              {supportedLanguages.map((lang) => (
                <TouchableOpacity
                  key={lang.code}
                  style={[
                    styles.languageOption,
                    i18n.language === lang.code && {
                      backgroundColor: colors.primary + '20',
                    },
                  ]}
                  onPress={() => handleLanguageChange(lang.code)}
                >
                  <Text
                    style={[
                      styles.languageName,
                      { color: theme.text },
                      i18n.language === lang.code && { color: colors.primary },
                    ]}
                  >
                    {lang.nativeName}
                  </Text>
                  <Text style={[styles.languageEnglish, { color: theme.textMuted }]}>
                    {lang.name}
                  </Text>
                </TouchableOpacity>
              ))}
            </View>
          )}
        </View>

        {/* Notifications Section */}
        <SectionHeader title={t('settings.notifications')} />
        <View style={[styles.section, { backgroundColor: theme.surface }, presets.hardShadow as ViewStyle]}>
          <SettingToggle
            label={t('settings.notifyReminders')}
            hint={t('settings.notifyRemindersHint')}
            value={settings.notifyReminders}
            onValueChange={(value) => updateSettings({ notifyReminders: value })}
          />
          <SettingToggle
            label={t('settings.notifyChanges')}
            hint={t('settings.notifyChangesHint')}
            value={settings.notifyChanges}
            onValueChange={(value) => updateSettings({ notifyChanges: value })}
          />
        </View>

        {/* Sync Status Section */}
        <SectionHeader title={t('sync.synced')} />
        <View style={[styles.section, { backgroundColor: theme.surface }, presets.hardShadow as ViewStyle]}>
          <SyncStatusIndicator />
        </View>

        {/* Debug Section */}
        <SectionHeader title="Debug" />
        <View style={[styles.section, { backgroundColor: theme.surface }, presets.hardShadow as ViewStyle]}>
          <SettingRow
            label="Debug Favorites"
            value={`${favorites.length} items`}
            onPress={handleDebugFavorites}
          />
          <SettingRow
            label="Clear All Favorites"
            onPress={handleClearFavorites}
          />
        </View>

        {/* About Section */}
        <SectionHeader title={t('settings.about')} />
        <View style={[styles.section, { backgroundColor: theme.surface }, presets.hardShadow as ViewStyle]}>
          <SettingRow
            label={t('settings.version')}
            value="1.0.0"
            showChevron={false}
          />
          <SettingRow
            label={t('settings.feedback')}
            onPress={() => {
              // TODO: Open feedback form/email
            }}
          />
          <SettingRow
            label={t('settings.privacy')}
            onPress={() => {
              // TODO: Open privacy policy
            }}
          />
        </View>

        {/* App tagline */}
        <View style={styles.footer}>
          <Icons.Mountain size={32} color={theme.textMuted} />
          <Text style={[styles.footerText, { color: theme.textMuted }]}>
            Bronze
          </Text>
          <Text style={[styles.footerTagline, { color: theme.textMuted }]}>
            {t('app.tagline')}
          </Text>
          <View style={styles.footerSnowflakes}>
            <Icons.Snowflake size={16} color={theme.textMuted} />
            <Icons.Snowflake size={16} color={theme.textMuted} />
            <Icons.Snowflake size={16} color={theme.textMuted} />
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  scrollContent: {
    paddingBottom: spacing.xxxl,
  },
  sectionHeader: {
    paddingHorizontal: spacing.md,
    paddingTop: spacing.xl,
    paddingBottom: spacing.sm,
  },
  sectionTitle: {
    fontSize: typography.fontSize.sm,
    fontWeight: typography.fontWeight.semibold,
    letterSpacing: 0.5,
  },
  section: {
    marginHorizontal: spacing.md,
    borderRadius: sizing.radius.medium,
    overflow: 'hidden',
  },
  settingRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.lg,
    minHeight: sizing.touchTarget.compact,
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  toggleRow: {
    paddingVertical: spacing.md,
  },
  settingLabel: {
    fontSize: typography.fontSize.lg,
    fontWeight: typography.fontWeight.medium,
  },
  settingValue: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
  },
  settingValueText: {
    fontSize: typography.fontSize.md,
  },
  toggleInfo: {
    flex: 1,
    marginRight: spacing.md,
  },
  settingHint: {
    fontSize: typography.fontSize.sm,
    marginTop: spacing.xs,
    lineHeight: typography.fontSize.sm * typography.lineHeight.relaxed,
  },
  languageList: {
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: colors.border,
  },
  languageOption: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.md,
    minHeight: sizing.touchTarget.compact,
  },
  languageName: {
    fontSize: typography.fontSize.md,
    fontWeight: typography.fontWeight.medium,
  },
  languageEnglish: {
    fontSize: typography.fontSize.sm,
  },
  footer: {
    alignItems: 'center',
    paddingVertical: spacing.xxxl,
    gap: spacing.xs,
  },
  footerText: {
    fontSize: typography.fontSize.lg,
    fontWeight: typography.fontWeight.semibold,
  },
  footerTagline: {
    fontSize: typography.fontSize.sm,
  },
  footerSnowflakes: {
    flexDirection: 'row',
    gap: spacing.sm,
    marginTop: spacing.sm,
  },
});
