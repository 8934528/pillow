import React from 'react';
import { StyleSheet, TouchableOpacity, View } from 'react-native';
import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { PillowColors, GradientColors } from '@/constants/colors';
import { LinearGradient } from 'expo-linear-gradient';
import Animated, { 
  useAnimatedStyle, 
  withSpring,
  withTiming,
  interpolate,
} from 'react-native-reanimated';

interface PlayerControlsProps {
  currentSong?: {
    title: string;
    artist: string;
  } | null;
  isPlaying: boolean;
  onPlayPause: () => void;
  onNext: () => void;
  onPrevious: () => void;
  progress?: number;
}

export function PlayerControls({
  currentSong,
  isPlaying,
  onPlayPause,
  onNext,
  onPrevious,
  progress = 0,
}: PlayerControlsProps) {
  if (!currentSong) {
    return (
      <ThemedView style={styles.emptyContainer}>
        <ThemedText style={styles.emptyText}>No song playing</ThemedText>
      </ThemedView>
    );
  }

  const progressBarStyle = useAnimatedStyle(() => ({
    width: withSpring(`${progress * 100}%`, {
      damping: 15,
      stiffness: 100,
    }),
  }));

  return (
    <LinearGradient
      colors={GradientColors.player}
      style={styles.container}
      start={{ x: 0, y: 0 }}
      end={{ x: 1, y: 0 }}
    >
      <View style={styles.songInfo}>
        <ThemedText style={styles.title} numberOfLines={1}>
          {currentSong.title}
        </ThemedText>
        <ThemedText style={styles.artist} numberOfLines={1}>
          {currentSong.artist}
        </ThemedText>
      </View>

      <View style={styles.progressContainer}>
        <View style={styles.progressBackground}>
          <Animated.View style={[styles.progressFill, progressBarStyle]} />
        </View>
      </View>

      <View style={styles.controls}>
        <TouchableOpacity onPress={onPrevious} style={styles.controlButton}>
          <ThemedText style={styles.controlIcon}>⏮</ThemedText>
        </TouchableOpacity>

        <TouchableOpacity onPress={onPlayPause} style={styles.playButton}>
          <LinearGradient
            colors={[PillowColors.white, PillowColors.lightGrey]}
            style={styles.playButtonGradient}
          >
            <ThemedText style={styles.playIcon}>
              {isPlaying ? '⏸' : '▶'}
            </ThemedText>
          </LinearGradient>
        </TouchableOpacity>

        <TouchableOpacity onPress={onNext} style={styles.controlButton}>
          <ThemedText style={styles.controlIcon}>⏭</ThemedText>
        </TouchableOpacity>
      </View>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  container: {
    padding: 16,
    borderTopLeftRadius: 20,
    borderTopRightRadius: 20,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: -2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 5,
  },
  emptyContainer: {
    padding: 16,
    alignItems: 'center',
    justifyContent: 'center',
    borderTopLeftRadius: 20,
    borderTopRightRadius: 20,
  },
  emptyText: {
    opacity: 0.5,
    fontSize: 14,
  },
  songInfo: {
    marginBottom: 12,
  },
  title: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 4,
  },
  artist: {
    fontSize: 14,
    opacity: 0.7,
  },
  progressContainer: {
    marginBottom: 16,
  },
  progressBackground: {
    height: 4,
    backgroundColor: 'rgba(255, 255, 255, 0.3)',
    borderRadius: 2,
    overflow: 'hidden',
  },
  progressFill: {
    height: '100%',
    backgroundColor: PillowColors.green,
    borderRadius: 2,
  },
  controls: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 24,
  },
  controlButton: {
    padding: 8,
  },
  controlIcon: {
    fontSize: 24,
    opacity: 0.8,
  },
  playButton: {
    width: 56,
    height: 56,
    borderRadius: 28,
    overflow: 'hidden',
  },
  playButtonGradient: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  playIcon: {
    fontSize: 28,
    color: PillowColors.green,
  },
});
