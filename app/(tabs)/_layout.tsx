import { Tabs } from 'expo-router';
import React from 'react';
import { StyleSheet } from 'react-native';

import { HapticTab } from '@/components/haptic-tab';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors } from '@/constants/theme';
import { useColorScheme } from '@/hooks/use-color-scheme';
import { useThemeColor } from '@/hooks/use-theme-color';
import { MiniPlayer } from '@/components/mini-player';

export default function TabLayout() {
  const colorScheme = useColorScheme();
  const backgroundColor = useThemeColor({}, 'background');
  const iconColor = useThemeColor({}, 'icon');

  return (
    <>
      <Tabs
        screenOptions={{
          tabBarActiveTintColor: Colors[colorScheme ?? 'light'].tint,
          headerShown: false,
          tabBarButton: HapticTab,
          tabBarStyle: {
            paddingBottom: 8,
            paddingTop: 8,
            height: 70,
            backgroundColor: backgroundColor,
            borderTopWidth: 1,
            borderTopColor: iconColor + '20',
          },
          tabBarLabelStyle: {
            fontSize: 11,
            marginTop: 4,
          },
        }}>
        <Tabs.Screen
          name="songs"
          options={{
            title: 'Songs',
            tabBarIcon: ({ color }) => <IconSymbol size={24} name="music.note" color={color} />,
          }}
        />
        <Tabs.Screen
          name="artists"
          options={{
            title: 'Artists',
            tabBarIcon: ({ color }) => <IconSymbol size={24} name="person" color={color} />,
          }}
        />
        <Tabs.Screen
          name="playlists"
          options={{
            title: 'Playlists',
            tabBarIcon: ({ color }) => <IconSymbol size={24} name="list.bullet" color={color} />,
          }}
        />
        <Tabs.Screen
          name="albums"
          options={{
            title: 'Albums',
            tabBarIcon: ({ color }) => <IconSymbol size={24} name="music.note.list" color={color} />,
          }}
        />
        <Tabs.Screen
          name="favourites"
          options={{
            title: 'Favourites',
            tabBarIcon: ({ color }) => <IconSymbol size={24} name="heart" color={color} />,
          }}
        />
      </Tabs>

      <MiniPlayer />
    </>
  );
}
