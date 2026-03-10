import { Image } from 'expo-image';
import { StyleSheet, ScrollView, TouchableOpacity } from 'react-native';
import { Link } from 'expo-router';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { useThemeColor } from '@/hooks/use-theme-color';

// Mock data for music library
const recentPlays = [
  { id: 1, title: 'Bohemian Rhapsody', artist: 'Queen', duration: '5:55' },
  { id: 2, title: 'Shape of You', artist: 'Ed Sheeran', duration: '4:23' },
  { id: 3, title: 'Blinding Lights', artist: 'The Weeknd', duration: '3:20' },
  { id: 4, title: 'Dance Monkey', artist: 'Tones and I', duration: '3:35' },
];

const playlists = [
  { id: 1, name: 'Chill Vibes', count: 24, color: '#6C5CE7' },
  { id: 2, name: 'Workout Mix', count: 18, color: '#00B894' },
  { id: 3, name: 'Road Trip', count: 32, color: '#E17055' },
  { id: 4, name: 'Focus Flow', count: 15, color: '#0984E3' },
];

export default function LibraryScreen() {
  const iconColor = useThemeColor({}, 'icon');
  const tintColor = useThemeColor({}, 'tint');

  return (
    <ThemedView style={styles.container}>
      {/* Header */}
      <ThemedView style={styles.header}>
        <ThemedText type="title">Your Library</ThemedText>
        <TouchableOpacity>
          <IconSymbol name="person.crop.circle" size={24} color={iconColor} />
        </TouchableOpacity>
      </ThemedView>

      <ScrollView showsVerticalScrollIndicator={false}>
        {/* Recently Played Section */}
        <ThemedView style={styles.section}>
          <ThemedView style={styles.sectionHeader}>
            <ThemedText type="subtitle">Recently Played</ThemedText>
            <TouchableOpacity>
              <ThemedText style={styles.seeAllText}>See All</ThemedText>
            </TouchableOpacity>
          </ThemedView>

          {recentPlays.map((item) => (
            <Link href="/modal" key={item.id} asChild>
              <TouchableOpacity>
                <ThemedView style={styles.songItem}>
                  <ThemedView style={styles.songInfo}>
                    <ThemedView style={[styles.songIcon, { backgroundColor: tintColor + '20' }]}>
                      <IconSymbol name="music.note" size={20} color={tintColor} />
                    </ThemedView>
                    <ThemedView>
                      <ThemedText type="defaultSemiBold">{item.title}</ThemedText>
                      <ThemedText style={styles.artistText}>{item.artist}</ThemedText>
                    </ThemedView>
                  </ThemedView>
                  <ThemedText style={styles.durationText}>{item.duration}</ThemedText>
                </ThemedView>
              </TouchableOpacity>
            </Link>
          ))}
        </ThemedView>

        {/* Playlists Section */}
        <ThemedView style={styles.section}>
          <ThemedView style={styles.sectionHeader}>
            <ThemedText type="subtitle">Your Playlists</ThemedText>
            <TouchableOpacity>
              <IconSymbol name="plus.circle.fill" size={22} color={tintColor} />
            </TouchableOpacity>
          </ThemedView>

          <ThemedView style={styles.playlistGrid}>
            {playlists.map((playlist) => (
              <TouchableOpacity key={playlist.id} style={styles.playlistCard}>
                <ThemedView style={[styles.playlistColor, { backgroundColor: playlist.color }]}>
                  <IconSymbol name="list.bullet" size={30} color="#FFFFFF" />
                </ThemedView>
                <ThemedText type="defaultSemiBold" style={styles.playlistName}>
                  {playlist.name}
                </ThemedText>
                <ThemedText style={styles.playlistCount}>{playlist.count} songs</ThemedText>
              </TouchableOpacity>
            ))}
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
            <ThemedText style={styles.actionText}>Downloaded</ThemedText>
          </TouchableOpacity>
        </ThemedView>

        {/* Search Bar */}
        <TouchableOpacity style={styles.searchBar}>
          <IconSymbol name="magnifyingglass" size={20} color={iconColor} />
          <ThemedText style={styles.searchText}>Find in your library</ThemedText>
        </TouchableOpacity>
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
    paddingBottom: 20,
  },
  section: {
    marginBottom: 24,
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    marginBottom: 12,
  },
  seeAllText: {
    fontSize: 14,
    opacity: 0.7,
  },
  songItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingVertical: 8,
  },
  songInfo: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  songIcon: {
    width: 40,
    height: 40,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
  },
  artistText: {
    fontSize: 13,
    opacity: 0.7,
    marginTop: 2,
  },
  durationText: {
    fontSize: 13,
    opacity: 0.5,
  },
  playlistGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingHorizontal: 16,
    gap: 12,
  },
  playlistCard: {
    width: '47%',
    marginBottom: 16,
  },
  playlistColor: {
    width: '100%',
    aspectRatio: 1,
    borderRadius: 12,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 8,
  },
  playlistName: {
    fontSize: 15,
    marginBottom: 2,
  },
  playlistCount: {
    fontSize: 12,
    opacity: 0.6,
  },
  quickActions: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    paddingHorizontal: 20,
    paddingBottom: 20,
    marginTop: 8,
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
  searchBar: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    marginHorizontal: 20,
    marginBottom: 20,
    padding: 12,
    borderRadius: 10,
    backgroundColor: 'rgba(150,150,150,0.1)',
  },
  searchText: {
    fontSize: 15,
    opacity: 0.7,
  },
});