import { StyleSheet, ScrollView, TouchableOpacity } from 'react-native';
import { router } from 'expo-router';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { useThemeColor } from '@/hooks/use-theme-color';

// Mock favourites data
const favouriteSongs = [
  { id: 1, title: 'Bohemian Rhapsody', artist: 'Queen', album: 'A Night at the Opera', duration: '5:55', year: '1975' },
  { id: 2, title: 'Shape of You', artist: 'Ed Sheeran', album: '÷', duration: '4:23', year: '2017' },
  { id: 3, title: 'Blinding Lights', artist: 'The Weeknd', album: 'After Hours', duration: '3:20', year: '2020' },
  { id: 4, title: 'Someone Like You', artist: 'Adele', album: '21', duration: '4:45', year: '2011' },
  { id: 5, title: 'Rolling in the Deep', artist: 'Adele', album: '21', duration: '3:48', year: '2011' },
];

export default function FavouritesScreen() {
  const iconColor = useThemeColor({}, 'icon');
  const tintColor = useThemeColor({}, 'tint');

  const handleSongPress = (song: any) => {
    // Just navigate for now, no player functionality
    router.push('/now-playing');
  };

  return (
    <ThemedView style={styles.container}>
      {/* Header */}
      <ThemedView style={styles.header}>
        <ThemedText type="title">Favourites</ThemedText>
        <TouchableOpacity>
          <IconSymbol name="ellipsis" size={24} color={iconColor} />
        </TouchableOpacity>
      </ThemedView>

      <ScrollView showsVerticalScrollIndicator={false}>
        {/* Stats */}
        <ThemedView style={styles.statsContainer}>
          <ThemedView style={styles.statItem}>
            <ThemedText type="title" style={styles.statNumber}>{favouriteSongs.length}</ThemedText>
            <ThemedText style={styles.statLabel}>Songs</ThemedText>
          </ThemedView>
          <ThemedView style={styles.statItem}>
            <ThemedText type="title" style={styles.statNumber}>2</ThemedText>
            <ThemedText style={styles.statLabel}>Albums</ThemedText>
          </ThemedView>
          <ThemedView style={styles.statItem}>
            <ThemedText type="title" style={styles.statNumber}>3</ThemedText>
            <ThemedText style={styles.statLabel}>Artists</ThemedText>
          </ThemedView>
        </ThemedView>

        {/* Quick Actions */}
        <ThemedView style={styles.quickActions}>
          <TouchableOpacity style={[styles.actionButton, { borderColor: iconColor + '40' }]}>
            <IconSymbol name="shuffle" size={20} color={iconColor} />
            <ThemedText style={styles.actionText}>Shuffle All</ThemedText>
          </TouchableOpacity>
          <TouchableOpacity style={[styles.actionButton, { borderColor: iconColor + '40' }]}>
            <IconSymbol name="arrow.down.circle" size={20} color={iconColor} />
            <ThemedText style={styles.actionText}>Download All</ThemedText>
          </TouchableOpacity>
        </ThemedView>

        {/* Favourites List */}
        <ThemedView style={styles.favouritesList}>
          <ThemedText style={styles.sectionHeader}>Recently Added</ThemedText>
          {favouriteSongs.map((song) => (
            <TouchableOpacity 
              key={song.id} 
              onPress={() => handleSongPress(song)}
              activeOpacity={0.7}>
              <ThemedView style={styles.songItem}>
                <ThemedView style={styles.songInfo}>
                  <ThemedView style={[styles.songIcon, { backgroundColor: tintColor + '20' }]}>
                    <IconSymbol name="heart.fill" size={16} color={tintColor} />
                  </ThemedView>
                  <ThemedView>
                    <ThemedText type="defaultSemiBold">{song.title}</ThemedText>
                    <ThemedView style={styles.songDetails}>
                      <ThemedText style={styles.artistText}>{song.artist}</ThemedText>
                      <ThemedText style={styles.dot}>•</ThemedText>
                      <ThemedText style={styles.albumText}>{song.album}</ThemedText>
                    </ThemedView>
                  </ThemedView>
                </ThemedView>
                <ThemedText style={styles.durationText}>{song.duration}</ThemedText>
              </ThemedView>
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
  statsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    paddingHorizontal: 20,
    paddingVertical: 20,
    marginBottom: 16,
  },
  statItem: {
    alignItems: 'center',
  },
  statNumber: {
    fontSize: 28,
    marginBottom: 4,
  },
  statLabel: {
    fontSize: 12,
    opacity: 0.6,
  },
  quickActions: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    paddingHorizontal: 20,
    marginBottom: 24,
  },
  actionButton: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    paddingVertical: 10,
    paddingHorizontal: 16,
    borderWidth: 1,
    borderRadius: 20,
  },
  actionText: {
    fontSize: 14,
  },
  favouritesList: {
    paddingHorizontal: 20,
  },
  sectionHeader: {
    fontSize: 14,
    opacity: 0.6,
    marginBottom: 12,
    textTransform: 'uppercase',
    letterSpacing: 0.5,
  },
  songItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 10,
    borderBottomWidth: 1,
    borderBottomColor: 'rgba(150,150,150,0.1)',
  },
  songInfo: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    flex: 1,
  },
  songIcon: {
    width: 32,
    height: 32,
    borderRadius: 16,
    justifyContent: 'center',
    alignItems: 'center',
  },
  songDetails: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    marginTop: 2,
  },
  artistText: {
    fontSize: 12,
    opacity: 0.7,
  },
  albumText: {
    fontSize: 12,
    opacity: 0.5,
  },
  dot: {
    fontSize: 12,
    opacity: 0.3,
    marginHorizontal: 2,
  },
  durationText: {
    fontSize: 13,
    opacity: 0.5,
  },
});
