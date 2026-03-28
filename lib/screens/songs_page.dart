import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/song_model.dart';
import 'settings.dart';
import 'mode.dart';
import 'now_playing.dart';
import 'online_search_page.dart';
import '../main.dart';
import '../utils/notification_utils.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({super.key});

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage>
    with SingleTickerProviderStateMixin {
  String _sortOption = 'song';
  bool _isSearchOpen = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showToast(String msg, {bool isError = false}) {
    if (isError) {
      NotificationUtils.showErrorToast(context, msg);
    } else {
      NotificationUtils.showSuccessToast(context, msg);
    }
  }

  void _playAndNavigate(Song song) {
    context.read<AppState>().playSong(song);
    Navigator.push(
      context,
      SlideUpPageRoute(builder: (context) => const NowPlayingPage()),
    );
  }

  List<Song> _filteredAndSortedSongs(List<Song> songs) {
    var list = [...songs];
    
    // Search filter
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      list = list.where((s) => 
        s.title.toLowerCase().contains(query) || 
        s.artist.toLowerCase().contains(query)
      ).toList();
    }

    // Sorting
    switch (_sortOption) {
      case 'song':
        list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case 'artist':
        list.sort((a, b) => a.artist.toLowerCase().compareTo(b.artist.toLowerCase()));
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
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
              ListTile(
                leading: _buildIconBox(song.isFavorite ? Icons.favorite : Icons.favorite_border),
                title: Text(song.isFavorite ? 'Remove from favorites' : 'Add to favorites'),
                onTap: () {
                  appState.toggleFavorite(song);
                  Navigator.pop(ctx);
                  _showToast(song.isFavorite ? 'Added to favorites' : 'Removed from favorites');
                },
              ),
              ListTile(
                leading: _buildIconBox(Icons.playlist_add),
                title: const Text('Add to playlist'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showAddToPlaylistSheet(song);
                },
              ),
              ListTile(
                leading: _buildIconBox(Icons.info_outline),
                title: const Text('Song info'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showSongInfo(song);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showSongInfo(Song song) {
    NotificationUtils.showInfoAlert(
      context,
      'Artist: ${song.artist}\nAlbum: ${song.album}\nDuration: ${song.duration}\nFormat: MP3',
      title: song.title,
    );
  }

  void _showAddToPlaylistSheet(Song song) {
    final appState = context.read<AppState>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final cardColor = appState.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
        return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
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
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text('No playlists yet.'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          // Navigate to playlists or show create dialog
                        },
                        child: const Text('Create Playlist'),
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: appState.playlists.length,
                    itemBuilder: (ctx, i) {
                      final pl = appState.playlists[i];
                      return ListTile(
                        leading: const Icon(Icons.playlist_play, color: Color(0xFFFF0000)),
                        title: Text(pl.name),
                        onTap: () {
                          appState.addSongToPlaylist(i, song);
                          Navigator.pop(ctx);
                          _showToast('Added to ${pl.name}');
                        },
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = appState.isDarkMode;
    final songs = _filteredAndSortedSongs(appState.songs);
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFD3D3D3);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: _isSearchOpen
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search songs, artists...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                onChanged: (_) => setState(() {}),
              )
            : Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset('assets/pillow.png', height: 32, width: 32, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Pillow Music',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF0000)),
                  ),
                ],
              ),
        backgroundColor: cardColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isSearchOpen ? Icons.close : Icons.search, color: const Color(0xFFFF0000)),
            onPressed: () {
              setState(() {
                if (_isSearchOpen) _searchController.clear();
                _isSearchOpen = !_isSearchOpen;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.public, color: Color(0xFFFF0000)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const OnlineSearchPage()));
            },
          ),
          _appBarMenuButton(context),
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: _buildHeader(songs, cardColor, isDark),
                ),
              ),
              if (songs.isEmpty && !appState.isScanning)
                SliverFillRemaining(child: _buildEmptyState())
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildSongTile(songs[index], cardColor, isDark),
                      childCount: songs.length,
                    ),
                  ),
                ),
            ],
          ),
          if (appState.isScanning)
            const Positioned(
              top: 0, left: 0, right: 0,
              child: LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF0000)),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          appState.scanMusic();
          NotificationUtils.showToast(context, 'Scanning for local music...', icon: Icons.search);
        },
        backgroundColor: const Color(0xFFFF0000),
        child: const Icon(Icons.library_music, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(List<Song> songs, Color cardColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              if (songs.isNotEmpty) _playAndNavigate(songs[0]);
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Play All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF0000),
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Text('${songs.length} Songs', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.sort, color: Color(0xFFFF0000)),
            onPressed: _showSortModal,
          ),
        ],
      ),
    );
  }

  Widget _buildSongTile(Song song, Color cardColor, bool isDark) {
    final currentSong = context.watch<AppState>().currentSong;
    final isCurrent = currentSong?.title == song.title;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isCurrent ? const Color(0xFFFF0000).withValues(alpha: 0.1) : cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFFF0000).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.music_note, color: Color(0xFFFF0000)),
        ),
        title: Text(
          song.title,
          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(song.artist, style: const TextStyle(fontSize: 12)),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showSongOptionsModal(song),
        ),
        onTap: () => _playAndNavigate(song),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.music_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No songs found'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => context.read<AppState>().scanMusic(),
            child: const Text('Scan Local Storage'),
          ),
        ],
      ),
    );
  }

  Widget _appBarMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Color(0xFFFF0000)),
      onSelected: (val) {
        if (val == 'settings') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
        } else if (val == 'mode') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ModePage()));
        }
      },
      itemBuilder: (ctx) => [
        const PopupMenuItem(value: 'settings', child: Text('Settings')),
        const PopupMenuItem(value: 'mode', child: Text('Mode')),
      ],
    );
  }

  Widget _buildIconBox(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFFF0000).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: const Color(0xFFFF0000), size: 20),
    );
  }

  Widget _buildSheetHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40, height: 4,
      decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(2)),
    );
  }

  Widget _buildSheetArt(IconData icon) {
    return Container(
      width: 60, height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFFF0000).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, color: const Color(0xFFFF0000), size: 30),
    );
  }

  void _showSortModal() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.title),
            title: const Text('Sort by Title'),
            onTap: () { setState(() => _sortOption = 'song'); Navigator.pop(ctx); },
            trailing: _sortOption == 'song' ? const Icon(Icons.check, color: Color(0xFFFF0000)) : null,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Sort by Artist'),
            onTap: () { setState(() => _sortOption = 'artist'); Navigator.pop(ctx); },
            trailing: _sortOption == 'artist' ? const Icon(Icons.check, color: Color(0xFFFF0000)) : null,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
