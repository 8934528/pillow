import 'package:flutter/material.dart';

class PlaylistsPage extends StatefulWidget {
  final Function(String) onPlayPlaylist;
  
  const PlaylistsPage({super.key, required this.onPlayPlaylist});

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> with SingleTickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();
  final List<Map<String, dynamic>> _playlists = [];
  final ScrollController _scrollController = ScrollController();

  void _showToast(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFFFF5349) : const Color(0xFFFF0000),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void openCreatePlaylist() {
    controller.clear();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
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
                      const SizedBox(height: 8),
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
                        child: const Icon(Icons.playlist_add, color: Colors.white, size: 30),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "New playlist",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF0000),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: controller,
                        maxLength: 30,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: "Playlist name",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          counterText: "",
                          prefixIcon: const Icon(Icons.playlist_play, color: Color(0xFFFF0000)),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: controller.text.length == 30 
                              ? const Color(0xFFFF5349).withValues(alpha: 0.1)
                              : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${controller.text.length}/30",
                            style: TextStyle(
                              color: controller.text.length == 30 
                                ? const Color(0xFFFF5349) 
                                : Colors.grey[600],
                              fontWeight: FontWeight.w500,
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
                              onPressed: () {
                                Navigator.pop(context);
                              },
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
                                String playlistName = controller.text.trim();
                                
                                if (playlistName.isEmpty) {
                                  Navigator.pop(context);
                                  _showToast("Please enter a playlist name", isError: true);
                                  return;
                                }
                                
                                if (playlistName.length > 30) {
                                  Navigator.pop(context);
                                  _showToast("Playlist name cannot exceed 30 characters", isError: true);
                                  return;
                                }
                                
                                setState(() {
                                  _playlists.add({
                                    'name': playlistName,
                                    'songCount': 0,
                                    'songs': [],
                                  });
                                });
                                
                                Navigator.pop(context);
                                _showToast("Playlist '$playlistName' created");
                                controller.clear();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF0000),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text("Create"),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }

  void _showPlaylistOptionsModal(String playlistName, int index) {
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
                      child: const Icon(Icons.playlist_play, color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      playlistName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF0000),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, indent: 20, endIndent: 20),
              
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.play_arrow, color: Color(0xFFFF0000), size: 22),
                ),
                title: const Text(
                  "Play all",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context);
                  widget.onPlayPlaylist(playlistName);
                },
              ),
              
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.edit, color: Color(0xFFFF0000), size: 22),
                ),
                title: const Text(
                  "Edit",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showToast("Edit playlist - Coming soon!", isError: true);
                },
              ),
              
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5349).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delete, color: Color(0xFFFF5349), size: 22),
                ),
                title: const Text(
                  "Delete",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFF5349),
                  ),
                ),
                onTap: () {
                  setState(() {
                    _playlists.removeAt(index);
                  });
                  Navigator.pop(context);
                  _showToast("Playlist deleted");
                },
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _addSongsToPlaylist(String playlistName) {
    _showToast("Add songs to '$playlistName' - Coming soon!", isError: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3D3D3),
      appBar: AppBar(
        title: const Text(
          "Playlists",
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
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF0000).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Color(0xFFFF0000)),
              onPressed: openCreatePlaylist,
            ),
          )
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          if (_playlists.isEmpty)
            SliverFillRemaining(
              child: Center(
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
                    const Text(
                      "No playlists detected",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Tap the + button to create your first playlist",
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
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final playlist = _playlists[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                          onTap: () => widget.onPlayPlaylist(playlist['name']),
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
                                  child: const Icon(
                                    Icons.playlist_play,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        playlist['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              '${playlist['songCount']} songs',
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.library_music,
                                          color: Color(0xFFFF0000),
                                          size: 22,
                                        ),
                                        onPressed: () => _addSongsToPlaylist(playlist['name']),
                                        tooltip: 'Add songs',
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
                                          size: 22,
                                        ),
                                        onPressed: () => _showPlaylistOptionsModal(playlist['name'], index),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: _playlists.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
