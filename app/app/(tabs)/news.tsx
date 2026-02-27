/**
 * News Tab - Displays news articles with sport and country filters
 */

import { useState, useMemo } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  Pressable,
  ScrollView,
  useColorScheme,
  RefreshControl,
  ActivityIndicator,
} from 'react-native';
import { useTranslation } from 'react-i18next';
import { SafeAreaView } from 'react-native-safe-area-context';

import { colors, darkColors, spacing, sizing, typography, getContrastText } from '../../theme';
import { useArticles, useFilterOptions } from '../../hooks';
import { SportIcon, ArticleCard } from '../../components';
import type { Article, SportCode } from '../../types';

// NOC (3-letter Olympic) to ISO 3166-1 alpha-2 (2-letter) mapping for flags
const NOC_TO_ISO: Record<string, string> = {
  AUS: 'AU', AUT: 'AT', BEL: 'BE', BLR: 'BY', BRA: 'BR',
  CAN: 'CA', CHN: 'CN', CRO: 'HR', CZE: 'CZ', DEN: 'DK',
  EST: 'EE', FIN: 'FI', FRA: 'FR', GBR: 'GB', GER: 'DE',
  HUN: 'HU', ITA: 'IT', JPN: 'JP', KAZ: 'KZ', KOR: 'KR',
  LAT: 'LV', NED: 'NL', NOR: 'NO', NZL: 'NZ', POL: 'PL',
  ROU: 'RO', RSA: 'ZA', RUS: 'RU', SLO: 'SI', SRB: 'RS',
  SUI: 'CH', SVK: 'SK', SWE: 'SE', UKR: 'UA', USA: 'US',
};

// Convert NOC code to flag emoji
function countryCodeToFlag(code: string): string {
  const upperCode = code.toUpperCase();
  const isoCode = NOC_TO_ISO[upperCode] || (upperCode.length === 2 ? upperCode : null);
  if (!isoCode) return '';

  const base = 0x1F1E6;
  try {
    return isoCode.split('').map((char) => String.fromCodePoint(base + char.charCodeAt(0) - 65)).join('');
  } catch {
    return '';
  }
}

// All sports for filter
const ALL_SPORTS: { code: SportCode; labelKey: string }[] = [
  { code: 'football', labelKey: 'sports.football' },
  { code: 'tennis', labelKey: 'sports.tennis' },
  { code: 'athletics', labelKey: 'sports.athletics' },
  { code: 'cycling', labelKey: 'sports.cycling' },
  { code: 'motorsport', labelKey: 'sports.motorsport' },
  { code: 'winter-sports', labelKey: 'sports.winter-sports' },
  { code: 'swimming', labelKey: 'sports.swimming' },
  { code: 'other', labelKey: 'sports.other' },
];

// Sport filter pill component
function SportPill({
  sport,
  isSelected,
  onPress,
}: {
  sport: { code: SportCode; labelKey: string } | null;
  isSelected: boolean;
  onPress: () => void;
}) {
  const { t } = useTranslation();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  const sportColor = sport ? theme.sportColors[sport.code] : theme.primary;
  const label = sport ? t(sport.labelKey) : t('filters.all');
  const selectedTextColor = getContrastText(sportColor);

  const getPillStyle = (pressed: boolean) => ({
    backgroundColor: isSelected ? sportColor : theme.surface,
    borderColor: sportColor,
    ...(pressed || isSelected
      ? { transform: [{ translateX: 2 }, { translateY: 2 }] as const }
      : {
          shadowColor: sportColor,
          shadowOffset: { width: 2, height: 2 },
          shadowOpacity: 0.6,
          shadowRadius: 0,
          elevation: 3,
        }),
  });

  return (
    <Pressable onPress={onPress}>
      {({ pressed }) => (
        <View style={[styles.sportPill, getPillStyle(pressed)]}>
          {sport && (
            <SportIcon
              sportCode={sport.code}
              size={18}
              color={isSelected ? selectedTextColor : sportColor}
            />
          )}
          <Text
            style={[
              styles.sportPillText,
              { color: isSelected ? selectedTextColor : theme.text },
            ]}
          >
            {label}
          </Text>
        </View>
      )}
    </Pressable>
  );
}

// Sport filter bar
function SportFilterBar({
  selectedSport,
  onSelectSport,
  availableSports,
}: {
  selectedSport: SportCode | null;
  onSelectSport: (sport: SportCode | null) => void;
  availableSports: Set<SportCode>;
}) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  // Show all sports - API uses different codes, filtering handled server-side
  const sportsToShow = ALL_SPORTS;

  return (
    <View style={[styles.filterBar, { backgroundColor: theme.background }]}>
      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.filterScrollContent}
      >
        <SportPill
          sport={null}
          isSelected={selectedSport === null}
          onPress={() => onSelectSport(null)}
        />
        {sportsToShow.map((sport) => (
          <SportPill
            key={sport.code}
            sport={sport}
            isSelected={selectedSport === sport.code}
            onPress={() => onSelectSport(sport.code)}
          />
        ))}
      </ScrollView>
    </View>
  );
}

// Country filter pill
function CountryPill({
  countryCode,
  isSelected,
  onPress,
}: {
  countryCode: string | null;
  isSelected: boolean;
  onPress: () => void;
}) {
  const { t } = useTranslation();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  const flag = countryCode ? countryCodeToFlag(countryCode) : null;

  const getPillStyle = (pressed: boolean) => ({
    backgroundColor: isSelected ? theme.accent : theme.surface,
    borderColor: theme.accent,
    ...(pressed || isSelected
      ? { transform: [{ translateX: 2 }, { translateY: 2 }] as const }
      : {
          shadowColor: theme.accent,
          shadowOffset: { width: 2, height: 2 },
          shadowOpacity: 0.6,
          shadowRadius: 0,
          elevation: 3,
        }),
  });

  return (
    <Pressable onPress={onPress}>
      {({ pressed }) => (
        <View style={[styles.countryPill, getPillStyle(pressed)]}>
          {flag ? (
            <Text style={styles.countryFlag}>{flag}</Text>
          ) : (
            <Text
              style={[
                styles.countryPillText,
                { color: isSelected ? getContrastText(theme.accent) : theme.accent },
              ]}
            >
              {t('filters.all')}
            </Text>
          )}
        </View>
      )}
    </Pressable>
  );
}

// Country filter bar
function CountryFilterBar({
  selectedCountry,
  onSelectCountry,
  availableCountries,
}: {
  selectedCountry: string | null;
  onSelectCountry: (country: string | null) => void;
  availableCountries: string[];
}) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  if (availableCountries.length === 0) {
    return null;
  }

  return (
    <View style={[styles.countryFilterBar, { backgroundColor: theme.background }]}>
      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.filterScrollContent}
      >
        <CountryPill
          countryCode={null}
          isSelected={selectedCountry === null}
          onPress={() => onSelectCountry(null)}
        />
        {availableCountries.map((country) => (
          <CountryPill
            key={country}
            countryCode={country}
            isSelected={selectedCountry === country}
            onPress={() => onSelectCountry(country)}
          />
        ))}
      </ScrollView>
    </View>
  );
}

// Empty state component
function EmptyState() {
  const { t } = useTranslation();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  return (
    <View style={styles.emptyContainer}>
      <Text style={[styles.emptyIcon, { color: theme.textMuted }]}>
        {'📰'}
      </Text>
      <Text style={[styles.emptyTitle, { color: theme.text }]}>
        {t('news.empty')}
      </Text>
      <Text style={[styles.emptyHint, { color: theme.textSecondary }]}>
        {t('news.emptyHint')}
      </Text>
    </View>
  );
}

// Error state component
function ErrorState({ onRetry }: { onRetry: () => void }) {
  const { t } = useTranslation();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  return (
    <View style={styles.emptyContainer}>
      <Text style={[styles.emptyTitle, { color: theme.error }]}>
        {t('news.error')}
      </Text>
      <Pressable
        onPress={onRetry}
        style={[styles.retryButton, { backgroundColor: theme.primary }]}
      >
        <Text style={[styles.retryButtonText, { color: getContrastText(theme.primary) }]}>
          {t('common.retry')}
        </Text>
      </Pressable>
    </View>
  );
}

export default function NewsScreen() {
  const { t } = useTranslation();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  // Filter state
  const [selectedSport, setSelectedSport] = useState<SportCode | null>(null);
  const [selectedCountry, setSelectedCountry] = useState<string | null>(null);

  // Fetch articles with filters
  const { articles, loading, error, refreshing, refresh, loadMore, hasMore } = useArticles({
    sport: selectedSport,
    country: selectedCountry,
  });

  // Get available filter options from schedule data
  const { countries } = useFilterOptions();

  // Compute available sports from articles
  const availableSports = useMemo(() => {
    const sports = new Set<SportCode>();
    for (const article of articles) {
      if (article.sport_code) {
        sports.add(article.sport_code as SportCode);
      }
    }
    return sports;
  }, [articles]);

  // Render article item
  const renderArticle = ({ item }: { item: Article }) => (
    <ArticleCard article={item} />
  );

  // Key extractor
  const keyExtractor = (item: Article) => item.slug;

  // List footer (load more indicator)
  const renderFooter = () => {
    if (!hasMore) return null;
    return (
      <View style={styles.footerLoader}>
        <ActivityIndicator size="small" color={theme.primary} />
      </View>
    );
  };

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top']}>
      {/* Header */}
      <View style={[styles.header, { borderBottomColor: theme.border }]}>
        <Text style={[styles.headerTitle, { color: theme.text }]}>
          {t('news.title')}
        </Text>
      </View>

      {/* Sport filter */}
      <SportFilterBar
        selectedSport={selectedSport}
        onSelectSport={setSelectedSport}
        availableSports={availableSports}
      />

      {/* Country filter */}
      <CountryFilterBar
        selectedCountry={selectedCountry}
        onSelectCountry={setSelectedCountry}
        availableCountries={countries}
      />

      {/* Content */}
      {loading && !refreshing ? (
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color={theme.primary} />
          <Text style={[styles.loadingText, { color: theme.textSecondary }]}>
            {t('news.loading')}
          </Text>
        </View>
      ) : error ? (
        <ErrorState onRetry={refresh} />
      ) : articles.length === 0 ? (
        <EmptyState />
      ) : (
        <FlatList
          data={articles}
          renderItem={renderArticle}
          keyExtractor={keyExtractor}
          contentContainerStyle={styles.listContent}
          refreshControl={
            <RefreshControl
              refreshing={refreshing}
              onRefresh={refresh}
              tintColor={theme.primary}
              colors={[theme.primary]}
            />
          }
          onEndReached={loadMore}
          onEndReachedThreshold={0.3}
          ListFooterComponent={renderFooter}
          showsVerticalScrollIndicator={false}
        />
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  header: {
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.md,
    borderBottomWidth: 1,
  },
  headerTitle: {
    fontSize: typography.fontSize.xxxl,
    fontWeight: typography.fontWeight.bold,
  },
  filterBar: {
    paddingVertical: spacing.sm,
    borderBottomWidth: 0,
  },
  countryFilterBar: {
    paddingTop: spacing.xs,
    paddingBottom: spacing.sm,
  },
  filterScrollContent: {
    paddingHorizontal: spacing.md,
    gap: spacing.sm,
  },
  sportPill: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
    borderRadius: sizing.radius.medium,
    borderWidth: 2,
    gap: spacing.xs,
  },
  sportPillText: {
    fontSize: typography.fontSize.md,
    fontWeight: typography.fontWeight.medium,
  },
  countryPill: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: sizing.radius.medium,
    borderWidth: 2,
    minWidth: 44,
  },
  countryFlag: {
    fontSize: 20,
  },
  countryPillText: {
    fontSize: typography.fontSize.sm,
    fontWeight: typography.fontWeight.medium,
  },
  listContent: {
    paddingVertical: spacing.sm,
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    gap: spacing.md,
  },
  loadingText: {
    fontSize: typography.fontSize.md,
  },
  emptyContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: spacing.xl,
    gap: spacing.md,
  },
  emptyIcon: {
    fontSize: 64,
    marginBottom: spacing.md,
  },
  emptyTitle: {
    fontSize: typography.fontSize.xl,
    fontWeight: typography.fontWeight.semibold,
    textAlign: 'center',
  },
  emptyHint: {
    fontSize: typography.fontSize.md,
    textAlign: 'center',
  },
  retryButton: {
    marginTop: spacing.md,
    paddingHorizontal: spacing.xl,
    paddingVertical: spacing.md,
    borderRadius: sizing.radius.medium,
  },
  retryButtonText: {
    fontSize: typography.fontSize.md,
    fontWeight: typography.fontWeight.semibold,
  },
  footerLoader: {
    paddingVertical: spacing.lg,
    alignItems: 'center',
  },
});
