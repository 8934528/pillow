import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'package:url_launcher/url_launcher.dart';

class OnlineSearchPage extends StatefulWidget {
  const OnlineSearchPage({super.key});

  @override
  State<OnlineSearchPage> createState() => _OnlineSearchPageState();
}

class _OnlineSearchPageState extends State<OnlineSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<AppState>().searchOnline(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = appState.isDarkMode;
    final results = appState.onlineSearchResults;
    final isSearching = appState.isSearchingOnline;

    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFD3D3D3);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final accentColor = const Color(0xFFFF0000);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Online Search', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF0000))),
        backgroundColor: cardColor,
        elevation: 0,
        actions: [
          if (results.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all, color: Color(0xFFFF0000)),
              onPressed: () => appState.clearOnlineResults(),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search YouTube via SerpApi...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFFF0000)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFFFF0000)),
                    onPressed: _performSearch,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                onSubmitted: (_) => _performSearch(),
              ),
            ),
          ),
          if (isSearching)
            const LinearProgressIndicator(color: Color(0xFFFF0000)),
          Expanded(
            child: results.isEmpty
                ? _buildEmptyState(isSearching)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final item = results[index];
                      return _buildResultTile(item, cardColor, accentColor, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultTile(Map<String, String> item, Color cardColor, Color accentColor, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: accentColor.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: item['thumbnail'] != null && item['thumbnail']!.isNotEmpty
            ? Image.network(
                item['thumbnail']!,
                width: 100,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100, height: 60, color: accentColor.withValues(alpha: 0.1),
                  child: const Icon(Icons.video_library, color: Color(0xFFFF0000)),
                ),
              )
            : Container(
                width: 100, height: 60, color: accentColor.withValues(alpha: 0.1),
                child: const Icon(Icons.video_library, color: Color(0xFFFF0000)),
              ),
        ),
        title: Text(
          item['title'] ?? 'Unknown Title',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          item['channel'] ?? 'Unknown channel',
          style: const TextStyle(fontSize: 12),
        ),
        onTap: () async {
          final url = item['link'];
          if (url != null && await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url));
          }
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.cloud_download : Icons.travel_explore,
            size: 64,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            isSearching ? 'Searching...' : 'Explore more on YouTube',
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
