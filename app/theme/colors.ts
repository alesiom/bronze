/**
 * Neve26 Color Palette
 * Italian flag + winter palette inspired
 */

export const colors = {
  // Primary colors
  alpineGreen: '#008C45',
  snowWhite: '#FFFFFF',
  rossoCorsa: '#CD212A',
  glacierBlue: '#A8D5E5',
  dolomiteNavy: '#1B365D',

  // Semantic colors
  primary: '#008C45',
  secondary: '#A8D5E5',
  accent: '#CD212A',
  background: '#FFFFFF',
  surface: '#F5F9FA',
  text: '#1B365D',
  textSecondary: '#5A6B7D',
  textMuted: '#8A9AAD',

  // Status colors
  success: '#008C45',
  warning: '#F5A623',
  error: '#CD212A',
  info: '#A8D5E5',

  // Medal colors
  gold: '#FFD700',
  silver: '#C0C0C0',
  bronze: '#CD7F32',

  // Sport category colors (for visual distinction)
  sportColors: {
    ALP: '#1B365D', // Alpine Skiing - Dolomite Navy
    BTH: '#008C45', // Biathlon - Alpine Green
    BOB: '#CD212A', // Bobsled - Rosso Corsa
    CCS: '#A8D5E5', // Cross-Country - Glacier Blue
    CUR: '#5A6B7D', // Curling - Slate
    FSK: '#E8B4D4', // Figure Skating - Rose
    FRS: '#4A90A4', // Freestyle - Teal
    IHO: '#1B365D', // Ice Hockey - Navy
    LUG: '#CD212A', // Luge - Red
    NCB: '#008C45', // Nordic Combined - Green
    STK: '#5A6B7D', // Skeleton - Slate
    SKN: '#A8D5E5', // Short Track - Blue
    SJP: '#1B365D', // Ski Jumping - Navy
    SMT: '#4A90A4', // Snowboard - Teal
    SBD: '#4A90A4', // Snowboard (alt code)
    SSK: '#E8B4D4', // Speed Skating - Rose
  },
} as const;

// Dark mode colors
export const darkColors = {
  ...colors,
  background: '#0D1B2A',
  surface: '#1B2838',
  text: '#FFFFFF',
  textSecondary: '#B8C5D6',
  textMuted: '#6B7D8F',
} as const;

export type ColorScheme = typeof colors;
