import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/song_model.dart';
import 'equalizer_page.dart';

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showMoreOptionsModal(AppState appState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: appState.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const Text('Options', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF0000))),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.playlist_add, color: Color(0xFFFF0000)),
              title: const Text('Add to playlist'),
              onTap: () {
                Navigator.pop(ctx);
                _showAddToPlaylistSheet(appState.currentSong!);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Color(0xFFFF0000)),
              title: const Text('Share song'),
              onTap: () {
                Navigator.pop(ctx);
                _showToast('Link copied to clipboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer, color: Color(0xFFFF0000)),
              title: const Text('Sleep timer'),
              onTap: () {
                Navigator.pop(ctx);
                _showToast('Timer set for 30 minutes');
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  void _showAddToPlaylistSheet(Song song) {
    final appState = context.read<AppState>();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Add to Playlist', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFF0000))),
          ),
          if (appState.playlists.isEmpty)
            const Padding(padding: EdgeInsets.all(20), child: Text('No playlists found.'))
          else
            ...appState.playlists.asMap().entries.map((e) => ListTile(
              leading: const Icon(Icons.playlist_play, color: Color(0xFFFF0000)),
              title: Text(e.value.name),
              onTap: () {
                appState.addSongToPlaylist(e.key, song);
                Navigator.pop(ctx);
                _showToast('Added to ${e.value.name}');
              },
            )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final song = appState.currentSong;

    if (song == null) {
      return const Scaffold(body: Center(child: Text('No song selected')));
    }

    final isPlaying = appState.isPlaying;
    final isDark = appState.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFD3D3D3);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textPrimary = isDark ? Colors.white : Colors.black87;

    final mood = appState.currentMood;
    final moodColor1 = mood?.gradientColors[0] ?? const Color(0xFFFF0000);
    final moodColor2 = mood?.gradientColors[1] ?? const Color(0xFFFF5349);

    _updateRotation(isPlaying);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_downward, color: moodColor1),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Now Playing', style: TextStyle(color: moodColor1, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Disc Art
          Expanded(
            flex: 3,
            child: Center(
              child: AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationController.value * 2 * 3.14159,
                    child: Container(
                      width: 250, height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [moodColor1, moodColor2, moodColor1],
                        ),
                        border: Border.all(color: Colors.white12, width: 8),
                        boxShadow: [
                          BoxShadow(color: moodColor1.withValues(alpha: 0.3), blurRadius: 40, spreadRadius: 10),
                          BoxShadow(color: moodColor2.withValues(alpha: 0.2), blurRadius: 60, spreadRadius: 5),
                        ],
                      ),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset('assets/pillow.png', width: 120, height: 120, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Text(song.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Text(song.artist, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                  const SizedBox(height: 24),
                  
                  // Progress
                  LinearProgressIndicator(
                    value: 0.45,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(moodColor1),
                    minHeight: 4,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('1:45', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      Text(song.duration, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.shuffle, color: appState.isShuffleOn ? moodColor1 : Colors.grey),
                        onPressed: () => appState.toggleShuffle(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.skip_previous, size: 48, color: moodColor1),
                        onPressed: () => appState.prevSong(),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => appState.togglePlayPause(),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: moodColor1, shape: BoxShape.circle),
                          child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 40),
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: Icon(Icons.skip_next, size: 48, color: moodColor1),
                        onPressed: () => appState.nextSong(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.repeat, color: appState.isRepeatOn ? moodColor1 : Colors.grey),
                        onPressed: () => appState.toggleRepeat(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            decoration: BoxDecoration(color: cardColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(song.isFavorite ? Icons.favorite : Icons.favorite_border, color: moodColor1, size: 30),
                  onPressed: () => appState.toggleFavorite(song),
                ),
                IconButton(
                  icon: Icon(Icons.playlist_add, color: moodColor1, size: 32),
                  onPressed: () => _showAddToPlaylistSheet(song),
                ),
                IconButton(
                  icon: Icon(Icons.graphic_eq, color: moodColor1, size: 30),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const EqualizerPage())),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: moodColor1, size: 30),
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
