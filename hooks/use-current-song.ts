import React, { createContext, useContext, useState, ReactNode } from 'react';

export interface Song {
  id: number;
  title: string;
  artist: string;
  album: string;
  duration: string;
  year?: string;
  albumArt?: string | null;
}

interface CurrentSongContextType {
  currentSong: Song | null;
  isPlaying: boolean;
  playSong: (song: Song) => void;
  pauseSong: () => void;
  resumeSong: () => void;
  nextSong: () => void;
  previousSong: () => void;
  queue: Song[];
  addToQueue: (song: Song) => void;
}

const CurrentSongContext = createContext<CurrentSongContextType | undefined>(undefined);

// Mock data for queue
const mockQueue: Song[] = [
  { id: 2, title: 'Shape of You', artist: 'Ed Sheeran', album: '÷', duration: '4:23', year: '2017' },
  { id: 3, title: 'Blinding Lights', artist: 'The Weeknd', album: 'After Hours', duration: '3:20', year: '2020' },
  { id: 4, title: 'Dance Monkey', artist: 'Tones and I', album: 'The Kids Are Coming', duration: '3:35', year: '2019' },
  { id: 5, title: 'Someone Like You', artist: 'Adele', album: '21', duration: '4:45', year: '2011' },
];

export function CurrentSongProvider({ children }: { children: ReactNode }) {
  const [currentSong, setCurrentSong] = useState<Song | null>(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [queue, setQueue] = useState<Song[]>(mockQueue);

  const playSong = (song: Song) => {
    setCurrentSong(song);
    setIsPlaying(true);
  };

  const pauseSong = () => {
    setIsPlaying(false);
  };

  const resumeSong = () => {
    if (currentSong) {
      setIsPlaying(true);
    }
  };

  const nextSong = () => {
    if (currentSong && queue.length > 0) {
      const currentIndex = queue.findIndex(s => s.id === currentSong.id);
      const nextIndex = (currentIndex + 1) % queue.length;
      setCurrentSong(queue[nextIndex]);
      setIsPlaying(true);
    }
  };

  const previousSong = () => {
    if (currentSong && queue.length > 0) {
      const currentIndex = queue.findIndex(s => s.id === currentSong.id);
      const prevIndex = (currentIndex - 1 + queue.length) % queue.length;
      setCurrentSong(queue[prevIndex]);
      setIsPlaying(true);
    }
  };

  const addToQueue = (song: Song) => {
    setQueue(prev => [...prev, song]);
  };

  return (
    <CurrentSongContext.Provider value={{
      currentSong,
      isPlaying,
      playSong,
      pauseSong,
      resumeSong,
      nextSong,
      previousSong,
      queue,
      addToQueue,
    }}>
      {children}
    </CurrentSongContext.Provider>
  );
}

export function useCurrentSong() {
  const context = useContext(CurrentSongContext);
  if (context === undefined) {
    throw new Error('useCurrentSong must be used within a CurrentSongProvider');
  }
  return context;
}
