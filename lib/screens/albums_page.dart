import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/song_model.dart';
import 'now_playing.dart';
import '../main.dart';

class AlbumsPage extends StatelessWidget {
  const AlbumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final albums = appState.albums;
    final isDark = appState.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFD3D3D3);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textPrimary = isDark ? Colors.white : Colors.black87;

    final List<Color> albumColors = [
      const Color(0xFFFF0000),
      const Color(0xFFFFA500),
      const Color(0xFFFF5349),
      const Color(0xFFFFAE42),
      const Color(0xFFE84393),
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'Albums',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF0000),
              fontSize: 22),
        ),
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFFFF0000)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF0000).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.search, size: 22),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Search coming soon!'),
                    backgroundColor: const Color(0xFFFF5349),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: albums.isEmpty
          ? _buildEmptyState()
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final album = albums[index];
                        final color =
                            albumColors[index % albumColors.length];
                        return _buildAlbumCard(context, album,
                            appState.songsForAlbum(album), color,
                            cardColor, textPrimary, appState);
                      },
                      childCount: albums.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildAlbumCard(
    BuildContext context,
    String album,
    List<Song> songs,
    Color accentColor,
    Color cardColor,
    Color textPrimary,
    AppState appState,
  ) {
    return GestureDetector(
      onTap: () =>
          _showAlbumDetail(context, album, songs, accentColor, appState),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Album art area
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor.withValues(alpha: 0.3),
                    accentColor.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: Icon(Icons.album, color: Colors.white, size: 48),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(album,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: textPrimary),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2),
                  const SizedBox(height: 4),
                  Text(
                    '${songs.length} track${songs.length == 1 ? '' : 's'}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlbumDetail(BuildContext context, String album, List<Song> songs,
      Color accentColor, AppState appState) {
    final isDark = appState.isDarkMode;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (ctx, scrollCtrl) {
            return Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2)),
                  ),
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accentColor.withValues(alpha: 0.3),
                          accentColor.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.album,
                              color: Colors.white, size: 36),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(album,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text('${songs.length} tracks',
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollCtrl,
                      itemCount: songs.length,
                      itemBuilder: (ctx, i) {
                        final song = songs[i];
                        return ListTile(
                          leading: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text('${i + 1}',
                                  style: TextStyle(
                                      color: accentColor,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          title: Text(song.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(song.artist,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600])),
                          trailing: Text(song.duration,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12)),
                          onTap: () {
                            Navigator.pop(ctx);
                            appState.playSong(song);
                            Navigator.push(
                              context,
                              SlideUpPageRoute(
                                  builder: (_) => const NowPlayingPage()),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0xFFFFAE42).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.album,
              size: 70,
              color: const Color(0xFFFFAE42).withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          const Text('No albums detected',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Albums will appear here when you add music to your library',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, color: Colors.grey[600], height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
