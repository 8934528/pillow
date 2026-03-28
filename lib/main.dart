import 'package:flutter/material.dart';
import 'dart:ui';
import 'screens/songs_page.dart';
import 'screens/artists_page.dart';
import 'screens/playlists_page.dart';
import 'screens/albums_page.dart';
import 'screens/favourites_page.dart';
import 'screens/now_playing.dart';
import 'models/song_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pillow Music Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF0000),
          primary: const Color(0xFFFF0000),
          secondary: const Color(0xFFFFA500),
          tertiary: const Color(0xFFFF5349),
          surface: const Color(0xFFD3D3D3),
        ),
        scaffoldBackgroundColor: const Color(0xFFD3D3D3),
        useMaterial3: true,
      ),
      home: const MainMusicPage(),
    );
  }
}

// Custom page route for slide up animation
class SlideUpPageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;
  
  SlideUpPageRoute({required this.builder})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
}

class MainMusicPage extends StatefulWidget {
  const MainMusicPage({super.key});

  @override
  State<MainMusicPage> createState() => _MainMusicPageState();
}

class _MainMusicPageState extends State<MainMusicPage> {
  int _selectedIndex = 0;
  late final PageController _pageController;
  
  // Mini player visibility state
  bool _isMiniPlayerVisible = true;
  
  // Current playing song (for mini player and now playing)
  Song? _currentSong;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    
    // Set default current song
    _currentSong = mockSongs[0];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    
    setState(() {
      _selectedIndex = index;
    });
    
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  void _updateMiniPlayerVisibility(bool isVisible) {
    if (_isMiniPlayerVisible != isVisible) {
      setState(() {
        _isMiniPlayerVisible = isVisible;
      });
    }
  }

  void _updatePlaybackState(bool isPlaying, {Song? song}) {
    setState(() {
      _isPlaying = isPlaying;
      if (song != null) {
        _currentSong = song;
      }
      if (isPlaying) {
        _isMiniPlayerVisible = true;
      }
    });
  }

  void _navigateToNowPlaying() {
    if (_currentSong != null) {
      Navigator.push(
        context,
        SlideUpPageRoute(
          builder: (context) => NowPlayingPage(
            song: _currentSong!,
            isPlaying: _isPlaying,
            onPlaybackStateChanged: _updatePlaybackState,
            onClose: () {
              Navigator.pop(context);
            },
          ),
        ),
      ).then((_) {
        if (_isPlaying) {
          setState(() {
            _isMiniPlayerVisible = true;
          });
        }
      });
    }
  }

  Widget _buildNavBarItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              right: index < 4
                  ? BorderSide(
                      color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.1),
                      width: 1,
                    )
                  : BorderSide.none,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    icon,
                    color: isSelected 
                        ? const Color(0xFFFF0000) 
                        : Colors.grey,
                    size: 24,
                  ),
                  if (isSelected)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF0000),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected 
                      ? const Color(0xFFFF0000) 
                      : Colors.grey,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3D3D3),
      body: Stack(
        children: [
          // Page View for smooth transitions
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: [
              SongsPage(
                onPlaySong: (song) {
                  _updatePlaybackState(true, song: song);
                  _navigateToNowPlaying();
                },
                songCount: mockSongs.length,
              ),
              const ArtistsPage(),
              PlaylistsPage(
                onPlayPlaylist: (playlistName) {
                  _updatePlaybackState(true, song: mockSongs[0]);
                  _navigateToNowPlaying();
                },
              ),
              const AlbumsPage(),
              FavouritesPage(
                onPlaySong: (song) {
                  _updatePlaybackState(true, song: song);
                  _navigateToNowPlaying();
                },
              ),
            ],
          ),
          
          // Mini Player positioned above bottom nav
          if (_currentSong != null && (_isPlaying || _isMiniPlayerVisible))
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: 20,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: (_isPlaying || _isMiniPlayerVisible) ? 1.0 : 0.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: MiniPlayer(
                    key: ValueKey(_currentSong!.title),
                    song: _currentSong!,
                    isPlaying: _isPlaying,
                    onVisibilityChanged: _updateMiniPlayerVisibility,
                    onTap: _navigateToNowPlaying,
                    onPlayPause: () {
                      _updatePlaybackState(!_isPlaying);
                    },
                    onNext: () {
                      int currentIndex = mockSongs.indexOf(_currentSong!);
                      int nextIndex = (currentIndex + 1) % mockSongs.length;
                      _updatePlaybackState(true, song: mockSongs[nextIndex]);
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                _buildNavBarItem(0, Icons.music_note, 'Songs'),
                _buildNavBarItem(1, Icons.person, 'Artists'),
                _buildNavBarItem(2, Icons.playlist_play, 'Playlists'),
                _buildNavBarItem(3, Icons.album, 'Albums'),
                _buildNavBarItem(4, Icons.favorite, 'Favourites'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MiniPlayer extends StatefulWidget {
  final Song song;
  final bool isPlaying;
  final Function(bool) onVisibilityChanged;
  final VoidCallback onTap;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  
  const MiniPlayer({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.onVisibilityChanged,
    required this.onTap,
    required this.onPlayPause,
    required this.onNext,
  });

  @override
  State<MiniPlayer> createState() => MiniPlayerState();
}

class MiniPlayerState extends State<MiniPlayer> with TickerProviderStateMixin {
  late AnimationController _timerController;
  late Animation<double> _timerAnimation;
  bool _isTimerRunning = false;
  
  @override
  void initState() {
    super.initState();
    
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );
    
    _timerAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _timerController, curve: Curves.linear),
    );
    
    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted && !widget.isPlaying) {
          widget.onVisibilityChanged(false);
          _isTimerRunning = false;
        }
      }
    });
    
    if (!widget.isPlaying) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(MiniPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _stopTimer();
        widget.onVisibilityChanged(true);
      } else {
        _startTimer();
      }
    }
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }
  
  void _startTimer() {
    _timerController.reset();
    widget.onVisibilityChanged(true);
    _timerController.forward();
    setState(() {
      _isTimerRunning = true;
    });
  }
  
  void _stopTimer() {
    _timerController.stop();
    _timerController.reset();
    setState(() {
      _isTimerRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 142, 142, 142).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isTimerRunning)
                    AnimatedBuilder(
                      animation: _timerAnimation,
                      builder: (context, child) {
                        return Container(
                          height: 2,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: LinearProgressIndicator(
                            value: _timerAnimation.value,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              const Color(0xFFFF0000).withValues(alpha: 0.8),
                            ),
                          ),
                        );
                      },
                    ),
                  
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFFFF0000).withValues(alpha: 0.2),
                              const Color(0xFFFF0000).withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.song.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.song.artist,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: widget.onPlayPause,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF0000).withValues(alpha: 0.8),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                widget.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: widget.onNext,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.skip_next,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
