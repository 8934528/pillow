import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/song_model.dart';

class DriveModePage extends StatefulWidget {
  const DriveModePage({super.key});

  @override
  State<DriveModePage> createState() => _DriveModePageState();
}

class _DriveModePageState extends State<DriveModePage> with SingleTickerProviderStateMixin {
  bool _isPlaying = true;
  int _currentSongIndex = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  // Mock songs for driving mode
  final List<Song> _songs = [...mockSongs];

  @override
  void initState() {
    super.initState();

    // Enable full screen immersive mode
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );

    // Lock orientation to portrait (safer for drivers)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    
    // Pulse animation for play button
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    
    // Restore UI when leaving
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    SystemChrome.setPreferredOrientations(
      DeviceOrientation.values,
    );

    super.dispose();
  }

  void _playPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _nextSong() {
    setState(() {
      _currentSongIndex = (_currentSongIndex + 1) % _songs.length;
      _isPlaying = true;
    });
    
    // Haptic feedback for button press
    HapticFeedback.lightImpact();
  }

  void _previousSong() {
    setState(() {
      _currentSongIndex = (_currentSongIndex - 1 + _songs.length) % _songs.length;
      _isPlaying = true;
    });
    
    // Haptic feedback for button press
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = _songs[_currentSongIndex];
    
    return WillPopScope(
      // Block back button - require long press to exit
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFFF0000).withValues(alpha: 0.3),
                Colors.black,
                Colors.black,
              ],
              stops: const [0.0, 0.3, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Top section with drive mode indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color(0xFFFF0000).withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.drive_eta,
                              color: const Color(0xFFFF0000),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "DRIVE MODE",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                          border: Border.all(
                            color: const Color(0xFFFF0000).withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.speed,
                          color: Color(0xFFFF0000),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(flex: 1),
                
                // Album art visualization
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        const Color(0xFFFF0000).withValues(alpha: 0.8),
                        const Color(0xFFFFA500).withValues(alpha: 0.8),
                        const Color(0xFFFF0000).withValues(alpha: 0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF0000).withValues(alpha: 0.3),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.music_note,
                          size: 80,
                          color: const Color(0xFFFF0000).withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Song info
                Column(
                  children: [
                    Text(
                      currentSong.title.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF0000).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color(0xFFFF0000).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        currentSong.artist.toUpperCase(),
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentSong.album,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                
                const Spacer(flex: 2),
                
                // Giant control buttons for easy tapping while driving
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // PREVIOUS
                      Expanded(
                        child: GestureDetector(
                          onTap: _previousSong,
                          child: Container(
                            height: 140,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.grey[900]!,
                                  Colors.grey[850]!,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.skip_previous,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      
                      // PLAY/PAUSE (larger)
                      Expanded(
                        child: GestureDetector(
                          onTap: _playPause,
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _isPlaying ? _pulseAnimation.value : 1.0,
                                child: Container(
                                  height: 160,
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        const Color(0xFFFF0000),
                                        const Color(0xFFFF5349),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(40),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFF0000).withValues(alpha: 0.5),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      
                      // NEXT
                      Expanded(
                        child: GestureDetector(
                          onTap: _nextSong,
                          child: Container(
                            height: 140,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.grey[900]!,
                                  Colors.grey[850]!,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.skip_next,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Exit button with long press
                GestureDetector(
                  onLongPress: () {
                    // Haptic feedback for exit
                    HapticFeedback.heavyImpact();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          color: Colors.grey[500],
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "HOLD TO EXIT",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
