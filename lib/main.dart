import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/songs_page.dart';
import 'screens/artists_page.dart';
import 'screens/playlists_page.dart';
import 'screens/albums_page.dart';
import 'screens/favourites_page.dart';
import 'screens/now_playing.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppState>().isDarkMode;

    return MaterialApp(
      title: 'Pillow Music Player',
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      home: const MainMusicPage(),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF0000),
        primary: const Color(0xFFFF0000),
        secondary: const Color(0xFFFFA500),
        tertiary: const Color(0xFFFF5349),
        surface: const Color(0xFFD3D3D3),
      ),
      scaffoldBackgroundColor: const Color(0xFFD3D3D3),
      useMaterial3: true,
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: const Color(0xFFFF0000),
        primary: const Color(0xFFFF0000),
        secondary: const Color(0xFFFFA500),
        tertiary: const Color(0xFFFF5349),
        surface: const Color(0xFF1A1A1A),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      useMaterial3: true,
    );
  }
}

class SlideUpPageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;
  SlideUpPageRoute({required this.builder})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
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
  bool _isMiniPlayerVisible = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  void _navigateToNowPlaying() {
    final appState = context.read<AppState>();
    if (appState.currentSong != null) {
      Navigator.push(
        context,
        SlideUpPageRoute(builder: (context) => const NowPlayingPage()),
      );
    }
  }

  Widget _buildNavBarItem(int index, IconData icon, String label, bool isDark) {
    final isSelected = _selectedIndex == index;
    final activeColor = const Color(0xFFFF0000);
    final inactiveColor = isDark ? Colors.grey[400]! : Colors.grey;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? activeColor : inactiveColor,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? activeColor : inactiveColor,
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
    final appState = context.watch<AppState>();
    final isDark = appState.isDarkMode;
    final hasSong = appState.currentSong != null;
    final showMiniPlayer = hasSong && (appState.isPlaying || _isMiniPlayerVisible);

    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFD3D3D3);
    final navBgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _selectedIndex = index);
            },
            children: const [
              SongsPage(),
              ArtistsPage(),
              PlaylistsPage(),
              AlbumsPage(),
              FavouritesPage(),
            ],
          ),
          if (showMiniPlayer)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: 12,
              left: 12,
              right: 12,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: 1.0,
                child: MiniPlayer(
                  key: ValueKey(appState.currentSong!.title),
                  onTap: _navigateToNowPlaying,
                  onVisibilityChanged: (v) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _isMiniPlayerVisible = v);
                    });
                  },
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                _buildNavBarItem(0, Icons.music_note, 'Songs', isDark),
                _buildNavBarItem(1, Icons.person, 'Artists', isDark),
                _buildNavBarItem(2, Icons.playlist_play, 'Playlists', isDark),
                _buildNavBarItem(3, Icons.album, 'Albums', isDark),
                _buildNavBarItem(4, Icons.favorite, 'Favourites', isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MiniPlayer extends StatefulWidget {
  final VoidCallback onTap;
  final Function(bool) onVisibilityChanged;

  const MiniPlayer({
    super.key,
    required this.onTap,
    required this.onVisibilityChanged,
  });

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> with TickerProviderStateMixin {
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
        final appState = context.read<AppState>();
        if (mounted && !appState.isPlaying) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onVisibilityChanged(false);
          });
          setState(() => _isTimerRunning = false);
        }
      }
    });
    final appState = context.read<AppState>();
    if (!appState.isPlaying && appState.currentSong != null) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(MiniPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final appState = context.read<AppState>();
    if (appState.isPlaying) {
      _stopTimer();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onVisibilityChanged(true);
      });
    } else {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timerController.reset();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onVisibilityChanged(true);
    });
    _timerController.forward();
    if (mounted) setState(() => _isTimerRunning = true);
  }

  void _stopTimer() {
    _timerController.stop();
    _timerController.reset();
    if (mounted) setState(() => _isTimerRunning = false);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final song = appState.currentSong!;
    final isPlaying = appState.isPlaying;
    final isDark = appState.isDarkMode;

    return Material(
      color: Colors.transparent,
      elevation: 8,
      borderRadius: BorderRadius.circular(20),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isTimerRunning)
                  Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: AnimatedBuilder(
                      animation: _timerAnimation,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: _timerAnimation.value,
                          backgroundColor: Color(0xFFFF0000).withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFFF0000)),
                        );
                      },
                    ),
                  ),
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [const Color(0xFFFF0000), const Color(0xFFFF5349)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.music_note, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            song.title,
                            style: const TextStyle(
                              color: Color(0xFFFF0000),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            song.artist,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
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
                        IconButton(
                          onPressed: () => appState.togglePlayPause(),
                          icon: Icon(
                            isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                            color: const Color(0xFFFF0000),
                            size: 32,
                          ),
                        ),
                        IconButton(
                          onPressed: () => appState.nextSong(),
                          icon: const Icon(Icons.skip_next, color: Color(0xFFFF0000), size: 28),
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
    );
  }
}
