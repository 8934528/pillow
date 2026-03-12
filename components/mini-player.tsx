import React, { useState } from 'react';
import { StyleSheet, TouchableOpacity } from 'react-native';
import { Link } from 'expo-router';

import { ThemedView } from './themed-view';
import { ThemedText } from './themed-text';
import { IconSymbol } from './ui/icon-symbol';
import { useThemeColor } from '@/hooks/use-theme-color';

export function MiniPlayer() {
  const [isPlaying, setIsPlaying] = useState(false);
  const iconColor = useThemeColor({}, 'icon');
  const tintColor = useThemeColor({}, 'tint');
  
  // Mock current song
  const currentSong = {
    id: 1,
    title: 'Bohemian Rhapsody',
    artist: 'Queen',
  };

  if (!currentSong) return null;

  return (
    <Link href="/now-playing" asChild>
      <TouchableOpacity activeOpacity={0.9}>
        <ThemedView style={[styles.miniPlayer, { 
          backgroundColor: tintColor + '15',
          borderColor: iconColor + '30',
        }]}>
          <ThemedView style={styles.songInfo}>
            <ThemedView style={[styles.nowPlayingIndicator, { backgroundColor: tintColor }]} />
            <ThemedView>
              <ThemedText type="defaultSemiBold" style={styles.songTitle} numberOfLines={1}>
                {currentSong.title}
              </ThemedText>
              <ThemedText style={styles.artistName} numberOfLines={1}>
                {currentSong.artist}
              </ThemedText>
            </ThemedView>
          </ThemedView>
          
          <ThemedView style={styles.controls}>
            <TouchableOpacity 
              style={styles.controlButton}
              onPress={(e) => {
                e.stopPropagation();
                setIsPlaying(!isPlaying);
              }}>
              <IconSymbol 
                name={isPlaying ? "pause.fill" : "play.fill"} 
                size={22} 
                color={tintColor} 
              />
            </TouchableOpacity>
            <TouchableOpacity 
              style={styles.controlButton}
              onPress={(e) => {
                e.stopPropagation();
                // Next song functionality would go here
              }}>
              <IconSymbol name="forward.end.fill" size={20} color={tintColor} />
            </TouchableOpacity>
          </ThemedView>
        </ThemedView>
      </TouchableOpacity>
    </Link>
  );
}

const styles = StyleSheet.create({
  miniPlayer: {
    position: 'absolute',
    bottom: 80,
    left: 16,
    right: 16,
    height: 64,
    borderRadius: 32,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 16,
    borderWidth: 1,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 3.84,
    elevation: 5,
  },
  songInfo: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    flex: 1,
  },
  nowPlayingIndicator: {
    width: 8,
    height: 8,
    borderRadius: 4,
  },
  songTitle: {
    fontSize: 15,
    marginBottom: 2,
    maxWidth: 150,
  },
  artistName: {
    fontSize: 12,
    opacity: 0.7,
    maxWidth: 150,
  },
  controls: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  controlButton: {
    padding: 6,
  },
});
