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

// Map API sport codes to app sport codes
const API_TO_APP_SPORT_CODE: Record<string, SportCode> = {
  'ALP': 'ALP', 'AS': 'ALP', 'BIA': 'BTH', 'BT': 'BTH', 'BTH': 'BTH',
  'BS': 'BOB', 'BOB': 'BOB', 'XC': 'CCS', 'CCS': 'CCS', 'CUR': 'CUR',
  'FS': 'FSK', 'FSK': 'FSK', 'FRS': 'FRS', 'IHO': 'IHO',
  'LG': 'LUG', 'LUG': 'LUG', 'NC': 'NCB', 'NK': 'NCB', 'NCB': 'NCB',
  'STK': 'STK', 'SKN': 'SKN', 'SJ': 'SJP', 'SJP': 'SJP', 'SMT': 'SMT',
  'SB': 'SBD', 'SBD': 'SBD', 'SS': 'SSK', 'SSK': 'SSK',
};

/**
 * Decode HTML entities
 */
function decodeEntities(text: string): string {
  return text
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
}

/**
 * Text segment - plain text, bold, italic, or a link
 */
type TextSegment =
  | { type: 'text'; content: string }
  | { type: 'bold'; content: string }
  | { type: 'italic'; content: string }
  | { type: 'link'; content: string; href: string };

/**
 * Content block types for rendering
 */
type ContentBlock =
  | { type: 'paragraph'; segments: TextSegment[] }
  | { type: 'heading'; text: string };

/**
 * Parse inline content to extract text, bold, italic, and links
 */
function parseInlineContent(html: string): TextSegment[] {
  const segments: TextSegment[] = [];
  // Match <a>, <strong>/<b>, <em>/<i> tags
  const inlineRegex = /<(a)\s+href="([^"]*)"[^>]*>([\s\S]*?)<\/a>|<(strong|b)>([\s\S]*?)<\/\4>|<(em|i)>([\s\S]*?)<\/\6>/gi;

  let lastIndex = 0;
  let match;

  while ((match = inlineRegex.exec(html)) !== null) {
    // Add text before the match
    if (match.index > lastIndex) {
      const textBefore = html.slice(lastIndex, match.index);
      const cleanText = decodeEntities(textBefore.replace(/<[^>]*>/g, '')).replace(/\s+/g, ' ');
      if (cleanText.trim()) {
        segments.push({ type: 'text', content: cleanText });
      }
    }

    if (match[1] === 'a') {
      // Link
      const href = match[2];
      const linkText = decodeEntities(match[3].replace(/<[^>]*>/g, '')).trim();
      if (linkText) {
        segments.push({ type: 'link', content: linkText, href });
      }
    } else if (match[4]) {
      // Bold (<strong> or <b>)
      const boldText = decodeEntities(match[5].replace(/<[^>]*>/g, '')).trim();
      if (boldText) {
        segments.push({ type: 'bold', content: boldText });
      }
    } else if (match[6]) {
      // Italic (<em> or <i>)
      const italicText = decodeEntities(match[7].replace(/<[^>]*>/g, '')).trim();
      if (italicText) {
        segments.push({ type: 'italic', content: italicText });
      }
    }

    lastIndex = match.index + match[0].length;
  }

  // Add remaining text
  if (lastIndex < html.length) {
    const textAfter = html.slice(lastIndex);
    const cleanText = decodeEntities(textAfter.replace(/<[^>]*>/g, '')).replace(/\s+/g, ' ');
    if (cleanText.trim()) {
      segments.push({ type: 'text', content: cleanText });
    }
  }

  // Fallback: if no segments, treat entire content as text
  if (segments.length === 0) {
    const cleanText = decodeEntities(html.replace(/<[^>]*>/g, '')).replace(/\s+/g, ' ').trim();
    if (cleanText) {
      segments.push({ type: 'text', content: cleanText });
    }
  }

  return segments;
}

/**
 * Parse HTML content into structured blocks for rendering
 */
function parseContent(html: string): ContentBlock[] {
  if (!html) return [];

  const blocks: ContentBlock[] = [];

  // Match: <h2>...</h2>, <p>...</p>
  const regex = /<(h[1-6]|p)>([\s\S]*?)<\/\1>/gi;
  let match;

  while ((match = regex.exec(html)) !== null) {
    const tag = match[1].toLowerCase();
    const content = match[2];

    if (tag.startsWith('h')) {
      const text = decodeEntities(content.replace(/<[^>]*>/g, '')).replace(/\s+/g, ' ').trim();
      if (text) {
        blocks.push({ type: 'heading', text });
      }
    } else {
      const segments = parseInlineContent(content);
      if (segments.length > 0) {
        blocks.push({ type: 'paragraph', segments });
      }
    }
  }

  // Fallback: if no blocks found, treat as single paragraph
  if (blocks.length === 0) {
    const segments = parseInlineContent(html);
    if (segments.length > 0) {
      blocks.push({ type: 'paragraph', segments });
    }
  }

  return blocks;
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

  // Map API sport code to app sport code
  const appSportCode = article?.sport_code
    ? API_TO_APP_SPORT_CODE[article.sport_code]
    : null;

  // Sport color for styling
  const sportColor = appSportCode
    ? (theme.sportColors[appSportCode] ?? theme.primary)
    : theme.primary;

  // Handle share
  const handleShare = async () => {
    if (!article) return;

    try {
      await Share.share({
        title: article.title,
        message: `${article.title}\n\nRead more on Bronze`,
        url: `https://bronze.news/article/${article.slug}`,
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
        {appSportCode && (
          <View
            style={[
              styles.sportBadge,
              { backgroundColor: sportColor },
            ]}
          >
            <SportIcon
              sportCode={appSportCode}
              size={18}
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
        <Text style={[styles.title, { color: theme.text }]}>
          {article.title}
        </Text>

        {/* Meta info */}
        <View style={styles.metaRow}>
          <Text style={[styles.publishedDate, { color: theme.textSecondary }]}>
            {formatPublishedDate(article.published_at)}
          </Text>
        </View>

        {/* Divider */}
        <View style={[styles.divider, { backgroundColor: theme.border }]} />

        {/* Article content */}
        <View style={styles.contentContainer}>
          {parseContent(article.content || '').map((block, index) => {
            if (block.type === 'heading') {
              return (
                <Text
                  key={index}
                  style={[styles.sectionHeading, { color: theme.text }]}
                >
                  {block.text}
                </Text>
              );
            }
            // Paragraph with inline formatting
            return (
              <Text
                key={index}
                style={[styles.paragraph, { color: theme.text }]}
              >
                {block.segments.map((segment, i) => {
                  if (segment.type === 'bold') {
                    return <Text key={i} style={{ fontWeight: '700' }}>{segment.content}</Text>;
                  }
                  if (segment.type === 'italic') {
                    return <Text key={i} style={{ fontStyle: 'italic' }}>{segment.content}</Text>;
                  }
                  return segment.content;
                })}
              </Text>
            );
          })}
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
    gap: spacing.lg,
  },
  sectionHeading: {
    fontSize: typography.fontSize.xl,
    fontWeight: typography.fontWeight.bold,
    lineHeight: typography.fontSize.xl * typography.lineHeight.tight,
    marginTop: spacing.md,
  },
  paragraph: {
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
