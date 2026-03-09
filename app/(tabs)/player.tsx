import React, { useState } from 'react';
import { StyleSheet, View, TouchableOpacity, Dimensions } from 'react-native';
import { ThemedView } from '@/components/themed-view';
import { ThemedText } from '@/components/themed-text';
import { PillowColors } from '@/constants/colors';
import { LinearGradient } from 'expo-linear-gradient';
import Animated, { 
  useAnimatedStyle, 
  withSpring,
  withTiming,
  interpolate,
  Extrapolate,
} from 'react-native-reanimated';
import Slider from '@react-native-community/slider';

const { width } = Dimensions.get('window');

export default function PlayerScreen() {
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentTime, setCurrentTime] = useState(0);
  const [duration, setDuration] = useState(240); // 4 minutes mock
  const [isShuffled, setIsShuffled] = useState(false);
  const [repeatMode, setRepeatMode] = useState<'off' | 'all' | 'one'>('off');

  // Mock current song
  const currentSong = {
    title: 'Bohemian Rhapsody',
    artist: 'Queen',
    album: 'A Night at the Opera',
  };

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  const progress = currentTime / duration;

  const handlePlayPause = () => {
    setIsPlaying(!isPlaying);
  };

  const handleShuffle = () => {
    setIsShuffled(!isShuffled);
  };

  const handleRepeat = () => {
    const modes: ('off' | 'all' | 'one')[] = ['off', 'all', 'one'];
    const currentIndex = modes.indexOf(repeatMode);
    const nextIndex = (currentIndex + 1) % modes.length;
    setRepeatMode(modes[nextIndex]);
  };

  return (
    <LinearGradient
      colors={[PillowColors.lightGrey, PillowColors.lemon]}
      style={styles.gradient}
    >
      <ThemedView style={styles.container}>
        {/* Artwork */}
        <View style={styles.artworkContainer}>
          <LinearGradient
            colors={[PillowColors.lemon, PillowColors.green]}
            style={styles.artwork}
          >
            <ThemedText style={styles.artworkIcon}>🎵</ThemedText>
          </LinearGradient>
        </View>

        {/* Song Info */}
        <View style={styles.songInfo}>
          <ThemedText style={styles.title}>{currentSong.title}</ThemedText>
          <ThemedText style={styles.artist}>{currentSong.artist}</ThemedText>
          <ThemedText style={styles.album}>{currentSong.album}</ThemedText>
        </View>

        {/* Progress Bar */}
        <View style={styles.progressContainer}>
          <Slider
            style={styles.slider}
            value={currentTime}
            minimumValue={0}
            maximumValue={duration}
            minimumTrackTintColor={PillowColors.green}
            maximumTrackTintColor="rgba(0,0,0,0.1)"
            thumbTintColor={PillowColors.green}
            onValueChange={setCurrentTime}
          />
          <View style={styles.timeContainer}>
            <ThemedText style={styles.timeText}>{formatTime(currentTime)}</ThemedText>
            <ThemedText style={styles.timeText}>{formatTime(duration)}</ThemedText>
          </View>
        </View>

        {/* Main Controls */}
        <View style={styles.mainControls}>
          <TouchableOpacity onPress={handleShuffle} style={styles.controlButton}>
            <ThemedText style={[
              styles.controlIcon,
              isShuffled && styles.activeControl
            ]}>
              🔀
            </ThemedText>
          </TouchableOpacity>

          <TouchableOpacity style={styles.controlButton}>
            <ThemedText style={styles.controlIcon}>⏮</ThemedText>
          </TouchableOpacity>

          <TouchableOpacity onPress={handlePlayPause} style={styles.playButton}>
            <LinearGradient
              colors={[PillowColors.green, PillowColors.lemon]}
              style={styles.playButtonGradient}
            >
              <ThemedText style={styles.playIcon}>
                {isPlaying ? '⏸' : '▶'}
              </ThemedText>
            </LinearGradient>
          </TouchableOpacity>

          <TouchableOpacity style={styles.controlButton}>
            <ThemedText style={styles.controlIcon}>⏭</ThemedText>
          </TouchableOpacity>

          <TouchableOpacity onPress={handleRepeat} style={styles.controlButton}>
            <ThemedText style={[
              styles.controlIcon,
              repeatMode !== 'off' && styles.activeControl
            ]}>
              {repeatMode === 'one' ? '🔂' : '🔄'}
            </ThemedText>
          </TouchableOpacity>
        </View>

        {/* Volume Control */}
        <View style={styles.volumeContainer}>
          <ThemedText style={styles.volumeIcon}>🔈</ThemedText>
          <Slider
            style={styles.volumeSlider}
            value={0.7}
            minimumValue={0}
            maximumValue={1}
            minimumTrackTintColor={PillowColors.green}
            maximumTrackTintColor="rgba(0,0,0,0.1)"
            thumbTintColor={PillowColors.green}
          />
          <ThemedText style={styles.volumeIcon}>🔊</ThemedText>
        </View>
      </ThemedView>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  gradient: {
    flex: 1,
  },
  container: {
    flex: 1,
    backgroundColor: 'transparent',
    paddingTop: 60,
    paddingHorizontal: 20,
  },
  artworkContainer: {
    alignItems: 'center',
    marginBottom: 40,
  },
  artwork: {
    width: width - 80,
    height: width - 80,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
    elevation: 10,
  },
  artworkIcon: {
    fontSize: 80,
  },
  songInfo: {
    alignItems: 'center',
    marginBottom: 30,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 8,
    textAlign: 'center',
  },
  artist: {
    fontSize: 18,
    opacity: 0.8,
    marginBottom: 4,
    textAlign: 'center',
  },
  album: {
    fontSize: 16,
    opacity: 0.6,
    textAlign: 'center',
  },
  progressContainer: {
    marginBottom: 30,
  },
  slider: {
    width: '100%',
    height: 40,
  },
  timeContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingHorizontal: 10,
  },
  timeText: {
    fontSize: 14,
    opacity: 0.6,
  },
  mainControls: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 40,
    gap: 20,
  },
  controlButton: {
    padding: 10,
  },
  controlIcon: {
    fontSize: 24,
    opacity: 0.8,
  },
  activeControl: {
    color: PillowColors.green,
    opacity: 1,
  },
  playButton: {
    width: 70,
    height: 70,
    borderRadius: 35,
    overflow: 'hidden',
  },
  playButtonGradient: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  playIcon: {
    fontSize: 30,
    color: PillowColors.white,
  },
  volumeContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
  },
  volumeIcon: {
    fontSize: 20,
    opacity: 0.6,
  },
  volumeSlider: {
    flex: 1,
    height: 40,
  },
});
