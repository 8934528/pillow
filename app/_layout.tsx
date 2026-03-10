import { DarkTheme, DefaultTheme, ThemeProvider } from '@react-navigation/native';
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import 'react-native-reanimated';

import { useColorScheme } from '@/hooks/use-color-scheme';
import { CurrentSongProvider } from '@/hooks/use-current-song';

export const unstable_settings = {
  initialRouteName: '(tabs)',
};

export default function RootLayout() {
  const colorScheme = useColorScheme();

  return (
    <ThemeProvider value={colorScheme === 'dark' ? DarkTheme : DefaultTheme}>
      <CurrentSongProvider>
        <Stack>
          <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
          <Stack.Screen 
            name="now-playing" 
            options={{ 
              presentation: 'card',
              headerShown: false,
              animation: 'slide_from_bottom',
            }} 
          />
          <Stack.Screen 
            name="queue" 
            options={{ 
              presentation: 'modal',
              headerShown: false,
              animation: 'slide_from_bottom',
            }} 
          />
        </Stack>
        <StatusBar style="auto" />
      </CurrentSongProvider>
    </ThemeProvider>
  );
}
