/**
 * ArticleCard component
 * Displays a news article preview with sport category and reading time
 */

import {
  View,
  Text,
  StyleSheet,
  Pressable,
  useColorScheme,
} from 'react-native';
import { useTranslation } from 'react-i18next';
import { useRouter } from 'expo-router';

import { colors, darkColors, spacing, sizing, typography, getContrastText } from '../theme';
import { SportIcon } from './SportIcon';
import type { Article } from '../types';
import { normalizeSportCode } from '../types';

interface ArticleCardProps {
  article: Article;
}

/**
 * Format relative time for article (e.g., "2h ago", "Yesterday")
 */
function formatArticleDate(dateStr: string, t: (key: string, options?: Record<string, unknown>) => string): string {
  const date = new Date(dateStr);
  const now = new Date();
  const diffMs = now.getTime() - date.getTime();
  const diffHours = Math.floor(diffMs / (1000 * 60 * 60));
  const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));

  if (diffHours < 1) {
    return t('time.justNow');
  }
  if (diffHours < 24) {
    return t('time.hoursAgo', { count: diffHours });
  }
  if (diffDays === 1) {
    return t('time.yesterday');
  }
  if (diffDays < 7) {
    return t('time.daysAgo', { count: diffDays });
  }

  // Format as date for older articles
  return date.toLocaleDateString(undefined, {
    month: 'short',
    day: 'numeric',
  });
}

export function ArticleCard({ article }: ArticleCardProps) {
  const { t } = useTranslation();
  const colorScheme = useColorScheme();
  const router = useRouter();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  // Normalise API sport code (handles legacy 3-letter codes too)
  const appSportCode = article.sport_code
    ? normalizeSportCode(article.sport_code)
    : null;

  const sportColor = appSportCode
    ? (theme.sportColors[appSportCode] ?? theme.primary)
    : theme.primary;

  const handlePress = () => {
    router.push(`/article/${article.slug}`);
  };

  return (
    <Pressable onPress={handlePress}>
      {({ pressed }) => (
        <View
          style={[
            styles.card,
            {
              backgroundColor: theme.surface,
              borderColor: theme.border,
              opacity: pressed ? 0.8 : 1,
              transform: pressed ? [{ scale: 0.98 }] : [{ scale: 1 }],
            },
          ]}
        >
          {/* Sport badge */}
          {appSportCode && (
            <View
              style={[
                styles.sportBadge,
                { backgroundColor: sportColor },
              ]}
            >
              <SportIcon
                sportCode={appSportCode}
                size={16}
                color={getContrastText(sportColor)}
              />
              <Text
                style={[
                  styles.sportBadgeText,
                  { color: getContrastText(sportColor) },
                ]}
              >
                {t(`sports.${appSportCode}`)}
              </Text>
            </View>
          )}

          {/* Title */}
          <Text
            style={[styles.title, { color: theme.text }]}
            numberOfLines={2}
          >
            {article.title}
          </Text>

          {/* Excerpt */}
          <Text
            style={[styles.excerpt, { color: theme.textSecondary }]}
            numberOfLines={2}
          >
            {article.excerpt}
          </Text>

          {/* Footer: date */}
          <View style={styles.footer}>
            <Text style={[styles.meta, { color: theme.textMuted }]}>
              {formatArticleDate(article.published_at, t)}
            </Text>
          </View>
        </View>
      )}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  card: {
    borderWidth: 1,
    borderRadius: sizing.radius.large,
    padding: spacing.md,
    marginHorizontal: spacing.md,
    marginVertical: spacing.sm,
  },
  sportBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    alignSelf: 'flex-start',
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: sizing.radius.small,
    marginBottom: spacing.sm,
    gap: spacing.xs,
  },
  sportBadgeText: {
    fontSize: typography.fontSize.sm,
    fontWeight: typography.fontWeight.medium,
  },
  title: {
    fontSize: typography.fontSize.xl,
    fontWeight: typography.fontWeight.bold,
    lineHeight: typography.fontSize.xl * typography.lineHeight.tight,
    marginBottom: spacing.xs,
  },
  excerpt: {
    fontSize: typography.fontSize.md,
    lineHeight: typography.fontSize.md * typography.lineHeight.normal,
    marginBottom: spacing.sm,
  },
  footer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  meta: {
    fontSize: typography.fontSize.sm,
  },
});
