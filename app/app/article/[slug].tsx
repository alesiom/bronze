/**
 * Article Detail Screen
 * Displays a full news article
 */

import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  Pressable,
  Share,
  useColorScheme,
  ActivityIndicator,
} from 'react-native';
import { useLocalSearchParams, useRouter, Stack } from 'expo-router';
import { useTranslation } from 'react-i18next';
import { SafeAreaView } from 'react-native-safe-area-context';

import { colors, darkColors, spacing, sizing, typography, getContrastText } from '../../theme';
import { useArticle } from '../../hooks';
import { SportIcon, Icons } from '../../components';
import type { SportCode } from '../../types';

/**
 * Strip HTML tags and decode entities for plain text display
 */
function stripHtml(html: string): string {
  // Remove HTML tags
  let text = html.replace(/<[^>]*>/g, '');
  // Decode common HTML entities
  text = text
    .replace(/&nbsp;/g, ' ')
    .replace(/&amp;/g, '&')
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&quot;/g, '"')
    .replace(/&#39;/g, "'")
    .replace(/&rsquo;/g, "'")
    .replace(/&lsquo;/g, "'")
    .replace(/&rdquo;/g, '"')
    .replace(/&ldquo;/g, '"')
    .replace(/&mdash;/g, '\u2014')
    .replace(/&ndash;/g, '\u2013');
  // Normalize whitespace
  text = text.replace(/\s+/g, ' ').trim();
  return text;
}

// Format article date for display
function formatPublishedDate(dateStr: string): string {
  const date = new Date(dateStr);
  return date.toLocaleDateString(undefined, {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });
}

// Back button component
function BackButton({ onPress }: { onPress: () => void }) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  return (
    <Pressable onPress={onPress} style={styles.backButton}>
      <Icons.ChevronLeft size={24} color={theme.text} />
    </Pressable>
  );
}

// Share button component
function ShareButton({ onPress }: { onPress: () => void }) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;

  return (
    <Pressable onPress={onPress} style={styles.shareButton}>
      <Icons.Share size={20} color={theme.text} />
    </Pressable>
  );
}

export default function ArticleDetailScreen() {
  const { slug } = useLocalSearchParams<{ slug: string }>();
  const router = useRouter();
  const { t } = useTranslation();
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const theme = isDark ? darkColors : colors;
  // Fetch article
  const { article, loading, error } = useArticle(slug ?? '');

  // Sport color for styling
  const sportColor = article?.sport_code
    ? theme.sportColors[article.sport_code as SportCode]
    : theme.primary;

  // Handle share
  const handleShare = async () => {
    if (!article) return;

    try {
      await Share.share({
        title: article.title,
        message: `${article.title}\n\nRead more on Neve26`,
        url: `https://neve26.com/articles/${article.slug}`,
      });
    } catch {
      // User cancelled or error
    }
  };

  // Handle back navigation
  const handleBack = () => {
    router.back();
  };

  // Loading state
  if (loading) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]}>
        <Stack.Screen options={{ headerShown: false }} />
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color={theme.primary} />
        </View>
      </SafeAreaView>
    );
  }

  // Error state
  if (error || !article) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]}>
        <Stack.Screen options={{ headerShown: false }} />
        <View style={styles.header}>
          <BackButton onPress={handleBack} />
        </View>
        <View style={styles.errorContainer}>
          <Text style={[styles.errorText, { color: theme.error }]}>
            {t('news.error')}
          </Text>
          <Pressable
            onPress={handleBack}
            style={[styles.retryButton, { backgroundColor: theme.primary }]}
          >
            <Text style={[styles.retryButtonText, { color: getContrastText(theme.primary) }]}>
              {t('common.retry')}
            </Text>
          </Pressable>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top']}>
      <Stack.Screen options={{ headerShown: false }} />

      {/* Header */}
      <View style={[styles.header, { borderBottomColor: theme.border }]}>
        <BackButton onPress={handleBack} />
        <View style={styles.headerActions}>
          <ShareButton onPress={handleShare} />
        </View>
      </View>

      <ScrollView
        style={styles.scrollView}
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}
      >
        {/* Sport badge */}
        {article.sport_code && (
          <View
            style={[
              styles.sportBadge,
              { backgroundColor: sportColor },
            ]}
          >
            <SportIcon
              sportCode={article.sport_code as SportCode}
              size={18}
              color={getContrastText(sportColor)}
            />
            <Text
              style={[
                styles.sportBadgeText,
                { color: getContrastText(sportColor) },
              ]}
            >
              {t(`sports.${article.sport_code}`)}
            </Text>
          </View>
        )}

        {/* Title */}
        <Text style={[styles.title, { color: theme.text }]}>
          {article.title}
        </Text>

        {/* Meta info */}
        <View style={styles.metaRow}>
          <Text style={[styles.publishedDate, { color: theme.textSecondary }]}>
            {formatPublishedDate(article.published_at)}
          </Text>
          <Text style={[styles.metaSeparator, { color: theme.textMuted }]}>
            {' \u2022 '}
          </Text>
          <Text style={[styles.readingTime, { color: theme.textSecondary }]}>
            {t('article.readingTime', { minutes: article.reading_time_minutes })}
          </Text>
        </View>

        {/* Divider */}
        <View style={[styles.divider, { backgroundColor: theme.border }]} />

        {/* Article content */}
        <View style={styles.contentContainer}>
          <Text style={[styles.contentText, { color: theme.text }]}>
            {stripHtml(article.content)}
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
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.sm,
    borderBottomWidth: 1,
  },
  headerActions: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
  },
  backButton: {
    width: 44,
    height: 44,
    alignItems: 'center',
    justifyContent: 'center',
  },
  shareButton: {
    width: 44,
    height: 44,
    alignItems: 'center',
    justifyContent: 'center',
  },
  scrollView: {
    flex: 1,
  },
  scrollContent: {
    padding: spacing.md,
    paddingBottom: spacing.xxxl,
  },
  sportBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    alignSelf: 'flex-start',
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs,
    borderRadius: sizing.radius.small,
    marginBottom: spacing.md,
    gap: spacing.xs,
  },
  sportBadgeText: {
    fontSize: typography.fontSize.sm,
    fontWeight: typography.fontWeight.medium,
  },
  title: {
    fontSize: typography.fontSize.xxxl,
    fontWeight: typography.fontWeight.bold,
    lineHeight: typography.fontSize.xxxl * typography.lineHeight.tight,
    marginBottom: spacing.md,
  },
  metaRow: {
    flexDirection: 'row',
    alignItems: 'center',
    flexWrap: 'wrap',
    marginBottom: spacing.md,
  },
  publishedDate: {
    fontSize: typography.fontSize.md,
  },
  metaSeparator: {
    fontSize: typography.fontSize.md,
  },
  readingTime: {
    fontSize: typography.fontSize.md,
  },
  divider: {
    height: 1,
    marginVertical: spacing.md,
  },
  contentContainer: {
    flex: 1,
  },
  contentText: {
    fontSize: typography.fontSize.lg,
    lineHeight: typography.fontSize.lg * typography.lineHeight.relaxed,
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  errorContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: spacing.xl,
    gap: spacing.md,
  },
  errorText: {
    fontSize: typography.fontSize.xl,
    fontWeight: typography.fontWeight.semibold,
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
});
