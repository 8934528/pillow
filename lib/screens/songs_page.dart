import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/song_model.dart';
import 'settings.dart';
import 'mode.dart';
import 'now_playing.dart';
import '../main.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({super.key});

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage>
    with SingleTickerProviderStateMixin {
  String _sortOption = 'time';
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showFeatureComingSoon() => _showToast('Feature coming soon!', isError: true);

  void _playAndNavigate(Song song) {
    context.read<AppState>().playSong(song);
    Navigator.push(
      context,
      SlideUpPageRoute(builder: (_) => const NowPlayingPage()),
    );
  }

  List<Song> _sortedSongs(List<Song> songs) {
    final list = [...songs];
    switch (_sortOption) {
      case 'song':
        list.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'artist':
        list.sort((a, b) => a.artist.compareTo(b.artist));
        break;
      default:
        break;
    }
    return list;
  }

  void _showSongOptionsModal(Song song) {
    final appState = context.read<AppState>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final isDark = appState.isDarkMode;
        final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSheetHandle(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildSheetArt(Icons.music_note),
                    const SizedBox(height: 12),
                    Text(song.title,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF0000))),
                    Text(song.artist,
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey[600])),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, indent: 20, endIndent: 20),
              StatefulBuilder(builder: (ctx, setLocal) {
                return _buildModalOption(
                  icon: song.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  title: song.isFavorite
                      ? 'Remove from favourites'
                      : 'Add to favourites',
                  onTap: () {
                    Navigator.pop(ctx);
                    appState.toggleFavorite(song);
                    _showToast(song.isFavorite
                        ? 'Added to favourites'
                        : 'Removed from favourites');
                  },
                );
              }),
              _buildModalOption(
                icon: Icons.playlist_add,
                title: 'Add to playlist',
                onTap: () {
                  Navigator.pop(ctx);
                  _showAddToPlaylistSheet(song);
                },
              ),
              _buildModalOption(
                icon: Icons.delete,
                title: 'Delete',
                isDestructive: true,
                onTap: () {
                  Navigator.pop(ctx);
                  _showFeatureComingSoon();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showAddToPlaylistSheet(Song song) {
    final appState = context.read<AppState>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = appState.isDarkMode;
        final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSheetHandle(),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Add to Playlist',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF0000))),
              ),
              if (appState.playlists.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No playlists yet. Create one first.'),
                )
              else
                ...List.generate(appState.playlists.length, (i) {
                  final pl = appState.playlists[i];
                  return ListTile(
                    leading: const Icon(Icons.playlist_play,
                        color: Color(0xFFFF0000)),
                    title: Text(pl.name),
                    subtitle: Text('${pl.songCount} songs'),
                    onTap: () {
                      Navigator.pop(ctx);
                      appState.addSongToPlaylist(i, song);
                      _showToast('Added to ${pl.name}');
                    },
                  );
                }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showSortModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModal) {
            final appState = context.read<AppState>();
            final isDark = appState.isDarkMode;
            final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
            return Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSheetHandle(),
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Sort by',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF0000))),
                  ),
                  const Divider(height: 1),
                  _buildSortOption('time', 'Time added', Icons.access_time,
                      _sortOption, (v) => setModal(() => _sortOption = v)),
                  _buildSortOption('song', 'Song name', Icons.music_note,
                      _sortOption, (v) => setModal(() => _sortOption = v)),
                  _buildSortOption('artist', 'Artist', Icons.person,
                      _sortOption, (v) => setModal(() => _sortOption = v)),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
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
                              Navigator.pop(ctx);
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF0000),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Confirm'),
                          ),
                        ),
                      ],
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

  Widget _buildSortOption(
    String value,
    String title,
    IconData icon,
    String groupValue,
    Function(String) onChanged,
  ) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFF0000).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFFFF0000), size: 20),
      ),
      title: Text(title,
          style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: Radio<String>(
        value: value,
        groupValue: groupValue,
        activeColor: const Color(0xFFFF0000),
        onChanged: (val) => onChanged(val!),
      ),
      onTap: () => onChanged(value),
    );
  }

  Widget _buildSheetHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildSheetArt(IconData icon) {
    return Container(
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
      child: Icon(icon, color: Colors.white, size: 30),
    );
  }

  Widget _buildModalOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive
              ? const Color(0xFFFF5349).withValues(alpha: 0.1)
              : const Color(0xFFFF0000).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color:
              isDestructive ? const Color(0xFFFF5349) : const Color(0xFFFF0000),
          size: 22,
        ),
      ),
      title: Text(title,
          style: TextStyle(
              color: isDestructive
                  ? const Color(0xFFFF5349)
                  : null,
              fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = appState.isDarkMode;
    final songs = _sortedSongs(appState.songs);
    final bgColor =
        isDark ? const Color(0xFF121212) : const Color(0xFFD3D3D3);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textPrimary = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'All Songs',
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
          _appBarAction(Icons.search, _showFeatureComingSoon),
          _appBarMenuButton(context),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            sliver: SliverToBoxAdapter(
              child: _buildPlayAllCard(songs, cardColor, textPrimary),
            ),
          ),
          if (songs.isEmpty)
            SliverFillRemaining(child: _buildEmptyState())
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _buildSongTile(songs[index], cardColor, textPrimary),
                  childCount: songs.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _appBarAction(IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFF0000).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(icon: Icon(icon), onPressed: onTap),
    );
  }

  Widget _appBarMenuButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFF0000).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, size: 22),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onSelected: (value) {
          if (value == 'settings') {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SettingsPage()));
          } else if (value == 'mode') {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ModePage()));
          } else {
            _showFeatureComingSoon();
          }
        },
        itemBuilder: (_) => [
          _popupItem('settings', Icons.settings, 'Settings',
              const Color(0xFFFF0000)),
          _popupItem('mode', Icons.mode, 'Mode', const Color(0xFFFF0000)),
          _popupItem('delete', Icons.delete, 'Delete',
              const Color(0xFFFF5349)),
        ],
      ),
    );
  }

  PopupMenuItem<String> _popupItem(
      String value, IconData icon, String title, Color color) {
    return PopupMenuItem(
      value: value,
      child: Row(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(title),
      ]),
    );
  }

  Widget _buildPlayAllCard(
      List<Song> songs, Color cardColor, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.play_arrow,
                    color: Color(0xFFFF0000)),
                onPressed: () {
                  if (songs.isNotEmpty) _playAndNavigate(songs[0]);
                },
              ),
            ),
            const SizedBox(width: 8),
            Text('Play all',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: textColor)),
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${songs.length}',
                style: const TextStyle(
                    color: Color(0xFFFF0000),
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.sort,
                    color: Color(0xFFFF0000), size: 22),
                onPressed: _showSortModal,
              ),
            ),
          ],
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
              color: const Color(0xFFFF0000).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.music_note,
              size: 60,
              color: const Color(0xFFFF0000).withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          const Text('No songs detected',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54)),
          const SizedBox(height: 12),
          Text('Add some music to your library',
              style: TextStyle(fontSize: 15, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildSongTile(Song song, Color cardColor, Color textPrimary) {
    final isCurrent =
        context.watch<AppState>().currentSong?.title == song.title;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isCurrent
            ? const Color(0xFFFF0000).withValues(alpha: 0.08)
            : cardColor,
        borderRadius: BorderRadius.circular(12),
        border: isCurrent
            ? Border.all(color: const Color(0xFFFF0000).withValues(alpha: 0.4))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                const Color(0xFFFF0000).withValues(alpha: 0.2),
                const Color(0xFFFF0000).withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.music_note, color: Colors.white, size: 24),
        ),
        title: Text(song.title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: textPrimary)),
        subtitle: Text(song.artist,
            style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(song.duration,
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ),
            const SizedBox(width: 4),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.more_vert,
                    color: Color(0xFFFF0000), size: 20),
                onPressed: () => _showSongOptionsModal(song),
              ),
            ),
          ],
        ),
        onTap: () => _playAndNavigate(song),
      ),
    );
  }
}
