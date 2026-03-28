import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    final appState = context.read<AppState>();
    if (appState.isPlaying) _rotationController.repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _updateRotation(bool isPlaying) {
    if (isPlaying) {
      if (!_rotationController.isAnimating) _rotationController.repeat();
    } else {
      if (_rotationController.isAnimating) _rotationController.stop();
    }
  }

  void _showToast(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
            isError ? const Color(0xFFFF5349) : const Color(0xFFFF0000),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showFeatureComingSoon() =>
      _showToast('Feature coming soon!', isError: true);

  void _showMoreOptionsModal(AppState appState) {
    final isDark = appState.isDarkMode;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        double volume = 0.7;
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                const Text('More Options',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF0000))),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.volume_up,
                      color: Color(0xFFFF0000)),
                  title: const Text('Volume'),
                  subtitle: Slider(
                    value: volume,
                    onChanged: (v) => setLocal(() => volume = v),
                    activeColor: const Color(0xFFFF0000),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading:
                      const Icon(Icons.playlist_add, color: Color(0xFFFF0000)),
                  title: const Text('Add to playlist'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _showFeatureComingSoon();
                  },
                ),
                const Divider(),
                ListTile(
                  leading:
                      const Icon(Icons.share, color: Color(0xFFFF0000)),
                  title: const Text('Share'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _showFeatureComingSoon();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final song = appState.currentSong;

    if (song == null) {
      return const Scaffold(
        body: Center(child: Text('No song selected')),
      );
    }

    final isPlaying = appState.isPlaying;
    final isDark = appState.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFD3D3D3);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textPrimary = isDark ? Colors.white : Colors.black87;

    // Sync animation to playback state
    _updateRotation(isPlaying);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_downward, color: Color(0xFFFF0000)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Now Playing',
          style: TextStyle(
              color: Color(0xFFFF0000), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Color(0xFFFF0000)),
            onPressed: _showFeatureComingSoon,
          ),
        ],
      ),
      body: Column(
        children: [
          // Rotating disc art
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF0000).withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: isPlaying
                        ? _rotationController.value * 2 * 3.14159
                        : 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFFF0000).withValues(alpha: 0.2),
                            const Color(0xFFFF0000).withValues(alpha: 0.9),
                          ],
                        ),
                        border: Border.all(
                            color: const Color(0xFFFF0000), width: 3),
                      ),
                      child: const Center(
                        child: Icon(Icons.music_note,
                            size: 80, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Info + controls
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    song.title,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: textPrimary),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    song.artist,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.album,
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Progress bar (decorative)
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.35,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF0000),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('1:32',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[500])),
                      Text(song.duration,
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[500])),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Playback buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Shuffle
                      IconButton(
                        icon: Icon(Icons.shuffle,
                            color: appState.isShuffleOn
                                ? const Color(0xFFFF0000)
                                : Colors.grey[500]),
                        iconSize: 26,
                        onPressed: () => appState.toggleShuffle(),
                      ),
                      const SizedBox(width: 12),
                      // Previous
                      IconButton(
                        icon: const Icon(Icons.skip_previous,
                            color: Color(0xFFFF0000)),
                        iconSize: 40,
                        onPressed: () => appState.prevSong(),
                      ),
                      const SizedBox(width: 12),
                      // Play / Pause
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFF0000),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          iconSize: 40,
                          onPressed: () => appState.togglePlayPause(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Next
                      IconButton(
                        icon: const Icon(Icons.skip_next,
                            color: Color(0xFFFF0000)),
                        iconSize: 40,
                        onPressed: () => appState.nextSong(),
                      ),
                      const SizedBox(width: 12),
                      // Repeat
                      IconButton(
                        icon: Icon(Icons.repeat,
                            color: appState.isRepeatOn
                                ? const Color(0xFFFF0000)
                                : Colors.grey[500]),
                        iconSize: 26,
                        onPressed: () => appState.toggleRepeat(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom action bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.15),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    song.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: const Color(0xFFFF0000),
                  ),
                  iconSize: 32,
                  onPressed: () {
                    appState.toggleFavorite(song);
                    _showToast(song.isFavorite
                        ? 'Added to favourites'
                        : 'Removed from favourites');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add_to_queue,
                      color: Color(0xFFFF0000)),
                  iconSize: 32,
                  onPressed: _showFeatureComingSoon,
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert,
                      color: Color(0xFFFF0000)),
                  iconSize: 32,
                  onPressed: () => _showMoreOptionsModal(appState),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
