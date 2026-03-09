export interface Song {
  id: string;
  title: string;
  artist: string;
  album: string;
  duration: number;
  uri: string;
  filename: string;
  size?: number;
  dateAdded?: number;
  artwork?: string | null;
}

export interface Album {
  id: string;
  name: string;
  artist: string;
  songCount: number;
  artwork?: string | null;
  songs: Song[];
}

export interface Artist {
  id: string;
  name: string;
  songCount: number;
  albumCount: number;
  songs: Song[];
  albums: Album[];
}

export interface Folder {
  id: string;
  name: string;
  path: string;
  songCount: number;
  songs: Song[];
}

export interface PlayerState {
  currentSong: Song | null;
  isPlaying: boolean;
  currentTime: number;
  duration: number;
  volume: number;
  isShuffled: boolean;
  repeatMode: 'off' | 'all' | 'one';
}

export type FilterTab = 'songs' | 'albums' | 'artists' | 'folders' | 'favourites';
