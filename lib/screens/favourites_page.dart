import 'package:flutter/material.dart';
import '../models/song_model.dart';
import 'settings.dart';
import 'mode.dart';

class FavouritesPage extends StatefulWidget {
  final Function(Song) onPlaySong;
  
  const FavouritesPage({super.key, required this.onPlaySong});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> with SingleTickerProviderStateMixin {
  String _sortOption = "time";
  List<Song> _favorites = [...favoriteSongs];
  final ScrollController _scrollController = ScrollController();

  void _showSortModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
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
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Sort by",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF0000),
                      ),
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),
                  
                  _buildSortOption(
                    value: "time",
                    title: "Time added",
                    icon: Icons.access_time,
                    groupValue: _sortOption,
                    onChanged: (val) => setState(() => _sortOption = val),
                  ),
                  
                  _buildSortOption(
                    value: "song",
                    title: "Song name",
                    icon: Icons.music_note,
                    groupValue: _sortOption,
                    onChanged: (val) => setState(() => _sortOption = val),
                  ),
                  
                  _buildSortOption(
                    value: "artist",
                    title: "Artist",
                    icon: Icons.person,
                    groupValue: _sortOption,
                    onChanged: (val) => setState(() => _sortOption = val),
                  ),
                  
                  _buildSortOption(
                    value: "manual",
                    title: "Sort manually",
                    icon: Icons.drag_handle,
                    groupValue: _sortOption,
                    onChanged: (val) => setState(() => _sortOption = val),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              side: BorderSide(color: Colors.grey[300]!),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF0000),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Confirm"),
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

  Widget _buildSortOption({
    required String value,
    required String title,
    required IconData icon,
    required String groupValue,
    required Function(String) onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFF0000).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFFFF0000), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Radio<String>(
        value: value,
        groupValue: groupValue,
        activeColor: const Color(0xFFFF0000),
        onChanged: (val) => onChanged(val!),
      ),
      onTap: () => onChanged(value),
    );
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
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  void _navigateToMode() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ModePage()),
    );
  }

  void _showSongOptionsModal(Song song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
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
                  borderRadius: BorderRadius.circular(2),
                ),
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
                      child: const Icon(Icons.favorite, color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      song.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF0000),
                      ),
                    ),
                    Text(
                      song.artist,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, indent: 20, endIndent: 20),
              
              _buildModalOption(
                icon: Icons.playlist_add,
                title: "Add to queue",
                onTap: () {
                  Navigator.pop(context);
                  _showFeatureComingSoon();
                },
              ),
              
              _buildModalOption(
                icon: song.isFavorite ? Icons.favorite : Icons.favorite_border,
                title: song.isFavorite ? "Remove from favourites" : "Add to favourites",
                onTap: () {
                  Navigator.pop(context);
                  _toggleFavorite(song);
                },
              ),
              
              _buildModalOption(
                icon: Icons.delete,
                title: "Delete",
                isDestructive: true,
                onTap: () {
                  Navigator.pop(context);
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
          color: isDestructive ? const Color(0xFFFF5349) : const Color(0xFFFF0000),
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? const Color(0xFFFF5349) : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  void _toggleFavorite(Song song) {
    setState(() {
      song.isFavorite = !song.isFavorite;
      if (song.isFavorite) {
        if (!favoriteSongs.contains(song)) {
          favoriteSongs.add(song);
        }
      } else {
        favoriteSongs.remove(song);
      }
      _favorites = [...favoriteSongs];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3D3D3),
      appBar: AppBar(
        title: const Text(
          "Favourites",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF0000),
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFFFF0000)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF0000).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.search, size: 22),
              onPressed: _showFeatureComingSoon,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF0000).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              onSelected: (value) {
                if (value == "settings") {
                  _navigateToSettings();
                } else if (value == "mode") {
                  _navigateToMode();
                } else {
                  _showFeatureComingSoon();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: "settings", 
                  child: Row(
                    children: [
                      Icon(Icons.settings, color: Color(0xFFFF0000), size: 20),
                      SizedBox(width: 12),
                      Text("Settings"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: "delete", 
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Color(0xFFFF5349), size: 20),
                      SizedBox(width: 12),
                      Text("Delete"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: "mode", 
                  child: Row(
                    children: [
                      Icon(Icons.mode, color: Color(0xFFFF0000), size: 20),
                      SizedBox(width: 12),
                      Text("Mode"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Play all card as a sliver
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.grey[50]!,
                    ],
                  ),
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
                          icon: const Icon(Icons.play_arrow, color: Color(0xFFFF0000)),
                          onPressed: () {
                            if (_favorites.isNotEmpty) {
                              widget.onPlaySong(_favorites[0]);
                            } else {
                              _showFeatureComingSoon();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Play all",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${_favorites.length}",
                          style: const TextStyle(
                            color: Color(0xFFFF0000),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.sort, color: Color(0xFFFF0000), size: 22),
                          onPressed: () => _showSortModal(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Favorites list
          if (_favorites.isEmpty)
            SliverFillRemaining(
              child: Center(
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
                        Icons.favorite,
                        size: 60,
                        color: const Color(0xFFFF0000).withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "No favourites detected",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Your favorite songs will appear here",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final song = _favorites[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.05),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          song.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          song.artist,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                song.duration,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.playlist_add,
                                  color: Color(0xFFFF0000),
                                  size: 20,
                                ),
                                onPressed: () => _showFeatureComingSoon(),
                                tooltip: 'Add to queue',
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Color(0xFFFF0000),
                                  size: 20,
                                ),
                                onPressed: () => _showSongOptionsModal(song),
                              ),
                            ),
                          ],
                        ),
                        onTap: () => widget.onPlaySong(song),
                      ),
                    );
                  },
                  childCount: _favorites.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
