/**
 * Theme configuration for Pillow app
 */

import { Platform } from 'react-native';
import { PillowColors } from './colors';

const tintColorLight = PillowColors.green;
const tintColorDark = PillowColors.lemon;

export const Colors = {
  light: {
    text: PillowColors.darkGrey,
    background: PillowColors.lightGrey,
    tint: tintColorLight,
    icon: PillowColors.darkGrey,
    tabIconDefault: PillowColors.darkGrey,
    tabIconSelected: tintColorLight,
    card: PillowColors.white,
    border: '#E0E0E0',
    accent: PillowColors.green,
    secondary: PillowColors.lemon,
  },
  dark: {
    text: PillowColors.lightGrey,
    background: '#1A1A1A',
    tint: tintColorDark,
    icon: PillowColors.lightGrey,
    tabIconDefault: PillowColors.lightGrey,
    tabIconSelected: tintColorDark,
    card: '#2A2A2A',
    border: '#404040',
    accent: PillowColors.green,
    secondary: PillowColors.lemon,
  },
};

export const Fonts = Platform.select({
  ios: {
    sans: 'system-ui',
    serif: 'ui-serif',
    rounded: 'ui-rounded',
    mono: 'ui-monospace',
  },
  default: {
    sans: 'normal',
    serif: 'serif',
    rounded: 'normal',
    mono: 'monospace',
  },
  web: {
    sans: "system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif",
    serif: "Georgia, 'Times New Roman', serif",
    rounded: "'SF Pro Rounded', 'Hiragino Maru Gothic ProN', Meiryo, 'MS PGothic', sans-serif",
    mono: "SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace",
  },
});

export const Spacing = {
  xs: 4,
  sm: 8,
  md: 16,
  lg: 24,
  xl: 32,
  xxl: 48,
};

export const BorderRadius = {
  sm: 4,
  md: 8,
  lg: 12,
  xl: 16,
  round: 999,
};
