import { StyleSheet, ScrollView, TouchableOpacity } from 'react-native';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { useThemeColor } from '@/hooks/use-theme-color';

// Mock albums data
const albums = [
  { id: 1, name: 'A Night at the Opera', artist: 'Queen', year: '1975', songCount: 12 },
  { id: 2, name: '÷ (Divide)', artist: 'Ed Sheeran', year: '2017', songCount: 16 },
  { id: 3, name: 'After Hours', artist: 'The Weeknd', year: '2020', songCount: 14 },
  { id: 4, name: '21', artist: 'Adele', year: '2011', songCount: 11 },
  { id: 5, name: 'When We All Fall Asleep', artist: 'Billie Eilish', year: '2019', songCount: 14 },
  { id: 6, name: '24K Magic', artist: 'Bruno Mars', year: '2016', songCount: 9 },
  { id: 7, name: '1989', artist: 'Taylor Swift', year: '2014', songCount: 13 },
  { id: 8, name: 'Scorpion', artist: 'Drake', year: '2018', songCount: 25 },
];

export default function AlbumsScreen() {
  const iconColor = useThemeColor({}, 'icon');
  const tintColor = useThemeColor({}, 'tint');

  return (
    <ThemedView style={styles.container}>
      {/* Header */}
      <ThemedView style={styles.header}>
        <ThemedText type="title">Albums</ThemedText>
        <TouchableOpacity>
          <IconSymbol name="magnifyingglass" size={24} color={iconColor} />
        </TouchableOpacity>
      </ThemedView>

      <ScrollView showsVerticalScrollIndicator={false}>
        {/* Albums Grid */}
        <ThemedView style={styles.albumsGrid}>
          {albums.map((album) => (
            <TouchableOpacity key={album.id} style={styles.albumCard}>
              <ThemedView style={[styles.albumArt, { backgroundColor: tintColor + '20' }]}>
                <IconSymbol name="music.note.list" size={40} color={tintColor} />
              </ThemedView>
              <ThemedText type="defaultSemiBold" style={styles.albumName}>
                {album.name}
              </ThemedText>
              <ThemedText style={styles.albumArtist}>{album.artist}</ThemedText>
              <ThemedText style={styles.albumStats}>
                {album.year} • {album.songCount} songs
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
  albumsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingHorizontal: 16,
    gap: 16,
  },
  albumCard: {
    width: '47%',
    marginBottom: 24,
  },
  albumArt: {
    width: '100%',
    aspectRatio: 1,
    borderRadius: 8,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 8,
  },
  albumName: {
    fontSize: 15,
    marginBottom: 2,
  },
  albumArtist: {
    fontSize: 13,
    opacity: 0.7,
    marginBottom: 2,
  },
  albumStats: {
    fontSize: 11,
    opacity: 0.5,
  },
});
