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

// Custom page route for slide up animation
class SlideUpPageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  SlideUpPageRoute({required this.builder})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            final offsetAnimation = animation.drive(tween);

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
        SlideUpPageRoute(
          builder: (context) => const NowPlayingPage(),
        ),
      ).then((_) {
        if (appState.isPlaying) {
          setState(() => _isMiniPlayerVisible = true);
        }
      });
    }
  }

  Widget _buildNavBarItem(
    int index,
    IconData icon,
    String label,
    bool isDark,
  ) {
    final isSelected = _selectedIndex == index;
    final activeColor = const Color(0xFFFF0000);
    final inactiveColor = isDark ? Colors.grey[400]! : Colors.grey;

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
                      color: (isDark ? Colors.white : Colors.black)
                          .withValues(alpha: 0.08),
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
                    color: isSelected ? activeColor : inactiveColor,
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
                  color: isSelected ? activeColor : inactiveColor,
                  fontSize: 11,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
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
    final showMiniPlayer =
        hasSong && (appState.isPlaying || _isMiniPlayerVisible);

    final bgColor =
        isDark ? const Color(0xFF121212) : const Color(0xFFD3D3D3);
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

          // Mini Player
          if (showMiniPlayer)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: 8,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: showMiniPlayer ? 1.0 : 0.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: MiniPlayer(
                    key: ValueKey(appState.currentSong!.title),
                    onTap: _navigateToNowPlaying,
                    onVisibilityChanged: (v) {
                      setState(() => _isMiniPlayerVisible = v);
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBgColor,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
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
                _buildNavBarItem(0, Icons.music_note, 'Songs', isDark),
                _buildNavBarItem(1, Icons.person, 'Artists', isDark),
                _buildNavBarItem(
                    2, Icons.playlist_play, 'Playlists', isDark),
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

// ─────────────────────────────────────────────
// Mini Player
// ─────────────────────────────────────────────
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

class _MiniPlayerState extends State<MiniPlayer>
    with TickerProviderStateMixin {
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
          widget.onVisibilityChanged(false);
          _isTimerRunning = false;
        }
      }
    });

    final appState = context.read<AppState>();
    if (!appState.isPlaying) _startTimer();
  }

  @override
  void didUpdateWidget(MiniPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final appState = context.read<AppState>();
    if (appState.isPlaying) {
      _stopTimer();
      widget.onVisibilityChanged(true);
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
    widget.onVisibilityChanged(true);
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

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF2A2A2A).withValues(alpha: 0.95)
              : const Color(0xFF8E8E8E).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: (isDark ? Colors.white : Colors.black)
                .withValues(alpha: 0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
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
              color: (isDark ? Colors.black : Colors.black)
                  .withValues(alpha: 0.1),
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
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              const Color(0xFFFF0000).withValues(alpha: 0.8),
                            ),
                          ),
                        );
                      },
                    ),
                  Row(
                    children: [
                      // Album art
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFFFF0000).withValues(alpha: 0.2),
                              const Color(0xFFFF0000).withValues(alpha: 0.9),
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
                      // Song info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              song.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              song.artist,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Controls
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => appState.togglePlayPause(),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF0000)
                                    .withValues(alpha: 0.85),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => appState.nextSong(),
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
