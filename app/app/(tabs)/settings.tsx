import { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Switch,
  useColorScheme,
} from 'react-native';
import { useTranslation } from 'react-i18next';
import { SafeAreaView } from 'react-native-safe-area-context';

import { colors, darkColors, spacing, sizing, typography } from '../../theme';
import { supportedLanguages, type LanguageCode } from '../../i18n';
import i18n from '../../i18n';

type ThemeMode = 'light' | 'dark' | 'system';

function SettingRow({
  label,
  value,
  onPress,
  showChevron = true,
}: {
  label: string;
  value?: string;
  onPress?: () => void;
  showChevron?: boolean;
}) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  return (
    <TouchableOpacity
      style={[styles.settingRow, { borderBottomColor: isDark ? '#2A3A4A' : '#E5E5E5' }]}
      onPress={onPress}
      activeOpacity={onPress ? 0.7 : 1}
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
          <Text style={[styles.chevron, { color: theme.textMuted }]}>›</Text>
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
    <View style={[styles.settingRow, styles.toggleRow, { borderBottomColor: isDark ? '#2A3A4A' : '#E5E5E5' }]}>
      <View style={styles.toggleInfo}>
        <Text style={[styles.settingLabel, { color: theme.text }]}>{label}</Text>
        {hint && (
          <Text style={[styles.settingHint, { color: theme.textMuted }]}>{hint}</Text>
        )}
      </View>
      <Switch
        value={value}
        onValueChange={onValueChange}
        trackColor={{ false: '#767577', true: colors.alpineGreen }}
        thumbColor={value ? colors.snowWhite : '#f4f3f4'}
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

  const [themeMode, setThemeMode] = useState<ThemeMode>('system');
  const [comfortMode, setComfortMode] = useState(true);
  const [notifyChanges, setNotifyChanges] = useState(true);
  const [showLanguagePicker, setShowLanguagePicker] = useState(false);

  const currentLanguage = supportedLanguages.find((l) => l.code === i18n.language);

  const handleLanguageChange = (code: LanguageCode) => {
    i18n.changeLanguage(code);
    setShowLanguagePicker(false);
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
    <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['left', 'right']}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        {/* Appearance Section */}
        <SectionHeader title={t('settings.appearance')} />
        <View style={[styles.section, { backgroundColor: theme.surface }]}>
          <SettingRow
            label={t('settings.theme')}
            value={getThemeLabel(themeMode)}
            onPress={() => {
              // Cycle through themes
              const modes: ThemeMode[] = ['system', 'light', 'dark'];
              const currentIndex = modes.indexOf(themeMode);
              setThemeMode(modes[(currentIndex + 1) % modes.length]);
            }}
          />
        </View>

        {/* Display Section */}
        <SectionHeader title={t('settings.display')} />
        <View style={[styles.section, { backgroundColor: theme.surface }]}>
          <SettingToggle
            label={t('settings.comfortMode')}
            hint={t('settings.comfortModeHint')}
            value={comfortMode}
            onValueChange={setComfortMode}
          />
        </View>

        {/* Language Section */}
        <SectionHeader title={t('settings.language')} />
        <View style={[styles.section, { backgroundColor: theme.surface }]}>
          <SettingRow
            label={t('settings.language')}
            value={currentLanguage?.nativeName ?? 'English'}
            onPress={() => setShowLanguagePicker(!showLanguagePicker)}
          />
          {showLanguagePicker && (
            <View style={styles.languageList}>
              {supportedLanguages.map((lang) => (
                <TouchableOpacity
                  key={lang.code}
                  style={[
                    styles.languageOption,
                    i18n.language === lang.code && {
                      backgroundColor: colors.alpineGreen + '20',
                    },
                  ]}
                  onPress={() => handleLanguageChange(lang.code)}
                >
                  <Text
                    style={[
                      styles.languageName,
                      { color: theme.text },
                      i18n.language === lang.code && { color: colors.alpineGreen },
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
        <View style={[styles.section, { backgroundColor: theme.surface }]}>
          <SettingToggle
            label={t('settings.notifyChanges')}
            hint={t('settings.notifyChangesHint')}
            value={notifyChanges}
            onValueChange={setNotifyChanges}
          />
        </View>

        {/* About Section */}
        <SectionHeader title={t('settings.about')} />
        <View style={[styles.section, { backgroundColor: theme.surface }]}>
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
          <Text style={[styles.footerText, { color: theme.textMuted }]}>
            Neve26
          </Text>
          <Text style={[styles.footerTagline, { color: theme.textMuted }]}>
            {t('app.tagline')}
          </Text>
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
  chevron: {
    fontSize: typography.fontSize.xxl,
    fontWeight: typography.fontWeight.normal,
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
    borderTopColor: '#E5E5E5',
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
});
