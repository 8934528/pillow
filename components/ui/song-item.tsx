import React from 'react';
import { StyleSheet, TouchableOpacity, View } from 'react-native';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { Song } from '@/types/music';
import { PillowColors, GradientColors } from '@/constants/colors';
import { LinearGradient } from 'expo-linear-gradient';
import Animated, { FadeIn, FadeOut } from 'react-native-reanimated';

interface SongItemProps {
  song: Song;
  onPress: (song: Song) => void;
  onOptionsPress?: (song: Song) => void;
  isPlaying?: boolean;
}

export function SongItem({ song, onPress, onOptionsPress, isPlaying }: SongItemProps) {
  const formatDuration = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  return (
    <Animated.View
      entering={FadeIn}
      exiting={FadeOut}
    >
      <TouchableOpacity
        style={styles.container}
        onPress={() => onPress(song)}
        activeOpacity={0.7}
      >
        <LinearGradient
          colors={isPlaying ? GradientColors.player : ['transparent', 'transparent']}
          style={styles.gradient}
          start={{ x: 0, y: 0 }}
          end={{ x: 1, y: 0 }}
        />
        
        <View style={styles.artworkContainer}>
          <View style={styles.artworkPlaceholder}>
            <ThemedText style={styles.artworkText}>🎵</ThemedText>
          </View>
        </View>

        <View style={styles.info}>
          <ThemedText 
            style={[styles.title, isPlaying && styles.playingText]} 
            numberOfLines={1}
          >
            {song.title}
          </ThemedText>
          <ThemedText style={styles.artist} numberOfLines={1}>
            {song.artist} • {song.album}
          </ThemedText>
        </View>

        <View style={styles.rightContainer}>
          <ThemedText style={styles.duration}>
            {formatDuration(song.duration)}
          </ThemedText>
          
          {onOptionsPress && (
            <TouchableOpacity
              style={styles.optionsButton}
              onPress={() => onOptionsPress(song)}
              hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
            >
              <ThemedText style={styles.optionsIcon}>⋯</ThemedText>
            </TouchableOpacity>
          )}
        </View>
      </TouchableOpacity>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 12,
    borderRadius: 8,
    position: 'relative',
    overflow: 'hidden',
  },
  gradient: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    opacity: 0.1,
  },
  artworkContainer: {
    marginRight: 12,
  },
  artworkPlaceholder: {
    width: 50,
    height: 50,
    borderRadius: 8,
    backgroundColor: PillowColors.lemon,
    justifyContent: 'center',
    alignItems: 'center',
  },
  artworkText: {
    fontSize: 24,
  },
  info: {
    flex: 1,
    marginRight: 8,
  },
  title: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 4,
  },
  playingText: {
    color: PillowColors.green,
  },
  artist: {
    fontSize: 14,
    opacity: 0.7,
  },
  rightContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  duration: {
    fontSize: 14,
    opacity: 0.5,
  },
  optionsButton: {
    padding: 4,
  },
  optionsIcon: {
    fontSize: 20,
    fontWeight: 'bold',
    color: PillowColors.darkGrey,
  },
});
