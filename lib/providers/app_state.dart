import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;

import '../models/song_model.dart';
import '../models/mood_model.dart';
import '../services/youtube_service.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AppState extends ChangeNotifier {
  // Playback
  Song? _currentSong;
  bool _isPlaying = false;
  bool _isShuffleOn = false;
  bool _isRepeatOn = false;
  late final AudioPlayer _audioPlayer;
  final OnAudioQuery _audioQuery = OnAudioQuery();
  AndroidEqualizer? _androidEqualizer;
  AndroidEqualizerParameters? _equalizerParameters;
  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  bool get isShuffleOn => _isShuffleOn;
  bool get isRepeatOn => _isRepeatOn;

  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration> get bufferedPositionStream => _audioPlayer.bufferedPositionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  // Library
  List<Song> _songs = [];
  List<Song> get songs => List.unmodifiable(_songs);

  List<Song> get favoriteSongs =>
      _songs.where((s) => s.isFavorite).toList();

  bool _isScanning = false;
  bool get isScanning => _isScanning;

  // Playlists
  final List<Playlist> _playlists = [];
  List<Playlist> get playlists => List.unmodifiable(_playlists);

  // Theme
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // Settings
  bool notificationsEnabled = true;
  bool autoDownloadEnabled = false;
  bool equalizerEnabled = false;
  String audioQuality = 'High';
  String storageLocation = 'Internal Storage';

  // Mode
  String _appMode = 'offline';
  String get appMode => _appMode;

  Mood? _currentMood;
  Mood? get currentMood => _currentMood;

  // Equalizer
  List<double> _equalizerGains = [0.0, 0.0, 0.0, 0.0, 0.0]; // 60, 230, 910, 4k, 14k
  String _activePreset = 'Flat';

  List<double> get equalizerGains => _equalizerGains;
  String get activePreset => _activePreset;

  // Sorting
  String _sortOrder = 'A-Z'; // 'A-Z' or 'Z-A'
  String get sortOrder => _sortOrder;

  AppState() {
    _initAudio();
  }

  void _initAudio() {
    if (!kIsWeb && Platform.isAndroid) {
      _androidEqualizer = AndroidEqualizer();
      _audioPlayer = AudioPlayer(
        audioPipeline: AudioPipeline(androidAudioEffects: [_androidEqualizer!]),
      );
      _androidEqualizer!.parameters.then((params) {
        _equalizerParameters = params;
        _applyEqualizerGains();
      });
    } else {
      _audioPlayer = AudioPlayer();
    }

    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
      
      if (state.processingState == ProcessingState.completed) {
        
        Future.delayed(const Duration(seconds: 1), () {
          if (_isRepeatOn) {
            if (_currentSong != null) playSong(_currentSong!);
          } else {
            nextSong();
          }
        });
      }
    });
  }

  // Artists/Albums (derived)
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

  // Playback Methods
  Future<void> playSong(Song song) async {
    _currentSong = song;
    notifyListeners();
    try {
      if (song.isOnline && song.filePath != null) {
        debugPrint('Attempting to play online song: ${song.title} at ${song.filePath}');
        final streamUrl = await YouTubeService.getAudioStreamUrl(song.filePath!);
        if (streamUrl != null) {
          debugPrint('Got stream URL: $streamUrl');
          await _audioPlayer.stop(); // Stop current before setting new source
          await _audioPlayer.setUrl(streamUrl);
          await _audioPlayer.play();
        } else {
          debugPrint('Failed to get stream URL for ${song.title}');
        }
      } else if (song.filePath != null && !kIsWeb) {
        await _audioPlayer.stop();
        await _audioPlayer.setFilePath(song.filePath!);
        await _audioPlayer.play();
      } else {
        await _audioPlayer.play();
      }
    } catch (e) {
      debugPrint('Error playing song: $e');
    }
  }

  Future<void> playOnlineItem(Map<String, String> item) async {
    final link = item['link'];
    if (link == null) return;
    
    final durationSeconds = int.tryParse(item['duration'] ?? '0') ?? 0;
    final min = durationSeconds ~/ 60;
    final sec = (durationSeconds % 60).toString().padLeft(2, '0');
    final formattedDuration = '$min:$sec';

    final song = Song(
      title: item['title'] ?? 'Unknown',
      artist: item['channel'] ?? 'Unknown',
      duration: formattedDuration,
      album: 'Online Search',
      isOnline: true,
      filePath: link,
    );
    await playSong(song);
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> seekForward([int seconds = 10]) async {
    final pos = _audioPlayer.position + Duration(seconds: seconds);
    await _audioPlayer.seek(pos);
  }

  Future<void> seekBackward([int seconds = 10]) async {
    final pos = _audioPlayer.position - Duration(seconds: seconds);
    await _audioPlayer.seek(pos < Duration.zero ? Duration.zero : pos);
  }

  Future<void> togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
    } catch (e) {
      debugPrint('Error toggling play/pause: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      debugPrint('Error pausing: $e');
    }
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

  // Favourite Methods
  void toggleFavorite(Song song) {
    song.isFavorite = !song.isFavorite;
    notifyListeners();
  }

  // Music Scanning
  Future<void> scanMusic() async {
    if (_isScanning) return;
    _isScanning = true;
    notifyListeners();

    try {
      if (!kIsWeb && Platform.isAndroid) {
        // Request permissions
        bool hasPermission = await _audioQuery.permissionsStatus();
        if (!hasPermission) {
          hasPermission = await _audioQuery.permissionsRequest();
        }

        if (!hasPermission) {
          _isScanning = false;
          notifyListeners();
          return;
        }

        // Query all songs using MediaStore
        final List<SongModel> songs = await _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        );

        final List<Song> foundSongs = songs.map((s) {
          // Calculate duration string from milliseconds
          final durationMs = s.duration ?? 0;
          final min = (durationMs ~/ 1000) ~/ 60;
          final sec = ((durationMs ~/ 1000) % 60).toString().padLeft(2, '0');
          
          return Song(
            title: s.title,
            artist: s.artist == '<unknown>' ? 'Unknown Artist' : s.artist!,
            duration: '$min:$sec',
            album: s.album == '<unknown>' ? 'Unknown Album' : s.album!,
            isFavorite: false,
            filePath: s.data,
            isOnline: false,
          );
        }).toList();

        if (foundSongs.isNotEmpty) {
          _songs = foundSongs;
        }
      } else if (!kIsWeb && Platform.isWindows) {

        final home = Platform.environment['USERPROFILE'];
        final List<Directory> scanDirs = [];
        if (home != null) {
          scanDirs.add(Directory(p.join(home, 'Music')));
          scanDirs.add(Directory(p.join(home, 'Downloads')));
          scanDirs.add(Directory(p.join(home, 'Documents')));
          scanDirs.add(Directory(p.join(home, 'Pictures')));
          scanDirs.add(Directory(p.join(home, 'Desktop')));
        }

        // Check for external drives (D: to Z:)
        for (var letter in 'DEFGHIJKLMNOPQRSTUVWXYZ'.split('')) {
          final drive = Directory('$letter:\\');
          try {
            if (await drive.exists()) {
              scanDirs.add(drive);
            }
          } catch (_) {
          }
        }

        final List<Song> foundSongs = [];
        for (var musicDir in scanDirs) {
          if (await musicDir.exists()) {
            try {
              await for (var entity in musicDir.list(recursive: true, followLinks: false)) {
                if (entity is File && entity.path.toLowerCase().endsWith('.mp3')) {
                  final fileName = p.basenameWithoutExtension(entity.path);
                  foundSongs.add(Song(
                    title: fileName,
                    artist: 'Unknown Artist',
                    duration: '0:00', 
                    album: 'Local Music',
                    isFavorite: false,
                    filePath: entity.path,
                    isOnline: false,
                  ));
                }
              }
            } catch (e) {
              debugPrint('Error scanning $musicDir: $e');
            }
          }
        }
        
        if (foundSongs.isNotEmpty) {
          _songs = foundSongs;
        }
      }
    } catch (e) {
      debugPrint('Error scanning music: $e');
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }

  // Playlist Methods
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

  // Theme/Mode
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

  // Settings
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
    if (_androidEqualizer != null) {
      _androidEqualizer!.setEnabled(value);
    }
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

  void setMood(Mood? mood) {
    _currentMood = mood;
    notifyListeners();
  }

  // Equalizer Methods
  void setEqualizerGain(int index, double gain) {
    if (index >= 0 && index < _equalizerGains.length) {
      _equalizerGains[index] = gain;
      _activePreset = 'Custom';
      _applyEqualizerGains();
      notifyListeners();
    }
  }

  void setEqualizerPreset(String preset) {
    _activePreset = preset;
    setEqualizer(true); // Automatically enable equalizer when a preset is selected
    switch (preset) {
      case 'Flat':
        _equalizerGains = [0.0, 0.0, 0.0, 0.0, 0.0];
        break;
      case 'Pop':
        break;
      case 'Rock':
        _equalizerGains = [3.5, 2.0, -1.0, 1.5, 3.0];
        break;
      case 'Bass Boost':
        _equalizerGains = [6.0, 4.0, 0.0, 0.0, 0.0];
        break;
      case 'Classical':
        _equalizerGains = [2.0, 1.5, 0.0, 2.5, 1.0];
        break;
    }
    _applyEqualizerGains();
    notifyListeners();
  }

  void _applyEqualizerGains() {
    if (_equalizerParameters != null) {
      for (int i = 0; i < _equalizerGains.length && i < _equalizerParameters!.bands.length; i++) {
        _equalizerParameters!.bands[i].setGain(_equalizerGains[i]);
      }
    }
  }

  // Online Search
  List<Map<String, String>> _onlineSearchResults = [];
  List<Map<String, String>> get onlineSearchResults => List.unmodifiable(_onlineSearchResults);
  
  bool _isSearchingOnline = false;
  bool get isSearchingOnline => _isSearchingOnline;

  Future<void> searchOnline(String query) async {
    if (query.isEmpty) return;
    _isSearchingOnline = true;
    notifyListeners();
    
    try {
      final results = await YouTubeService.searchVideos(query);
      _onlineSearchResults = results;
    } finally {
      _isSearchingOnline = false;
      notifyListeners();
    }
  }

  void clearOnlineResults() {
    _onlineSearchResults = [];
    notifyListeners();
  }

  // Sorting Logic
  void setSortOrder(String order) {
    _sortOrder = order;
    _applySort();
    notifyListeners();
  }

  void _applySort() {
    if (_sortOrder == 'A-Z') {
      _songs.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    } else {
      _songs.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
    }
  }
}
