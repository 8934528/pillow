import 'serp_service.dart';
import 'package:logger/logger.dart';

class YouTubeService {
  static final _logger = Logger();

  static Future<List<Map<String, String>>> searchVideos(String query) async {
    
    try {
      final results = await SerpService.search(query, engine: 'youtube');
      final videoResults = results['video_results'] as List?;
      
      if (videoResults != null) {
        return videoResults.map((v) => {
          'title': (v['title'] ?? '').toString(),
          'link': (v['link'] ?? '').toString(),
          'thumbnail': (v['thumbnail'] ?? '').toString(),
          'channel': (v['channel']?['name'] ?? '').toString(),
        }).toList();
      }
    } catch (e) {
      _logger.e('Error searching YouTube: $e');
    }
    
    return [];
  }
}
