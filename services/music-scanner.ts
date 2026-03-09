import * as DocumentPicker from 'expo-document-picker';
import * as FileSystem from 'expo-file-system';
import { Platform } from 'react-native';
import { Song, Album, Artist, Folder } from '@/types/music';

// Note: For full file system access on Android, you'll need to add permissions
// This is a simplified version - in production, you'd need proper permission handling

class MusicScanner {
  private songs: Song[] = [];
  private albums: Map<string, Album> = new Map();
  private artists: Map<string, Artist> = new Map();
  private folders: Map<string, Folder> = new Map();

  async requestPermissions(): Promise<boolean> {
    if (Platform.OS === 'android') {
      // Request storage permission
      // This would need expo-media-library or similar
      return true;
    }
    return true;
  }

  async scanMusicFiles(): Promise<Song[]> {
    try {
      // For demo purposes, we'll create mock data
      // In production, you'd use MediaLibrary.getAssetsAsync({ mediaType: 'audio' })
      return this.getMockSongs();
    } catch (error) {
      console.error('Error scanning music files:', error);
      return [];
    }
  }

  private getMockSongs(): Song[] {
    // Mock data for demonstration
    return [
      {
        id: '1',
        title: 'Bohemian Rhapsody',
        artist: 'Queen',
        album: 'A Night at the Opera',
        duration: 354,
        uri: 'file:///mock/bohemian-rhapsody.mp3',
        filename: 'bohemian-rhapsody.mp3',
      },
      {
        id: '2',
        title: 'Hotel California',
        artist: 'Eagles',
        album: 'Hotel California',
        duration: 390,
        uri: 'file:///mock/hotel-california.mp3',
        filename: 'hotel-california.mp3',
      },
      {
        id: '3',
        title: 'Imagine',
        artist: 'John Lennon',
        album: 'Imagine',
        duration: 183,
        uri: 'file:///mock/imagine.mp3',
        filename: 'imagine.mp3',
      },
      {
        id: '4',
        title: 'Stairway to Heaven',
        artist: 'Led Zeppelin',
        album: 'Led Zeppelin IV',
        duration: 482,
        uri: 'file:///mock/stairway-to-heaven.mp3',
        filename: 'stairway-to-heaven.mp3',
      },
      {
        id: '5',
        title: 'Smells Like Teen Spirit',
        artist: 'Nirvana',
        album: 'Nevermind',
        duration: 301,
        uri: 'file:///mock/smells-like-teen-spirit.mp3',
        filename: 'smells-like-teen-spirit.mp3',
      },
    ];
  }

  organizeMusic(songs: Song[]): {
    songs: Song[];
    albums: Album[];
    artists: Artist[];
    folders: Folder[];
  } {
    this.songs = songs;
    this.albums.clear();
    this.artists.clear();
    this.folders.clear();

    songs.forEach(song => {
      // Organize by album
      const albumKey = `${song.album}-${song.artist}`;
      if (!this.albums.has(albumKey)) {
        this.albums.set(albumKey, {
          id: albumKey,
          name: song.album,
          artist: song.artist,
          songCount: 0,
          artwork: null,
          songs: [],
        });
      }
      const album = this.albums.get(albumKey)!;
      album.songs.push(song);
      album.songCount = album.songs.length;

      // Organize by artist
      if (!this.artists.has(song.artist)) {
        this.artists.set(song.artist, {
          id: song.artist,
          name: song.artist,
          songCount: 0,
          albumCount: 0,
          songs: [],
          albums: [],
        });
      }
      const artist = this.artists.get(song.artist)!;
      artist.songs.push(song);
      artist.songCount = artist.songs.length;
      
      // Add album to artist if not already there
      if (!artist.albums.find(a => a.name === song.album)) {
        artist.albums.push(album);
        artist.albumCount = artist.albums.length;
      }

      // Organize by folder (simplified)
      const folderPath = song.uri.substring(0, song.uri.lastIndexOf('/'));
      const folderName = folderPath.split('/').pop() || 'Unknown';
      
      if (!this.folders.has(folderPath)) {
        this.folders.set(folderPath, {
          id: folderPath,
          name: folderName,
          path: folderPath,
          songCount: 0,
          songs: [],
        });
      }
      const folder = this.folders.get(folderPath)!;
      folder.songs.push(song);
      folder.songCount = folder.songs.length;
    });

    return {
      songs: this.songs,
      albums: Array.from(this.albums.values()),
      artists: Array.from(this.artists.values()),
      folders: Array.from(this.folders.values()),
    };
  }
}

export default new MusicScanner();
