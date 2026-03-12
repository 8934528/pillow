import { StyleSheet, TouchableOpacity, Dimensions } from 'react-native';
import Animated, { 
  useSharedValue, 
  useAnimatedStyle, 
  withRepeat,
  withTiming,
  Easing,
  withSequence,
  withSpring
} from 'react-native-reanimated';
import { useState, useEffect } from 'react';
import { router } from 'expo-router';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { useThemeColor } from '@/hooks/use-theme-color';

const { width } = Dimensions.get('window');

export default function NowPlayingScreen() {
  const [isLiked, setIsLiked] = useState(false);
  const [isPlaying, setIsPlaying] = useState(false);
  const iconColor = useThemeColor({}, 'icon');
  const tintColor = useThemeColor({}, 'tint');
  
  // Mock current song
  const currentSong = {
    id: 1,
    title: 'Bohemian Rhapsody',
    artist: 'Queen',
    album: 'A Night at the Opera',
    duration: '5:55',
    year: '1975'
  };
  
  // Animation for the album art
  const rotation = useSharedValue(0);
  const scale = useSharedValue(1);

  useEffect(() => {
    if (isPlaying) {
      rotation.value = withRepeat(
        withTiming(360, { 
          duration: 8000, 
          easing: Easing.linear 
        }),
        -1
      );
    } else {
      rotation.value = withTiming(rotation.value, { duration: 300 });
    }
  }, [isPlaying]);

  const animatedStyle = useAnimatedStyle(() => {
    return {
      transform: [
        { rotate: `${rotation.value}deg` },
        { scale: scale.value }
      ],
    };
  });

  const handlePlayPause = () => {
    setIsPlaying(!isPlaying);
    scale.value = withSequence(
      withSpring(0.9),
      withSpring(1)
    );
  };

  const handleClose = () => {
    router.back();
  };

  return (
    <ThemedView style={styles.container}>
      {/* Header */}
      <ThemedView style={styles.header}>
        <TouchableOpacity onPress={handleClose}>
          <IconSymbol name="chevron.down" size={24} color={iconColor} />
        </TouchableOpacity>
        <ThemedText type="subtitle">Now Playing</ThemedText>
        <TouchableOpacity>
          <IconSymbol name="ellipsis" size={24} color={iconColor} />
        </TouchableOpacity>
      </ThemedView>

      {/* Album Art */}
      <ThemedView style={styles.albumContainer}>
        <Animated.View style={[styles.albumArt, animatedStyle]}>
          <ThemedView style={[styles.albumInner, { backgroundColor: tintColor + '30' }]}>
            <IconSymbol name="music.note" size={100} color={tintColor} />
          </ThemedView>
        </Animated.View>
      </ThemedView>

      {/* Song Info */}
      <ThemedView style={styles.songInfo}>
        <ThemedText type="title" style={styles.songTitle}>
          {currentSong.title}
        </ThemedText>
        <ThemedText style={styles.songArtist}>{currentSong.artist}</ThemedText>
        <ThemedText style={styles.songAlbum}>
          {currentSong.album} • {currentSong.year}
        </ThemedText>
      </ThemedView>

      {/* Progress Bar */}
      <ThemedView style={styles.progressContainer}>
        <ThemedView style={styles.progressBar}>
          <ThemedView style={[styles.progressFill, { width: '45%', backgroundColor: tintColor }]} />
        </ThemedView>
        <ThemedView style={styles.timeContainer}>
          <ThemedText style={styles.timeText}>2:34</ThemedText>
          <ThemedText style={styles.timeText}>{currentSong.duration}</ThemedText>
        </ThemedView>
      </ThemedView>

      {/* Main Controls */}
      <ThemedView style={styles.controls}>
        <TouchableOpacity>
          <IconSymbol name="shuffle" size={24} color={iconColor} />
        </TouchableOpacity>
        <TouchableOpacity>
          <IconSymbol name="backward.end.fill" size={32} color={iconColor} />
        </TouchableOpacity>
        <TouchableOpacity 
          style={[styles.playButton, { backgroundColor: tintColor }]}
          onPress={handlePlayPause}>
          <IconSymbol 
            name={isPlaying ? "pause.fill" : "play.fill"} 
            size={36} 
            color="#FFFFFF" 
          />
        </TouchableOpacity>
        <TouchableOpacity>
          <IconSymbol name="forward.end.fill" size={32} color={iconColor} />
        </TouchableOpacity>
        <TouchableOpacity>
          <IconSymbol name="repeat" size={24} color={iconColor} />
        </TouchableOpacity>
      </ThemedView>

      {/* Bottom Controls */}
      <ThemedView style={styles.bottomControls}>
        <TouchableOpacity onPress={() => setIsLiked(!isLiked)}>
          <IconSymbol 
            name={isLiked ? "heart.fill" : "heart"} 
            size={26} 
            color={isLiked ? tintColor : iconColor} 
          />
        </TouchableOpacity>
        <TouchableOpacity>
          <IconSymbol name="airplayaudio" size={26} color={iconColor} />
        </TouchableOpacity>
        <TouchableOpacity onPress={() => router.push('/queue')}>
          <IconSymbol name="list.bullet" size={26} color={iconColor} />
        </TouchableOpacity>
        <TouchableOpacity>
          <IconSymbol name="speaker.wave.2" size={26} color={iconColor} />
        </TouchableOpacity>
      </ThemedView>

      {/* Up Next Preview */}
      <TouchableOpacity 
        style={styles.upNext}
        onPress={() => router.push('/queue')}>
        <ThemedView style={styles.upNextContent}>
          <ThemedView>
            <ThemedText style={styles.upNextLabel}>Next up</ThemedText>
            <ThemedText type="defaultSemiBold">
              Shape of You - Ed Sheeran
            </ThemedText>
          </ThemedView>
          <IconSymbol name="chevron.right" size={20} color={iconColor} />
        </ThemedView>
      </TouchableOpacity>
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 60,
    paddingHorizontal: 20,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 30,
  },
  albumContainer: {
    alignItems: 'center',
    marginBottom: 40,
  },
  albumArt: {
    width: width * 0.75,
    height: width * 0.75,
    borderRadius: width * 0.375,
    justifyContent: 'center',
    alignItems: 'center',
  },
  albumInner: {
    width: '90%',
    height: '90%',
    borderRadius: 1000,
    justifyContent: 'center',
    alignItems: 'center',
  },
  songInfo: {
    alignItems: 'center',
    marginBottom: 30,
  },
  songTitle: {
    fontSize: 28,
    marginBottom: 8,
    textAlign: 'center',
  },
  songArtist: {
    fontSize: 18,
    opacity: 0.8,
    marginBottom: 4,
  },
  songAlbum: {
    fontSize: 14,
    opacity: 0.6,
  },
  progressContainer: {
    marginBottom: 40,
  },
  progressBar: {
    height: 5,
    backgroundColor: 'rgba(150,150,150,0.3)',
    borderRadius: 2.5,
    marginBottom: 8,
  },
  progressFill: {
    height: 5,
    borderRadius: 2.5,
    width: '45%',
  },
  timeContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  timeText: {
    fontSize: 12,
    opacity: 0.6,
  },
  controls: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    alignItems: 'center',
    marginBottom: 30,
  },
  playButton: {
    width: 70,
    height: 70,
    borderRadius: 35,
    justifyContent: 'center',
    alignItems: 'center',
  },
  bottomControls: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    marginBottom: 40,
  },
  upNext: {
    marginTop: 'auto',
    marginBottom: 20,
  },
  upNextContent: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 15,
    borderRadius: 12,
    backgroundColor: 'rgba(150,150,150,0.1)',
  },
  upNextLabel: {
    fontSize: 12,
    opacity: 0.6,
    marginBottom: 4,
  },
});
