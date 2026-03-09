import React, { useState, useEffect } from 'react';
import { StyleSheet, ScrollView, RefreshControl, View } from 'react-native';
import { ThemedView } from '@/components/themed-view';
import { ThemedText } from '@/components/themed-text';
import { FilterTabs } from '@/components/ui/filter-tabs';
import { SongItem } from '@/components/ui/song-item';
import { PlayerControls } from '@/components/ui/player-controls';
import { OptionsModal } from '@/components/ui/options-modal';
import { useMusicFiles } from '@/hooks/use-music-files';
import { FilterTab, Song, PlayerState } from '@/types/music';
import { PillowColors } from '@/constants/colors';
import Animated, { FadeIn } from 'react-native-reanimated';
import { LinearGradient } from 'expo-linear-gradient';

export default function HomeScreen() {
  const [activeTab, setActiveTab] = useState<FilterTab>('songs');
  const [refreshing, setRefreshing] = useState(false);
  const [optionsVisible, setOptionsVisible] = useState(false);
  const [selectedSong, setSelectedSong] = useState<Song | null>(null);
  const [playerState, setPlayerState] = useState<PlayerState>({
    currentSong: null,
    isPlaying: false,
    currentTime: 0,
    duration: 0,
    volume: 1,
    isShuffled: false,
    repeatMode: 'off',
  });

  const { 
    songs, 
    albums, 
    artists, 
    folders, 
    loading, 
    error, 
    refresh 
  } = useMusicFiles();

  const onRefresh = async () => {
    setRefreshing(true);
    await refresh();
    setRefreshing(false);
  };

  const handleSongPress = (song: Song) => {
    setPlayerState(prev => ({
      ...prev,
      currentSong: song,
      isPlaying: true,
      duration: song.duration,
    }));
  };

  const handleOptionsPress = (song: Song) => {
    setSelectedSong(song);
    setOptionsVisible(true);
  };

  const handlePlayPause = () => {
    setPlayerState(prev => ({
      ...prev,
      isPlaying: !prev.isPlaying,
    }));
  };

  const handleNext = () => {
    // Implement next song logic
    console.log('Next song');
  };

  const handlePrevious = () => {
    // Implement previous song logic
    console.log('Previous song');
  };

  const handleVisualize = () => {
    console.log('Visualize:', selectedSong?.title);
  };

  const handleShare = () => {
    console.log('Share:', selectedSong?.title);
  };

  const handleDelete = () => {
    console.log('Delete:', selectedSong?.title);
  };

  const renderContent = () => {
    switch (activeTab) {
      case 'songs':
        return (
          <Animated.View entering={FadeIn}>
            {songs.map(song => (
              <SongItem
                key={song.id}
                song={song}
                onPress={handleSongPress}
                onOptionsPress={handleOptionsPress}
                isPlaying={playerState.currentSong?.id === song.id && playerState.isPlaying}
              />
            ))}
          </Animated.View>
        );
      
      case 'albums':
        return (
          <Animated.View entering={FadeIn}>
            {albums.map(album => (
              <ThemedView key={album.id} style={styles.albumContainer}>
                <ThemedText style={styles.albumTitle}>{album.name}</ThemedText>
                <ThemedText style={styles.albumSubtitle}>
                  {album.artist} • {album.songCount} songs
                </ThemedText>
              </ThemedView>
            ))}
          </Animated.View>
        );
      
      case 'artists':
        return (
          <Animated.View entering={FadeIn}>
            {artists.map(artist => (
              <ThemedView key={artist.id} style={styles.artistContainer}>
                <ThemedText style={styles.artistName}>{artist.name}</ThemedText>
                <ThemedText style={styles.artistSubtitle}>
                  {artist.songCount} songs • {artist.albumCount} albums
                </ThemedText>
              </ThemedView>
            ))}
          </Animated.View>
        );
      
      case 'folders':
        return (
          <Animated.View entering={FadeIn}>
            {folders.map(folder => (
              <ThemedView key={folder.id} style={styles.folderContainer}>
                <ThemedText style={styles.folderName}>📁 {folder.name}</ThemedText>
                <ThemedText style={styles.folderSubtitle}>
                  {folder.songCount} songs
                </ThemedText>
              </ThemedView>
            ))}
          </Animated.View>
        );
      
      case 'favourites':
        return (
          <Animated.View entering={FadeIn}>
            <ThemedText style={styles.emptyMessage}>
              No favourite songs yet
            </ThemedText>
          </Animated.View>
        );
      
      default:
        return null;
    }
  };

  return (
    <LinearGradient
      colors={[PillowColors.lightGrey, PillowColors.lemon]}
      style={styles.gradient}
    >
      <ThemedView style={styles.container}>
        <View style={styles.header}>
          <ThemedText style={styles.headerTitle}>Pillow</ThemedText>
          <TouchableOpacity style={styles.settingsButton}>
            <ThemedText style={styles.settingsIcon}>⚙️</ThemedText>
          </TouchableOpacity>
        </View>

        <FilterTabs activeTab={activeTab} onTabChange={setActiveTab} />

        <ScrollView
          style={styles.content}
          refreshControl={
            <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
          }
        >
          {loading ? (
            <ThemedText style={styles.loadingText}>Loading music...</ThemedText>
          ) : error ? (
            <ThemedText style={styles.errorText}>{error}</ThemedText>
          ) : (
            renderContent()
          )}
        </ScrollView>

        <PlayerControls
          currentSong={playerState.currentSong}
          isPlaying={playerState.isPlaying}
          onPlayPause={handlePlayPause}
          onNext={handleNext}
          onPrevious={handlePrevious}
          progress={playerState.duration > 0 ? playerState.currentTime / playerState.duration : 0}
        />

        <OptionsModal
          visible={optionsVisible}
          onClose={() => setOptionsVisible(false)}
          onVisualize={handleVisualize}
          onShare={handleShare}
          onDelete={handleDelete}
          songTitle={selectedSong?.title}
        />
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
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingTop: 60,
    paddingBottom: 16,
  },
  headerTitle: {
    fontSize: 28,
    fontWeight: 'bold',
    color: PillowColors.darkGrey,
  },
  settingsButton: {
    padding: 8,
  },
  settingsIcon: {
    fontSize: 24,
  },
  content: {
    flex: 1,
    paddingHorizontal: 16,
  },
  loadingText: {
    textAlign: 'center',
    marginTop: 40,
    opacity: 0.7,
  },
  errorText: {
    textAlign: 'center',
    marginTop: 40,
    color: '#FF3B30',
  },
  emptyMessage: {
    textAlign: 'center',
    marginTop: 40,
    opacity: 0.5,
    fontSize: 16,
  },
  albumContainer: {
    padding: 16,
    marginBottom: 8,
    borderRadius: 8,
    backgroundColor: PillowColors.white,
  },
  albumTitle: {
    fontSize: 18,
    fontWeight: '600',
    marginBottom: 4,
  },
  albumSubtitle: {
    fontSize: 14,
    opacity: 0.7,
  },
  artistContainer: {
    padding: 16,
    marginBottom: 8,
    borderRadius: 8,
    backgroundColor: PillowColors.white,
  },
  artistName: {
    fontSize: 18,
    fontWeight: '600',
    marginBottom: 4,
  },
  artistSubtitle: {
    fontSize: 14,
    opacity: 0.7,
  },
  folderContainer: {
    padding: 16,
    marginBottom: 8,
    borderRadius: 8,
    backgroundColor: PillowColors.white,
  },
  folderName: {
    fontSize: 18,
    fontWeight: '600',
    marginBottom: 4,
  },
  folderSubtitle: {
    fontSize: 14,
    opacity: 0.7,
  },
});
