/**
 * Below are the colors that are used in the app. The colors are defined in the light and dark mode.
 */

import { Platform } from 'react-native';

const tintColorLight = '#FF6B6B'; // Changed to a warmer red/pink for music app
const tintColorDark = '#FF8E8E';

export const Colors = {
  light: {
    text: '#2D3436',
    background: '#FFFFFF',
    tint: tintColorLight,
    icon: '#636E72',
    tabIconDefault: '#B2BEC3',
    tabIconSelected: tintColorLight,
  },
  dark: {
    text: '#F5F6FA',
    background: '#1E272E',
    tint: tintColorDark,
    icon: '#A5B1C2',
    tabIconDefault: '#4B6584',
    tabIconSelected: tintColorDark,
  },
};

export const Fonts = Platform.select({
  ios: {
    /** iOS `UIFontDescriptorSystemDesignDefault` */
    sans: 'system-ui',
    /** iOS `UIFontDescriptorSystemDesignSerif` */
    serif: 'ui-serif',
    /** iOS `UIFontDescriptorSystemDesignRounded` */
    rounded: 'ui-rounded',
    /** iOS `UIFontDescriptorSystemDesignMonospaced` */
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
