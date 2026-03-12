import { StyleSheet, ScrollView, TouchableOpacity } from 'react-native';
import { useState } from 'react';
import { router } from 'expo-router';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { useThemeColor } from '@/hooks/use-theme-color';

// Mock songs data
const allSongs = [
  { id: 1, title: 'Bohemian Rhapsody', artist: 'Queen', album: 'A Night at the Opera', duration: '5:55', year: '1975' },
  { id: 2, title: 'Shape of You', artist: 'Ed Sheeran', album: '÷', duration: '4:23', year: '2017' },
  { id: 3, title: 'Blinding Lights', artist: 'The Weeknd', album: 'After Hours', duration: '3:20', year: '2020' },
  { id: 4, title: 'Dance Monkey', artist: 'Tones and I', album: 'The Kids Are Coming', duration: '3:35', year: '2019' },
  { id: 5, title: 'Someone Like You', artist: 'Adele', album: '21', duration: '4:45', year: '2011' },
  { id: 6, title: 'Uptown Funk', artist: 'Mark Ronson ft. Bruno Mars', album: 'Uptown Special', duration: '4:30', year: '2014' },
  { id: 7, title: 'Rolling in the Deep', artist: 'Adele', album: '21', duration: '3:48', year: '2011' },
  { id: 8, title: 'Thinking Out Loud', artist: 'Ed Sheeran', album: 'x', duration: '4:41', year: '2014' },
  { id: 9, title: 'Stay', artist: 'The Kid LAROI, Justin Bieber', album: 'Stay', duration: '2:21', year: '2021' },
  { id: 10, title: 'Bad Guy', artist: 'Billie Eilish', album: 'When We All Fall Asleep', duration: '3:14', year: '2019' },
];

export default function SongsScreen() {
  const [sortBy, setSortBy] = useState('title');
  const iconColor = useThemeColor({}, 'icon');
  const tintColor = useThemeColor({}, 'tint');

  const handleSongPress = (song: any) => {
    // Just navigate for now, no player functionality
    router.push('/now-playing');
  };

  const getSortedSongs = () => {
    switch(sortBy) {
      case 'artist':
        return [...allSongs].sort((a, b) => a.artist.localeCompare(b.artist));
      default:
        return [...allSongs].sort((a, b) => a.title.localeCompare(b.title));
    }
  };

  return (
    <ThemedView style={styles.container}>
      {/* Header */}
      <ThemedView style={styles.header}>
        <ThemedText type="title">Songs</ThemedText>
        <TouchableOpacity>
          <IconSymbol name="magnifyingglass" size={24} color={iconColor} />
        </TouchableOpacity>
      </ThemedView>

      {/* Sort Options */}
      <ThemedView style={styles.sortContainer}>
        <TouchableOpacity 
          style={[styles.sortOption, sortBy === 'title' && styles.sortOptionActive]}
          onPress={() => setSortBy('title')}>
          <ThemedText style={[styles.sortText, sortBy === 'title' && { color: tintColor }]}>
            A-Z
          </ThemedText>
        </TouchableOpacity>
        <TouchableOpacity 
          style={[styles.sortOption, sortBy === 'artist' && styles.sortOptionActive]}
          onPress={() => setSortBy('artist')}>
          <ThemedText style={[styles.sortText, sortBy === 'artist' && { color: tintColor }]}>
            Artist
          </ThemedText>
        </TouchableOpacity>
      </ThemedView>

      <ScrollView showsVerticalScrollIndicator={false}>
        {/* Songs List */}
        <ThemedView style={styles.songsList}>
          {getSortedSongs().map((song, index) => (
            <TouchableOpacity 
              key={song.id} 
              onPress={() => handleSongPress(song)}
              activeOpacity={0.7}>
              <ThemedView style={styles.songItem}>
                <ThemedView style={styles.songInfo}>
                  <ThemedView style={[styles.songNumber, { backgroundColor: iconColor + '10' }]}>
                    <ThemedText style={styles.numberText}>{index + 1}</ThemedText>
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
                <ThemedView style={styles.songMeta}>
                  <ThemedText style={styles.durationText}>{song.duration}</ThemedText>
                  <TouchableOpacity>
                    <IconSymbol name="ellipsis" size={20} color={iconColor} />
                  </TouchableOpacity>
                </ThemedView>
              </ThemedView>
            </TouchableOpacity>
          ))}
        </ThemedView>

        {/* Total count */}
        <ThemedView style={styles.totalContainer}>
          <ThemedText style={styles.totalText}>{allSongs.length} songs</ThemedText>
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
  sortContainer: {
    flexDirection: 'row',
    paddingHorizontal: 20,
    gap: 12,
    marginBottom: 16,
  },
  sortOption: {
    paddingVertical: 6,
    paddingHorizontal: 12,
    borderRadius: 16,
    backgroundColor: 'rgba(150,150,150,0.1)',
  },
  sortOptionActive: {
    backgroundColor: 'rgba(255,107,107,0.1)',
  },
  sortText: {
    fontSize: 13,
    fontWeight: '500',
  },
  songsList: {
    paddingHorizontal: 20,
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
  songNumber: {
    width: 30,
    height: 30,
    borderRadius: 15,
    justifyContent: 'center',
    alignItems: 'center',
  },
  numberText: {
    fontSize: 13,
    opacity: 0.6,
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
  songMeta: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  durationText: {
    fontSize: 13,
    opacity: 0.5,
  },
  totalContainer: {
    paddingHorizontal: 20,
    paddingVertical: 20,
    alignItems: 'center',
  },
  totalText: {
    fontSize: 13,
    opacity: 0.5,
  },
});
