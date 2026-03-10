// Updated with music player icons mapping

import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import { SymbolWeight, SymbolViewProps } from 'expo-symbols';
import { ComponentProps } from 'react';
import { OpaqueColorValue, type StyleProp, type TextStyle } from 'react-native';

type IconMapping = Record<SymbolViewProps['name'], ComponentProps<typeof MaterialIcons>['name']>;
type IconSymbolName = keyof typeof MAPPING;

/**
 * Add your SF Symbols to Material Icons mappings here.
 * - see Material Icons in the [Icons Directory](https://icons.expo.fyi).
 * - see SF Symbols in the [SF Symbols](https://developer.apple.com/sf-symbols/) app.
 */
const MAPPING = {
  // Navigation icons
  'house.fill': 'home',
  'paperplane.fill': 'send',
  
  // Music player icons
  'play.fill': 'play-arrow',
  'pause.fill': 'pause',
  'forward.fill': 'fast-forward',
  'backward.fill': 'fast-rewind',
  'forward.end.fill': 'skip-next',
  'backward.end.fill': 'skip-previous',
  'shuffle': 'shuffle',
  'repeat': 'repeat',
  'repeat.1': 'repeat-one',
  'heart.fill': 'favorite',
  'heart': 'favorite-border',
  'plus.circle.fill': 'add-circle',
  'minus.circle': 'remove-circle',
  'ellipsis': 'more-horiz',
  'ellipsis.circle': 'more-vert',
  'music.note': 'music-note',
  'music.note.list': 'library-music',
  'list.bullet': 'playlist-play',
  'arrow.down.circle': 'file-download',
  'arrow.up.circle': 'file-upload',
  'clock': 'access-time',
  'trash': 'delete',
  'square.and.arrow.up': 'share',
  'chevron.right': 'chevron-right',
  'chevron.left': 'chevron-left',
  'chevron.up': 'chevron-up',
  'chevron.down': 'chevron-down',
  'speaker.wave.2': 'volume-up',
  'speaker.slash': 'volume-off',
  'headphones': 'headset',
  'airplayaudio': 'airplay',
  'dot.radiowaves.left.and.right': 'cast',
  'magnifyingglass': 'search',
  'gear': 'settings',
  'person': 'person',
  'person.crop.circle': 'account-circle',
} as IconMapping;

/**
 * An icon component that uses native SF Symbols on iOS, and Material Icons on Android and web.
 * This ensures a consistent look across platforms, and optimal resource usage.
 * Icon `name`s are based on SF Symbols and require manual mapping to Material Icons.
 */
export function IconSymbol({
  name,
  size = 24,
  color,
  style,
}: {
  name: IconSymbolName;
  size?: number;
  color: string | OpaqueColorValue;
  style?: StyleProp<TextStyle>;
  weight?: SymbolWeight;
}) {
  return <MaterialIcons color={color} size={size} name={MAPPING[name]} style={style} />;
}
