import 'package:flutter/material.dart';
import '../models/song_model.dart';

class AppState extends ChangeNotifier {
  // ── Playback ────────────────────────────────────────────────────
  Song? _currentSong;
  bool _isPlaying = false;
  bool _isShuffleOn = false;
  bool _isRepeatOn = false;

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  bool get isShuffleOn => _isShuffleOn;
  bool get isRepeatOn => _isRepeatOn;

  // ── Library ─────────────────────────────────────────────────────
  final List<Song> _songs = [...mockSongs];
  List<Song> get songs => List.unmodifiable(_songs);

  List<Song> get favoriteSongs =>
      _songs.where((s) => s.isFavorite).toList();

  // ── Playlists ───────────────────────────────────────────────────
  final List<Playlist> _playlists = [];
  List<Playlist> get playlists => List.unmodifiable(_playlists);

  // ── Theme ───────────────────────────────────────────────────────
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // ── Settings ────────────────────────────────────────────────────
  bool notificationsEnabled = true;
  bool autoDownloadEnabled = false;
  bool equalizerEnabled = false;
  String audioQuality = 'High';
  String storageLocation = 'Internal Storage';

  // ── Mode ────────────────────────────────────────────────────────
  String _appMode = 'offline'; // 'offline' | 'online'
  String get appMode => _appMode;

  // ── Artists/Albums (derived) ─────────────────────────────────────
  List<String> get artists {
    final set = <String>{};
    for (final s in _songs) {
      set.add(s.artist);
    }
    return set.toList()..sort();
  }

  List<String> get albums {
    final set = <String>{};
    for (final s in _songs) {
      set.add(s.album);
    }
    return set.toList()..sort();
  }

  List<Song> songsForArtist(String artist) =>
      _songs.where((s) => s.artist == artist).toList();

  List<Song> songsForAlbum(String album) =>
      _songs.where((s) => s.album == album).toList();

  // ── Playback Methods ─────────────────────────────────────────────
  void playSong(Song song) {
    _currentSong = song;
    _isPlaying = true;
    notifyListeners();
  }

  void togglePlayPause() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    notifyListeners();
  }

  void nextSong() {
    if (_currentSong == null) return;
    final idx = _songs.indexOf(_currentSong!);
    if (_isShuffleOn) {
      final newIdx = (idx + 1 + (_songs.length * 0.7).toInt()) % _songs.length;
      _currentSong = _songs[newIdx];
    } else {
      _currentSong = _songs[(idx + 1) % _songs.length];
    }
    _isPlaying = true;
    notifyListeners();
  }

  void prevSong() {
    if (_currentSong == null) return;
    final idx = _songs.indexOf(_currentSong!);
    _currentSong = _songs[(idx - 1 + _songs.length) % _songs.length];
    _isPlaying = true;
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffleOn = !_isShuffleOn;
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeatOn = !_isRepeatOn;
    notifyListeners();
  }

  // ── Favourite Methods ────────────────────────────────────────────
  void toggleFavorite(Song song) {
    song.isFavorite = !song.isFavorite;
    notifyListeners();
  }

  void setFavorite(Song song, bool value) {
    if (song.isFavorite != value) {
      song.isFavorite = value;
      notifyListeners();
    }
  }

  // ── Playlist Methods ─────────────────────────────────────────────
  void createPlaylist(String name) {
    if (name.trim().isEmpty) return;
    _playlists.add(Playlist(name: name.trim()));
    notifyListeners();
  }

  void deletePlaylist(int index) {
    if (index >= 0 && index < _playlists.length) {
      _playlists.removeAt(index);
      notifyListeners();
    }
  }

  void renamePlaylist(int index, String newName) {
    if (index >= 0 && index < _playlists.length && newName.trim().isNotEmpty) {
      _playlists[index].name = newName.trim();
      notifyListeners();
    }
  }

  void addSongToPlaylist(int playlistIndex, Song song) {
    if (playlistIndex >= 0 && playlistIndex < _playlists.length) {
      if (!_playlists[playlistIndex].songs.contains(song)) {
        _playlists[playlistIndex].songs.add(song);
        notifyListeners();
      }
    }
  }

  void removeSongFromPlaylist(int playlistIndex, Song song) {
    if (playlistIndex >= 0 && playlistIndex < _playlists.length) {
      _playlists[playlistIndex].songs.remove(song);
      notifyListeners();
    }
  }

  // ── Theme Methods ────────────────────────────────────────────────
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    if (_isDarkMode != value) {
      _isDarkMode = value;
      notifyListeners();
    }
  }

  // ── Mode Methods ─────────────────────────────────────────────────
  void setAppMode(String mode) {
    _appMode = mode;
    notifyListeners();
  }

  // ── Settings Methods ─────────────────────────────────────────────
  void setNotifications(bool value) {
    notificationsEnabled = value;
    notifyListeners();
  }

  void setAutoDownload(bool value) {
    autoDownloadEnabled = value;
    notifyListeners();
  }

  void setEqualizer(bool value) {
    equalizerEnabled = value;
    notifyListeners();
  }

  void setAudioQuality(String quality) {
    audioQuality = quality;
    notifyListeners();
  }

  void setStorageLocation(String location) {
    storageLocation = location;
    notifyListeners();
  }
}
