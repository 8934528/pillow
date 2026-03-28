import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/song_model.dart';
import 'now_playing.dart';
import '../main.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  String _sortOption = 'song';
  bool _isSearchOpen = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Song> _filteredFavorites(List<Song> favorites) {
    var list = [...favorites];
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      list = list.where((s) => s.title.toLowerCase().contains(query) || s.artist.toLowerCase().contains(query)).toList();
    }
    if (_sortOption == 'song') {
      list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    } else if (_sortOption == 'artist') {
      list.sort((a, b) => a.artist.toLowerCase().compareTo(b.artist.toLowerCase()));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final favorites = _filteredFavorites(appState.favoriteSongs);
    final isDark = appState.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFD3D3D3);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: _isSearchOpen
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Search favorites...', border: InputBorder.none),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                onChanged: (_) => setState(() {}),
              )
            : const Text('Favourites', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF0000))),
        backgroundColor: cardColor,
        actions: [
          IconButton(
            icon: Icon(_isSearchOpen ? Icons.close : Icons.search, color: const Color(0xFFFF0000)),
            onPressed: () => setState(() {
              if (_isSearchOpen) _searchController.clear();
              _isSearchOpen = !_isSearchOpen;
            }),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: _buildPlayAllHeader(favorites, cardColor, appState),
            ),
          ),
          if (favorites.isEmpty)
            SliverFillRemaining(child: _buildEmptyState())
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildSongTile(favorites[index], cardColor, isDark, appState),
                  childCount: favorites.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlayAllHeader(List<Song> songs, Color cardColor, AppState appState) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              if (songs.isNotEmpty) {
                appState.playSong(songs[0]);
                Navigator.push(context, SlideUpPageRoute(builder: (_) => const NowPlayingPage()));
              }
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Play All'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF0000), foregroundColor: Colors.white),
          ),
          const SizedBox(width: 12),
          Text('${songs.length} Favorites'),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.sort, color: Color(0xFFFF0000)),
            onPressed: _showSortModal,
          ),
        ],
      ),
    );
  }

  Widget _buildSongTile(Song song, Color cardColor, bool isDark, AppState appState) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 48, height: 48,
          decoration: BoxDecoration(color: const Color(0xFFFF0000).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.favorite, color: Color(0xFFFF0000)),
        ),
        title: Text(song.title, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
        subtitle: Text(song.artist),
        onTap: () {
          appState.playSong(song);
          Navigator.push(context, SlideUpPageRoute(builder: (_) => const NowPlayingPage()));
        },
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Color(0xFFFF0000)),
          onPressed: () => appState.toggleFavorite(song),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No favorites yet'),
        ],
      ),
    );
  }

  void _showSortModal() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: const Text('Sort by Title'), onTap: () { setState(() => _sortOption = 'song'); Navigator.pop(ctx); }),
          ListTile(title: const Text('Sort by Artist'), onTap: () { setState(() => _sortOption = 'artist'); Navigator.pop(ctx); }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
