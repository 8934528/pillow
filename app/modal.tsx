import { Link } from 'expo-router';
import { StyleSheet, TouchableOpacity, ScrollView } from 'react-native';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { useThemeColor } from '@/hooks/use-theme-color';

// Mock queue data
const queueSongs = [
  { id: 1, title: 'Bohemian Rhapsody', artist: 'Queen', isPlaying: true },
  { id: 2, title: 'Shape of You', artist: 'Ed Sheeran' },
  { id: 3, title: 'Blinding Lights', artist: 'The Weeknd' },
  { id: 4, title: 'Dance Monkey', artist: 'Tones and I' },
  { id: 5, title: 'Someone Like You', artist: 'Adele' },
  { id: 6, title: 'Uptown Funk', artist: 'Mark Ronson ft. Bruno Mars' },
];

export default function ModalScreen() {
  const iconColor = useThemeColor({}, 'icon');
  const tintColor = useThemeColor({}, 'tint');

  return (
    <ThemedView style={styles.container}>
      <ThemedView style={styles.header}>
        <Link href="/" dismissTo asChild>
          <TouchableOpacity>
            <IconSymbol name="chevron.down" size={24} color={iconColor} />
          </TouchableOpacity>
        </Link>
        <ThemedText type="subtitle">Queue</ThemedText>
        <TouchableOpacity>
          <IconSymbol name="trash" size={22} color={iconColor} />
        </TouchableOpacity>
      </ThemedView>

      <ScrollView showsVerticalScrollIndicator={false}>
        <ThemedView style={styles.nowPlayingSection}>
          <ThemedText style={styles.sectionHeader}>Now Playing</ThemedText>
          <ThemedView style={[styles.queueItem, styles.nowPlayingItem]}>
            <ThemedView style={styles.songInfo}>
              <ThemedView style={[styles.playingIndicator, { backgroundColor: tintColor }]} />
              <ThemedView>
                <ThemedText type="defaultSemiBold" style={styles.nowPlayingTitle}>
                  Bohemian Rhapsody
                </ThemedText>
                <ThemedText style={styles.artistText}>Queen</ThemedText>
              </ThemedView>
            </ThemedView>
            <IconSymbol name="music.note" size={20} color={tintColor} />
          </ThemedView>
        </ThemedView>

        <ThemedView style={styles.queueSection}>
          <ThemedView style={styles.queueHeader}>
            <ThemedText style={styles.sectionHeader}>Next in Queue</ThemedText>
            <TouchableOpacity>
              <IconSymbol name="shuffle" size={20} color={iconColor} />
            </TouchableOpacity>
          </ThemedView>
          
          {queueSongs.slice(1).map((song, index) => (
            <ThemedView key={song.id} style={styles.queueItem}>
              <ThemedView style={styles.songInfo}>
                <ThemedText style={styles.queueNumber}>{index + 1}</ThemedText>
                <ThemedView>
                  <ThemedText>{song.title}</ThemedText>
                  <ThemedText style={styles.artistText}>{song.artist}</ThemedText>
                </ThemedView>
              </ThemedView>
              <TouchableOpacity>
                <IconSymbol name="minus.circle" size={20} color={iconColor} />
              </TouchableOpacity>
            </ThemedView>
          ))}
        </ThemedView>

        <TouchableOpacity style={styles.addButton}>
          <IconSymbol name="plus.circle.fill" size={20} color={tintColor} />
          <ThemedText style={[styles.addText, { color: tintColor }]}>Add to Queue</ThemedText>
        </TouchableOpacity>

        <ThemedView style={styles.saveSection}>
          <TouchableOpacity style={styles.saveButton}>
            <IconSymbol name="heart" size={22} color={iconColor} />
            <ThemedText style={styles.saveText}>Save to Favorites</ThemedText>
          </TouchableOpacity>
          <TouchableOpacity style={styles.saveButton}>
            <IconSymbol name="plus.circle.fill" size={22} color={iconColor} />
            <ThemedText style={styles.saveText}>Add to Playlist</ThemedText>
          </TouchableOpacity>
        </ThemedView>
      </ScrollView>
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
  nowPlayingSection: {
    marginBottom: 30,
  },
  queueSection: {
    marginBottom: 20,
  },
  queueHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
  },
  sectionHeader: {
    fontSize: 14,
    opacity: 0.6,
    textTransform: 'uppercase',
    letterSpacing: 0.5,
  },
  queueItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderBottomColor: 'rgba(150,150,150,0.2)',
  },
  nowPlayingItem: {
    backgroundColor: 'rgba(150,150,150,0.1)',
    paddingHorizontal: 12,
    borderRadius: 8,
    borderBottomWidth: 0,
  },
  songInfo: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  playingIndicator: {
    width: 8,
    height: 8,
    borderRadius: 4,
  },
  queueNumber: {
    width: 20,
    opacity: 0.5,
  },
  nowPlayingTitle: {
    fontSize: 16,
  },
  artistText: {
    fontSize: 13,
    opacity: 0.6,
    marginTop: 2,
  },
  addButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
    paddingVertical: 16,
    marginTop: 10,
    marginBottom: 20,
    borderWidth: 1,
    borderColor: 'rgba(150,150,150,0.3)',
    borderRadius: 8,
    borderStyle: 'dashed',
  },
  addText: {
    fontSize: 16,
  },
  saveSection: {
    marginBottom: 30,
  },
  saveButton: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    paddingVertical: 12,
  },
  saveText: {
    fontSize: 16,
  },
});
