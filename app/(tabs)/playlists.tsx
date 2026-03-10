import { StyleSheet, ScrollView, TouchableOpacity } from 'react-native';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { useThemeColor } from '@/hooks/use-theme-color';

// Mock playlists data
const playlists = [
  { id: 1, name: 'Chill Vibes', songCount: 24, color: '#6C5CE7' },
  { id: 2, name: 'Workout Mix', songCount: 18, color: '#00B894' },
  { id: 3, name: 'Road Trip', songCount: 32, color: '#E17055' },
  { id: 4, name: 'Focus Flow', songCount: 15, color: '#0984E3' },
  { id: 5, name: 'Party Hits', songCount: 28, color: '#E84342' },
  { id: 6, name: 'Sad Songs', songCount: 21, color: '#6C5CE7' },
  { id: 7, name: '90s Classics', songCount: 45, color: '#00B894' },
  { id: 8, name: 'Acoustic Covers', songCount: 16, color: '#E17055' },
];

export default function PlaylistsScreen() {
  const iconColor = useThemeColor({}, 'icon');
  const tintColor = useThemeColor({}, 'tint');

  return (
    <ThemedView style={styles.container}>
      {/* Header */}
      <ThemedView style={styles.header}>
        <ThemedText type="title">Playlists</ThemedText>
        <TouchableOpacity>
          <IconSymbol name="plus.circle.fill" size={24} color={tintColor} />
        </TouchableOpacity>
      </ThemedView>

      <ScrollView showsVerticalScrollIndicator={false}>
        {/* Playlists Grid */}
        <ThemedView style={styles.playlistsGrid}>
          {playlists.map((playlist) => (
            <TouchableOpacity key={playlist.id} style={styles.playlistCard}>
              <ThemedView style={[styles.playlistArt, { backgroundColor: playlist.color }]}>
                <IconSymbol name="list.bullet" size={40} color="#FFFFFF" />
              </ThemedView>
              <ThemedText type="defaultSemiBold" style={styles.playlistName}>
                {playlist.name}
              </ThemedText>
              <ThemedText style={styles.playlistStats}>
                {playlist.songCount} songs
              </ThemedText>
            </TouchableOpacity>
          ))}
        </ThemedView>
      </ScrollView>
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 60,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingBottom: 16,
  },
  playlistsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingHorizontal: 16,
    gap: 16,
  },
  playlistCard: {
    width: '47%',
    marginBottom: 24,
  },
  playlistArt: {
    width: '100%',
    aspectRatio: 1,
    borderRadius: 12,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 12,
  },
  playlistName: {
    fontSize: 16,
    marginBottom: 4,
  },
  playlistStats: {
    fontSize: 12,
    opacity: 0.6,
  },
});
