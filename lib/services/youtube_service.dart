import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'serp_service.dart';

class YouTubeService {
  static Future<List<Map<String, String>>> searchVideos(String query) async {
    print('Searching YouTube via SerpApi for "$query"...');
    
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
      print('Error searching YouTube: $e');
    }
    
    return [];
  }
}
