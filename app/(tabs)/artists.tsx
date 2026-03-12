import { StyleSheet, ScrollView, TouchableOpacity } from 'react-native';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { useThemeColor } from '@/hooks/use-theme-color';

// Mock artists data
const artists = [
  { id: 1, name: 'Queen', songCount: 24, albumCount: 15, image: null },
  { id: 2, name: 'Ed Sheeran', songCount: 42, albumCount: 6, image: null },
  { id: 3, name: 'The Weeknd', songCount: 38, albumCount: 5, image: null },
  { id: 4, name: 'Adele', songCount: 19, albumCount: 3, image: null },
  { id: 5, name: 'Billie Eilish', songCount: 22, albumCount: 2, image: null },
  { id: 6, name: 'Bruno Mars', songCount: 31, albumCount: 4, image: null },
  { id: 7, name: 'Taylor Swift', songCount: 54, albumCount: 9, image: null },
  { id: 8, name: 'Drake', songCount: 67, albumCount: 8, image: null },
];

export default function ArtistsScreen() {
  const iconColor = useThemeColor({}, 'icon');
  const tintColor = useThemeColor({}, 'tint');

  return (
    <ThemedView style={styles.container}>
      {/* Header */}
      <ThemedView style={styles.header}>
        <ThemedText type="title">Artists</ThemedText>
        <TouchableOpacity>
          <IconSymbol name="magnifyingglass" size={24} color={iconColor} />
        </TouchableOpacity>
      </ThemedView>

      <ScrollView showsVerticalScrollIndicator={false}>
        {/* Artists Grid */}
        <ThemedView style={styles.artistsGrid}>
          {artists.map((artist) => (
            <TouchableOpacity key={artist.id} style={styles.artistCard}>
              <ThemedView style={[styles.artistImage, { backgroundColor: tintColor + '20' }]}>
                <IconSymbol name="person" size={40} color={tintColor} />
              </ThemedView>
              <ThemedText type="defaultSemiBold" style={styles.artistName}>
                {artist.name}
              </ThemedText>
              <ThemedText style={styles.artistStats}>
                {artist.albumCount} albums • {artist.songCount} songs
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
  artistsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingHorizontal: 16,
    gap: 16,
  },
  artistCard: {
    width: '47%',
    alignItems: 'center',
    marginBottom: 24,
  },
  artistImage: {
    width: 120,
    height: 120,
    borderRadius: 60,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 12,
  },
  artistName: {
    fontSize: 16,
    textAlign: 'center',
    marginBottom: 4,
  },
  artistStats: {
    fontSize: 12,
    opacity: 0.6,
    textAlign: 'center',
  },
});
