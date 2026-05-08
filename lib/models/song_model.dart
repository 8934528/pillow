class Song {
  final String title;
  final String artist;
  final String duration;
  final String album;
  final String? filePath;
  final bool isOnline;
  bool isFavorite;

  Song({
    required this.title,
    required this.artist,
    required this.duration,
    required this.album,
    this.filePath,
    this.isOnline = false,
    this.isFavorite = false,
  });
}

class Playlist {
  String name;
  List<Song> songs;

  Playlist({required this.name, List<Song>? songs}) : songs = songs ?? [];

  int get songCount => songs.length;
}
