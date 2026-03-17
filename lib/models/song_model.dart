class Song {
  final String title;
  final String artist;
  final String duration;
  final String album;
  bool isFavorite;

  Song({
    required this.title,
    required this.artist,
    required this.duration,
    required this.album,
    this.isFavorite = false,
  });
}

// Mock data
List<Song> mockSongs = [
  Song(
    title: 'Bohemian Rhapsody',
    artist: 'Queen',
    duration: '5:55',
    album: 'A Night at the Opera',
    isFavorite: false,
  ),
  Song(
    title: 'Hotel California',
    artist: 'Eagles',
    duration: '6:30',
    album: 'Hotel California',
    isFavorite: false,
  ),
];

// Mock favorites 
List<Song> favoriteSongs = [];
