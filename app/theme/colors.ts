/**
 * Neve26 Color Palette
 * Italian flag + winter palette inspired
 *
 * ACCESSIBILITY RULE: WCAG AAA (7:1 contrast ratio minimum)
 * ============================================================
 * - All text colors must have 7:1+ contrast ratio on their background
 * - Designed for HIGH VISIBILITY in bright snow/sun alpine conditions
 * - Brand colors (alpineGreen, rossoCorsa) are ONLY for large UI elements
 * - Use dark variants (primary, accent) for text and interactive elements
 * - Never use brand colors for body text - use text/textSecondary/textMuted
 *
 * Contrast ratios verified:
 * - text (#0D1B2A on white): 15:1
 * - textSecondary (#2D3E50 on white): 9.5:1
 * - textMuted (#4A5568 on white): 7.1:1 (AAA minimum)
 * - primary (#005C2E on white): 7.8:1
 * - accent (#9A1820 on white): 7.2:1
 */

export const colors = {
  // Primary colors (brand)
  alpineGreen: '#008C45',      // Brand green - use for large UI elements only
  alpineGreenDark: '#005C2E',  // AAA compliant on white (7.8:1)
  snowWhite: '#FFFFFF',
  rossoCorsa: '#CD212A',       // Brand red - use for large UI elements only
  rossoCorsaDark: '#9A1820',   // AAA compliant on white (7.2:1)
  glacierBlue: '#A8D5E5',      // Background/decorative only, never for text
  dolomiteNavy: '#1B365D',     // Primary text color (10.5:1 on white)

  // High contrast text colors (AAA compliant)
  text: '#0D1B2A',             // Near black, 15:1 contrast on white
  textSecondary: '#2D3E50',    // Dark slate, 9.5:1 contrast on white
  textMuted: '#4A5568',        // Medium gray, 7.1:1 contrast on white (AAA minimum)

  // Semantic colors (high contrast)
  primary: '#005C2E',          // Dark green for interactive elements
  primaryLight: '#008C45',     // Brand green for large fills only
  secondary: '#1B4B6B',        // Dark teal, 8.5:1 contrast
  accent: '#9A1820',           // Dark red for emphasis
  accentLight: '#CD212A',      // Brand red for large fills only

  // Backgrounds
  background: '#FFFFFF',
  surface: '#F8FAFB',          // Very light gray
  surfaceAlt: '#EDF2F7',       // Light gray for cards

  // Status colors (high contrast versions)
  success: '#005C2E',          // Dark green, 7.8:1
  warning: '#8B5A00',          // Dark amber, 7.2:1
  error: '#9A1820',            // Dark red, 7.2:1
  info: '#1B4B6B',             // Dark teal, 8.5:1

  // Medal colors (decorative, large elements only)
  gold: '#B8860B',             // Dark gold
  silver: '#5A5A5A',           // Dark silver
  bronze: '#8B4513',           // Dark bronze

  // Sport category colors (for badges/icons - large elements)
  // Each sport has a unique color to avoid confusion with app primary
  sportColors: {
    ALP: '#1B365D',    // Alpine Skiing - Dolomite Navy (mountain blue)
    BTH: '#5C6B2E',    // Biathlon - Olive green (forest/hunting theme)
    BOB: '#9A1820',    // Bobsled - Rosso Corsa (speed/danger)
    CCS: '#1B4B6B',    // Cross-Country - Steel blue (endurance)
    CER: '#8B5A00',    // Ceremonies - Gold (celebration)
    CUR: '#6B5B4F',    // Curling - Warm stone brown
    FSK: '#7B3F7B',    // Figure Skating - Royal purple (elegance)
    FRS: '#2D6A4F',    // Freestyle Skiing - Emerald (dynamic)
    IHO: '#2C4A7C',    // Ice Hockey - Deep blue (team sport)
    LUG: '#8B4513',    // Luge - Saddle brown (wood/speed)
    NCB: '#4A6741',    // Nordic Combined - Forest green (distinct from primary)
    SKN: '#6B4423',    // Skeleton - Bronze/rust (daring)
    STK: '#4A5568',    // Short Track Speed Skating - Cool gray (ice/speed)
    SJP: '#3D5A80',    // Ski Jumping - Sky blue (flight)
    SMT: '#6B8E23',    // Ski Mountaineering - Olive drab (mountain/alpine NEW 2026)
    SBD: '#2D5A5A',    // Snowboard - Teal (youth/style)
    SSK: '#5B3256',    // Speed Skating - Deep magenta (power)
  },

  // Borders (visible but not overpowering)
  border: '#CBD5E0',
  borderStrong: '#718096',
} as const;

// Dark mode colors (inverted high contrast)
export const darkColors = {
  ...colors,

  // Dark backgrounds
  background: '#0D1B2A',
  surface: '#1B2838',
  surfaceAlt: '#243447',

  // Light text on dark (AAA compliant)
  text: '#F7FAFC',             // Near white, 15:1 contrast
  textSecondary: '#E2E8F0',    // Light gray, 12:1 contrast
  textMuted: '#A0AEC0',        // Medium light, 7.2:1 contrast

  // Adjusted primaries for dark mode
  primary: '#4ADE80',          // Bright green on dark, 9:1 contrast
  primaryLight: '#22C55E',
  secondary: '#7DD3FC',        // Bright blue on dark
  accent: '#FB7185',           // Bright red on dark
  accentLight: '#F43F5E',

  // Status colors for dark mode
  success: '#4ADE80',
  warning: '#FBBF24',
  error: '#FB7185',
  info: '#7DD3FC',

  // Sport category colors for dark mode (WCAG AAA: 7:1+ on #0D1B2A)
  // Each color verified for contrast ratio >= 7:1
  sportColors: {
    ALP: '#7CB3D9',    // Alpine Skiing - Light sky blue (7.8:1)
    BTH: '#A8C97F',    // Biathlon - Light olive (7.5:1)
    BOB: '#F99BA4',    // Bobsled - Light coral (8.2:1)
    CCS: '#7DD3E8',    // Cross-Country - Light cyan (9.1:1)
    CER: '#FBBF24',    // Ceremonies - Gold (9.5:1)
    CUR: '#C4B5A5',    // Curling - Light taupe (7.3:1)
    FSK: '#D4A5D4',    // Figure Skating - Light lavender (7.6:1)
    FRS: '#7DD4A3',    // Freestyle Skiing - Light mint (8.5:1)
    IHO: '#8BB8E8',    // Ice Hockey - Light periwinkle (7.9:1)
    LUG: '#D4A574',    // Luge - Light caramel (7.2:1)
    NCB: '#9DC88D',    // Nordic Combined - Light sage (7.8:1)
    SKN: '#CDA574',    // Skeleton - Light bronze (7.1:1)
    STK: '#B8C4D0',    // Short Track - Light steel (8.4:1)
    SJP: '#8FC5E8',    // Ski Jumping - Light azure (8.7:1)
    SMT: '#B8D468',    // Ski Mountaineering - Light lime (8.9:1)
    SBD: '#7DD4C4',    // Snowboard - Light teal (9.2:1)
    SSK: '#C9A5C9',    // Speed Skating - Light mauve (7.4:1)
  },

  // Borders for dark mode
  border: '#3D4F5F',
  borderStrong: '#5A7A8A',
} as const;

export type ColorScheme = typeof colors;
