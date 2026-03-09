import React, { useState } from 'react';
import { StyleSheet, ScrollView, View, TouchableOpacity } from 'react-native';
import { ThemedView } from '@/components/themed-view';
import { ThemedText } from '@/components/themed-text';
import { FilterTabs } from '@/components/ui/filter-tabs';
import { SongItem } from '@/components/ui/song-item';
import { OptionsModal } from '@/components/ui/options-modal';
import { useMusicFiles } from '@/hooks/use-music-files';
import { FilterTab, Song } from '@/types/music';
import { PillowColors } from '@/constants/colors';
import { LinearGradient } from 'expo-linear-gradient';

export default function LibraryScreen() {
  const [activeTab, setActiveTab] = useState<FilterTab>('songs');
  const [optionsVisible, setOptionsVisible] = useState(false);
  const [selectedSong, setSelectedSong] = useState<Song | null>(null);
  const [searchQuery, setSearchQuery] = useState('');

  const { songs, albums, artists, folders } = useMusicFiles();

  const handleOptionsPress = (song: Song) => {
    setSelectedSong(song);
    setOptionsVisible(true);
  };

  const handleSongPress = (song: Song) => {
    console.log('Play song:', song.title);
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
          <View>
            {songs.map(song => (
              <SongItem
                key={song.id}
                song={song}
                onPress={handleSongPress}
                onOptionsPress={handleOptionsPress}
              />
            ))}
          </View>
        );
      
      case 'albums':
        return (
          <View style={styles.gridContainer}>
            {albums.map(album => (
              <TouchableOpacity key={album.id} style={styles.gridItem}>
                <LinearGradient
                  colors={[PillowColors.lemon, PillowColors.lightGrey]}
                  style={styles.gridArtwork}
                >
                  <ThemedText style={styles.gridIcon}>💿</ThemedText>
                </LinearGradient>
                <ThemedText style={styles.gridTitle} numberOfLines={1}>
                  {album.name}
                </ThemedText>
                <ThemedText style={styles.gridSubtitle} numberOfLines={1}>
                  {album.artist}
                </ThemedText>
              </TouchableOpacity>
            ))}
          </View>
        );
      
      case 'artists':
        return (
          <View style={styles.gridContainer}>
            {artists.map(artist => (
              <TouchableOpacity key={artist.id} style={styles.gridItem}>
                <LinearGradient
                  colors={[PillowColors.green, PillowColors.lemon]}
                  style={styles.gridArtwork}
                >
                  <ThemedText style={styles.gridIcon}>👤</ThemedText>
                </LinearGradient>
                <ThemedText style={styles.gridTitle} numberOfLines={1}>
                  {artist.name}
                </ThemedText>
                <ThemedText style={styles.gridSubtitle} numberOfLines={1}>
                  {artist.songCount} songs
                </ThemedText>
              </TouchableOpacity>
            ))}
          </View>
        );
      
      case 'folders':
        return (
          <View>
            {folders.map(folder => (
              <TouchableOpacity key={folder.id} style={styles.folderItem}>
                <View style={styles.folderIcon}>
                  <ThemedText style={styles.folderIconText}>📁</ThemedText>
                </View>
                <View style={styles.folderInfo}>
                  <ThemedText style={styles.folderName}>{folder.name}</ThemedText>
                  <ThemedText style={styles.folderPath} numberOfLines={1}>
                    {folder.path}
                  </ThemedText>
                  <ThemedText style={styles.folderSongCount}>
                    {folder.songCount} songs
                  </ThemedText>
                </View>
              </TouchableOpacity>
            ))}
          </View>
        );
      
      case 'favourites':
        return (
          <View style={styles.emptyState}>
            <ThemedText style={styles.emptyIcon}>❤️</ThemedText>
            <ThemedText style={styles.emptyTitle}>No Favourites Yet</ThemedText>
            <ThemedText style={styles.emptyDescription}>
              Tap the heart icon on any song to add it to your favourites
            </ThemedText>
          </View>
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
          <ThemedText style={styles.headerTitle}>Library</ThemedText>
          <TouchableOpacity style={styles.searchButton}>
            <ThemedText style={styles.searchIcon}>🔍</ThemedText>
          </TouchableOpacity>
        </View>

        <FilterTabs activeTab={activeTab} onTabChange={setActiveTab} />

        <ScrollView 
          style={styles.content}
          showsVerticalScrollIndicator={false}
        >
          {renderContent()}
        </ScrollView>

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
  searchButton: {
    padding: 8,
  },
  searchIcon: {
    fontSize: 24,
  },
  content: {
    flex: 1,
    paddingHorizontal: 16,
  },
  gridContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
    paddingVertical: 16,
  },
  gridItem: {
    width: '48%',
    marginBottom: 20,
  },
  gridArtwork: {
    width: '100%',
    aspectRatio: 1,
    borderRadius: 12,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 8,
  },
  gridIcon: {
    fontSize: 32,
  },
  gridTitle: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 4,
  },
  gridSubtitle: {
    fontSize: 14,
    opacity: 0.6,
  },
  folderItem: {
    flexDirection: 'row',
    padding: 16,
    marginBottom: 8,
    backgroundColor: PillowColors.white,
    borderRadius: 12,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 2,
    elevation: 2,
  },
  folderIcon: {
    width: 50,
    height: 50,
    borderRadius: 8,
    backgroundColor: PillowColors.lemon,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  folderIconText: {
    fontSize: 24,
  },
  folderInfo: {
    flex: 1,
  },
  folderName: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 4,
  },
  folderPath: {
    fontSize: 12,
    opacity: 0.5,
    marginBottom: 2,
  },
  folderSongCount: {
    fontSize: 12,
    opacity: 0.6,
  },
  emptyState: {
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 60,
    paddingHorizontal: 20,
  },
  emptyIcon: {
    fontSize: 60,
    marginBottom: 16,
  },
  emptyTitle: {
    fontSize: 20,
    fontWeight: '600',
    marginBottom: 8,
    textAlign: 'center',
  },
  emptyDescription: {
    fontSize: 16,
    opacity: 0.6,
    textAlign: 'center',
  },
});
