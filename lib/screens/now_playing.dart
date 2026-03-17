import 'package:flutter/material.dart';
import '../models/song_model.dart';

class NowPlayingPage extends StatefulWidget {
  final Song song;
  final bool isPlaying;
  final Function(bool, {Song? song}) onPlaybackStateChanged;
  final VoidCallback onClose;

  const NowPlayingPage({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.onPlaybackStateChanged,
    required this.onClose,
  });

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  bool _isFavorite = false;
  double _volume = 0.7;
  
  // Track local play state to ensure immediate UI response
  late bool _localIsPlaying;

  @override
  void initState() {
    super.initState();
    _localIsPlaying = widget.isPlaying;
    
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    
    _rotationAnimation = Tween<double>(begin: 0, end: 360).animate(_rotationController);
    
    _isFavorite = widget.song.isFavorite;
    
    // Start rotation if playing
    if (_localIsPlaying) {
      _rotationController.repeat();
    }
  }

  @override
  void didUpdateWidget(NowPlayingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update local state when widget updates
    if (widget.isPlaying != oldWidget.isPlaying) {
      setState(() {
        _localIsPlaying = widget.isPlaying;
      });
      
      _updateAnimation(widget.isPlaying);
    }
  }

  void _updateAnimation(bool shouldPlay) {
    if (shouldPlay) {
      if (!_rotationController.isAnimating) {
        _rotationController.repeat();
      }
    } else {
      if (_rotationController.isAnimating) {
        _rotationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _showFeatureComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Feature coming soon!'),
        backgroundColor: const Color(0xFFFF5349),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showMoreOptionsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                const Text(
                  "More options",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF0000),
                  ),
                ),
                const Divider(),
                
                // Volume control
                ListTile(
                  leading: const Icon(Icons.volume_up, color: Color(0xFFFF0000)),
                  title: const Text("Volume"),
                  subtitle: Slider(
                    value: _volume,
                    onChanged: (value) {
                      setState(() {
                        _volume = value;
                      });
                    },
                    activeColor: const Color(0xFFFF0000),
                  ),
                ),
                const Divider(),
                
                // Add to playlist
                ListTile(
                  leading: const Icon(Icons.playlist_add, color: Color(0xFFFF0000)),
                  title: const Text("Add to playlist"),
                  onTap: () {
                    Navigator.pop(context);
                    _showFeatureComingSoon();
                  },
                ),
                const Divider(),
                
                // Driving mode
                ListTile(
                  leading: const Icon(Icons.drive_eta, color: Color(0xFFFF0000)),
                  title: const Text("Driving mode"),
                  onTap: () {
                    Navigator.pop(context);
                    _showFeatureComingSoon();
                  },
                ),
                const Divider(),
                
                // Cancel button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: const Text("Cancel"),
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

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      widget.song.isFavorite = _isFavorite;
      
      if (_isFavorite) {
        if (!favoriteSongs.contains(widget.song)) {
          favoriteSongs.add(widget.song);
        }
      } else {
        favoriteSongs.remove(widget.song);
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite ? 'Added to favorites' : 'Removed from favorites',
        ),
        backgroundColor: const Color(0xFFFF0000),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handlePlayPause() {
    // Immediately update local state for instant UI feedback
    setState(() {
      _localIsPlaying = !_localIsPlaying;
    });
    
    // Update animation immediately based on local state
    _updateAnimation(_localIsPlaying);
    
    // Notify parent of state change
    widget.onPlaybackStateChanged(_localIsPlaying);
  }

  void _closePage() {
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3D3D3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_downward, color: Color(0xFFFF0000)),
          onPressed: _closePage,
        ),
        title: const Text(
          'Now Playing',
          style: TextStyle(
            color: Color(0xFFFF0000),
            fontWeight: FontWeight.bold,
          ),
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
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _localIsPlaying ? _rotationAnimation.value * (3.14159 / 180) : 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFFF0000).withValues(alpha: 0.2),
                            const Color(0xFFFF0000).withValues(alpha: 0.8),
                          ],
                        ),
                        border: Border.all(
                          color: const Color(0xFFFF0000),
                          width: 3,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.music_note,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    widget.song.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.song.artist,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.song.album,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shuffle, color: Color(0xFFFF0000)),
                        iconSize: 28,
                        onPressed: _showFeatureComingSoon,
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(Icons.skip_previous, color: Color(0xFFFF0000)),
                        iconSize: 40,
                        onPressed: _showFeatureComingSoon,
                      ),
                      const SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFF0000),
                        ),
                        child: IconButton(
                          icon: Icon(
                            _localIsPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          iconSize: 40,
                          onPressed: _handlePlayPause,
                        ),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(Icons.skip_next, color: Color(0xFFFF0000)),
                        iconSize: 40,
                        onPressed: _showFeatureComingSoon,
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(Icons.equalizer, color: Color(0xFFFF0000)),
                        iconSize: 28,
                        onPressed: _showFeatureComingSoon,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
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
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: const Color(0xFFFF0000),
                  ),
                  iconSize: 32,
                  onPressed: _toggleFavorite,
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Color(0xFFFF0000)),
                  iconSize: 32,
                  onPressed: _showMoreOptionsModal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
