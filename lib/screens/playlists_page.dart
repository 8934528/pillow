import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/song_model.dart';
import 'now_playing.dart';
import '../main.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({super.key});

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  final TextEditingController _nameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _nameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showToast(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
            isError ? const Color(0xFFFF5349) : const Color(0xFFFF0000),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        duration: const Duration(seconds: 2),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _openCreatePlaylist() {
    _nameController.clear();
    final appState = context.read<AppState>();
    final isDark = appState.isDarkMode;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModal) {
            return Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25)),
              ),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2)),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFFF0000).withValues(alpha: 0.2),
                            const Color(0xFFFF0000).withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(Icons.playlist_add,
                          color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 16),
                    const Text('New Playlist',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF0000))),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      maxLength: 30,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: 'Playlist name',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        counterText: '',
                        prefixIcon: const Icon(Icons.playlist_play,
                            color: Color(0xFFFF0000)),
                      ),
                      onChanged: (_) => setModal(() {}),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${_nameController.text.length}/30',
                          style: TextStyle(
                            color: _nameController.text.length == 30
                                ? const Color(0xFFFF5349)
                                : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              side: BorderSide(color: Colors.grey[300]!),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final name = _nameController.text.trim();
                              if (name.isEmpty) {
                                Navigator.pop(ctx);
                                _showToast('Please enter a playlist name',
                                    isError: true);
                                return;
                              }
                              appState.createPlaylist(name);
                              Navigator.pop(ctx);
                              _showToast("Playlist '$name' created");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF0000),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Create'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showPlaylistOptions(Playlist playlist, int index) {
    final appState = context.read<AppState>();
    final isDark = appState.isDarkMode;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFFF0000).withValues(alpha: 0.2),
                            const Color(0xFFFF0000).withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(Icons.playlist_play,
                          color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 12),
                    Text(playlist.name,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF0000))),
                  ],
                ),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.play_arrow,
                      color: Color(0xFFFF0000), size: 22),
                ),
                title: const Text('Play all',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(ctx);
                  if (playlist.songs.isNotEmpty) {
                    appState.playSong(playlist.songs[0]);
                    Navigator.push(
                      context,
                      SlideUpPageRoute(
                          builder: (_) => const NowPlayingPage()),
                    );
                  } else {
                    _showToast('This playlist is empty', isError: true);
                  }
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.library_add,
                      color: Color(0xFFFF0000), size: 22),
                ),
                title: const Text('Add songs',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(ctx);
                  _showAddSongsSheet(index);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFF5349).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.delete,
                      color: Color(0xFFFF5349), size: 22),
                ),
                title: const Text('Delete',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFF5349))),
                onTap: () {
                  appState.deletePlaylist(index);
                  Navigator.pop(ctx);
                  _showToast('Playlist deleted');
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showAddSongsSheet(int playlistIndex) {
    final appState = context.read<AppState>();
    final isDark = appState.isDarkMode;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
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
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Add Songs',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF0000))),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollCtrl,
                      itemCount: appState.songs.length,
                      itemBuilder: (ctx, i) {
                        final song = appState.songs[i];
                        final inPlaylist = appState
                            .playlists[playlistIndex].songs
                            .contains(song);
                        return ListTile(
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFFFF0000)
                                      .withValues(alpha: 0.2),
                                  const Color(0xFFFF0000)
                                      .withValues(alpha: 0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.music_note,
                                color: Colors.white, size: 20),
                          ),
                          title: Text(song.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                          subtitle: Text(song.artist,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600])),
                          trailing: inPlaylist
                              ? const Icon(Icons.check_circle,
                                  color: Color(0xFFFF0000))
                              : const Icon(Icons.add_circle_outline,
                                  color: Colors.grey),
                          onTap: () {
                            if (inPlaylist) {
                              appState.removeSongFromPlaylist(
                                  playlistIndex, song);
                            } else {
                              appState.addSongToPlaylist(playlistIndex, song);
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF0000),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Done'),
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

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final playlists = appState.playlists;
    final isDark = appState.isDarkMode;
    final bgColor =
        isDark ? const Color(0xFF121212) : const Color(0xFFD3D3D3);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textPrimary = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'Playlists',
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
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Color(0xFFFF0000)),
              onPressed: _openCreatePlaylist,
            ),
          ),
        ],
      ),
      body: playlists.isEmpty
          ? _buildEmptyState()
          : CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildPlaylistCard(
                          playlists[index], index, cardColor, textPrimary),
                      childCount: playlists.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPlaylistCard(
      Playlist playlist, int index, Color cardColor, Color textPrimary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            final appState = context.read<AppState>();
            if (playlist.songs.isNotEmpty) {
              appState.playSong(playlist.songs[0]);
              Navigator.push(
                context,
                SlideUpPageRoute(builder: (_) => const NowPlayingPage()),
              );
            } else {
              _showToast('This playlist is empty', isError: true);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFF0000).withValues(alpha: 0.2),
                        const Color(0xFFFF0000).withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.playlist_play,
                      color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(playlist.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: textPrimary)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${playlist.songCount} song${playlist.songCount == 1 ? '' : 's'}',
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.more_vert,
                        color: Color(0xFFFF0000), size: 22),
                    onPressed: () => _showPlaylistOptions(playlist, index),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
              color: const Color(0xFFFFA500).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.playlist_add,
              size: 60,
              color: const Color(0xFFFFA500).withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          const Text('No playlists yet',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54)),
          const SizedBox(height: 12),
          Text('Tap + to create your first playlist',
              style: TextStyle(fontSize: 15, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
