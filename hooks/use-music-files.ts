import { useState, useEffect } from 'react';
import { Song, Album, Artist, Folder } from '@/types/music';
import musicScanner from '@/services/music-scanner';

export function useMusicFiles() {
  const [songs, setSongs] = useState<Song[]>([]);
  const [albums, setAlbums] = useState<Album[]>([]);
  const [artists, setArtists] = useState<Artist[]>([]);
  const [folders, setFolders] = useState<Folder[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    loadMusicFiles();
  }, []);

  const loadMusicFiles = async () => {
    try {
      setLoading(true);
      const hasPermission = await musicScanner.requestPermissions();
      
      if (!hasPermission) {
        setError('Permission denied to access music files');
        return;
      }

      const scannedSongs = await musicScanner.scanMusicFiles();
      const organized = musicScanner.organizeMusic(scannedSongs);
      
      setSongs(organized.songs);
      setAlbums(organized.albums);
      setArtists(organized.artists);
      setFolders(organized.folders);
    } catch (err) {
      setError('Failed to load music files');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const refresh = () => {
    loadMusicFiles();
  };

  return {
    songs,
    albums,
    artists,
    folders,
    loading,
    error,
    refresh,
  };
}
