import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart' as p;
import '../models/song_model.dart';

class AppState extends ChangeNotifier {
  // ── Playback ────────────────────────────────────────────────────
  Song? _currentSong;
  bool _isPlaying = false;
  bool _isShuffleOn = false;
  bool _isRepeatOn = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  bool get isShuffleOn => _isShuffleOn;
  bool get isRepeatOn => _isRepeatOn;

  // ── Library ─────────────────────────────────────────────────────
  List<Song> _songs = [...mockSongs];
  List<Song> get songs => List.unmodifiable(_songs);

  List<Song> get favoriteSongs =>
      _songs.where((s) => s.isFavorite).toList();

  bool _isScanning = false;
  bool get isScanning => _isScanning;

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
  String _appMode = 'offline';
  String get appMode => _appMode;

  AppState() {
    _initAudio();
  }

  void _initAudio() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      if (_isRepeatOn) {
        if (_currentSong != null) playSong(_currentSong!);
      } else {
        nextSong();
      }
    });
  }

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
  Future<void> playSong(Song song) async {
    _currentSong = song;
    // Note: In a real app with files, we would use Source.deviceFile(song.filePath)
    // For now, we mock the play command.
    await _audioPlayer.resume(); 
    _isPlaying = true;
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void nextSong() {
    if (_currentSong == null || _songs.isEmpty) return;
    final idx = _songs.indexOf(_currentSong!);
    if (_isShuffleOn) {
      final newIdx = (idx + 1 + (_songs.length * 0.7).toInt()) % _songs.length;
      playSong(_songs[newIdx]);
    } else {
      playSong(_songs[(idx + 1) % _songs.length]);
    }
  }

  void prevSong() {
    if (_currentSong == null || _songs.isEmpty) return;
    final idx = _songs.indexOf(_currentSong!);
    playSong(_songs[(idx - 1 + _songs.length) % _songs.length]);
  }

  void toggleShuffle() {
    _isShuffleOn = !_isShuffleOn;
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeatOn = !_isRepeatOn;
    notifyListeners();
  }

  // ── Favourite Methods ───────────────────────────────────────────
  void toggleFavorite(Song song) {
    song.isFavorite = !song.isFavorite;
    notifyListeners();
  }

  // ── Music Scanning ──────────────────────────────────────────────
  Future<void> scanMusic() async {
    if (_isScanning) return;
    _isScanning = true;
    notifyListeners();

    try {
      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (status.isDenied) {
          _isScanning = false;
          notifyListeners();
          return;
        }
      }

      Directory? musicDir;
      if (Platform.isWindows) {
        // Music folder on Windows
        final home = Platform.environment['USERPROFILE'];
        if (home != null) {
          musicDir = Directory(p.join(home, 'Music'));
        }
      } else {
        musicDir = await getExternalStorageDirectory();
      }

      if (musicDir != null && await musicDir.exists()) {
        final List<Song> foundSongs = [];
        await for (var entity in musicDir.list(recursive: true, followLinks: false)) {
          if (entity is File && entity.path.endsWith('.mp3')) {
            final fileName = p.basenameWithoutExtension(entity.path);
            foundSongs.add(Song(
              title: fileName,
              artist: 'Unknown Artist',
              duration: '3:00', // Mock duration as reading metadata is complex without tags lib
              album: 'Local Music',
              isFavorite: false,
            ));
          }
        }
        
        if (foundSongs.isNotEmpty) {
          _songs = [...mockSongs, ...foundSongs];
        }
      }
    } catch (e) {
      print('Error scanning music: $e');
    }

    _isScanning = false;
    notifyListeners();
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

  // ── Theme/Mode ──────────────────────────────────────────────────
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void setAppMode(String mode) {
    _appMode = mode;
    notifyListeners();
  }

  // ── Settings ────────────────────────────────────────────────────
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
