import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:logger/logger.dart';

class YouTubeService {
  static final _logger = Logger();
  static final _yt = YoutubeExplode();

  static Future<List<Map<String, String>>> searchVideos(String query) async {
    try {
      final results = await _yt.search.search(query);
      
      return results.map((v) => {
        'title': v.title,
        'link': v.url,
        'thumbnail': v.thumbnails.mediumResUrl,
        'channel': v.author,
      }).toList();
    } catch (e) {
      _logger.e('Error searching YouTube: $e');
    }
    
    return [];
  }

  static Future<String?> getAudioStreamUrl(String url) async {
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(url);
      final audioOnly = manifest.audioOnly.withHighestBitrate();
      return audioOnly.url.toString();
    } catch (e) {
      _logger.e('Error getting audio stream: $e');
      return null;
    }
  }
}
