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
    title: 'Imithandazo',
    artist: 'Kabza De Small & Mthunzi ft Young Stunna',
    duration: '5:54',
    album: 'Isimo',
    isFavorite: false,
  ),
  Song(
    title: 'Lavalwa Ucango',
    artist: 'Betusile',
    duration: '3:41',
    album: 'Imvuselelo',
    isFavorite: false,
  ),
];

// Mock favorites 
List<Song> favoriteSongs = [];
