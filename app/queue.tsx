import { router } from 'expo-router';
import { StyleSheet, TouchableOpacity, ScrollView } from 'react-native';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { useThemeColor } from '@/hooks/use-theme-color';
import { useCurrentSong } from '@/hooks/use-current-song';

export default function QueueScreen() {
  const iconColor = useThemeColor({}, 'icon');
  const tintColor = useThemeColor({}, 'tint');
  const { currentSong, queue, playSong } = useCurrentSong();

  const handleSongPress = (song: any) => {
    playSong(song);
    router.push('/now-playing');
  };

  const handleClose = () => {
    router.back();
  };

  return (
    <ThemedView style={styles.container}>
      <ThemedView style={styles.header}>
        <TouchableOpacity onPress={handleClose}>
          <IconSymbol name="chevron.down" size={24} color={iconColor} />
        </TouchableOpacity>
        <ThemedText type="subtitle">Queue</ThemedText>
        <TouchableOpacity>
          <IconSymbol name="trash" size={22} color={iconColor} />
        </TouchableOpacity>
      </ThemedView>

      <ScrollView showsVerticalScrollIndicator={false}>
        {/* Now Playing Section */}
        {currentSong && (
          <ThemedView style={styles.nowPlayingSection}>
            <ThemedText style={styles.sectionHeader}>Now Playing</ThemedText>
            <ThemedView style={[styles.queueItem, styles.nowPlayingItem]}>
              <ThemedView style={styles.songInfo}>
                <ThemedView style={[styles.playingIndicator, { backgroundColor: tintColor }]} />
                <ThemedView>
                  <ThemedText type="defaultSemiBold" style={styles.nowPlayingTitle}>
                    {currentSong.title}
                  </ThemedText>
                  <ThemedText style={styles.artistText}>{currentSong.artist}</ThemedText>
                </ThemedView>
              </ThemedView>
              <IconSymbol name="music.note" size={20} color={tintColor} />
            </ThemedView>
          </ThemedView>
        )}

        {/* Queue Section */}
        <ThemedView style={styles.queueSection}>
          <ThemedView style={styles.queueHeader}>
            <ThemedText style={styles.sectionHeader}>Next in Queue</ThemedText>
            <TouchableOpacity>
              <IconSymbol name="shuffle" size={20} color={iconColor} />
            </TouchableOpacity>
          </ThemedView>
          
          {queue.map((song, index) => (
            <TouchableOpacity 
              key={song.id} 
              onPress={() => handleSongPress(song)}
              activeOpacity={0.7}>
              <ThemedView style={styles.queueItem}>
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
            </TouchableOpacity>
          ))}
        </ThemedView>

        <TouchableOpacity style={styles.addButton}>
          <IconSymbol name="plus.circle.fill" size={20} color={tintColor} />
          <ThemedText style={[styles.addText, { color: tintColor }]}>Add to Queue</ThemedText>
        </TouchableOpacity>
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
    marginBottom: 30,
    borderWidth: 1,
    borderColor: 'rgba(150,150,150,0.3)',
    borderRadius: 8,
    borderStyle: 'dashed',
  },
  addText: {
    fontSize: 16,
  },
});
