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

class Playlist {
  String name;
  List<Song> songs;

  Playlist({required this.name, List<Song>? songs}) : songs = songs ?? [];

  int get songCount => songs.length;
}

// Mock data — expanded to 10 songs
final List<Song> mockSongs = [
  Song(
    title: 'Imithandazo',
    artist: 'Kabza De Small & Mthunzi ft Young Stunna',
    duration: '5:54',
    album: 'Isimo',
  ),
  Song(
    title: 'Lavalwa Ucango',
    artist: 'Betusile',
    duration: '3:41',
    album: 'Imvuselelo',
  ),
  Song(
    title: 'Emcimbini',
    artist: 'Kabza De Small & DJ Maphorisa',
    duration: '4:22',
    album: 'Scorpion Kings',
  ),
  Song(
    title: 'Abalele',
    artist: 'Kabza De Small',
    duration: '6:10',
    album: 'I Am The King Of Amapiano',
  ),
  Song(
    title: 'Phoyisa',
    artist: 'Masterpiece YVK',
    duration: '5:02',
    album: 'Phoyisa EP',
  ),
  Song(
    title: 'Banyana',
    artist: 'Sun-El Musician ft Simmy',
    duration: '4:48',
    album: 'Ubuntu',
  ),
  Song(
    title: 'Inhliziyo',
    artist: 'Simmy',
    duration: '3:55',
    album: 'Tugela Fairy',
  ),
  Song(
    title: 'Ngisindwe',
    artist: 'Betusile',
    duration: '4:15',
    album: 'Imvuselelo',
  ),
  Song(
    title: 'Wabantu',
    artist: 'Sun-El Musician',
    duration: '5:30',
    album: 'Ubuntu',
  ),
  Song(
    title: 'Imali',
    artist: 'Kabza De Small & DJ Maphorisa',
    duration: '4:05',
    album: 'Scorpion Kings',
  ),
];
