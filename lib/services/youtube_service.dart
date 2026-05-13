import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class YouTubeService {
  static final _logger = Logger();
  
  // Custom client to bypass CORS on Web
  static final _yt = YoutubeExplode();

  static Future<List<Map<String, String>>> searchVideos(String query) async {
    try {
      final results = await _yt.search.search(query);
      
      return results.map((v) => {
        'title': v.title,
        'link': v.url,
        'thumbnail': v.thumbnails.mediumResUrl,
        'channel': v.author,
        'duration': v.duration?.inSeconds.toString() ?? '0',
      }).toList();
    } catch (e) {
      _logger.e('Error searching YouTube: $e');
    }
    
    return [];
  }

  static Future<String?> getAudioStreamUrl(String videoUrl) async {
    final yt = YoutubeExplode();
    try {
      final video = await yt.videos.get(videoUrl);
      final manifest = await yt.videos.streamsClient.getManifest(video.id);
      
      // Get the highest quality audio stream
      final audioStream = manifest.audioOnly.withHighestBitrate();
      
      // Return the URL
      return audioStream.url.toString();
    } catch (e) {
      _logger.e('Error getting audio stream for $videoUrl: $e');
      return null;
    } finally {
      yt.close();
    }
  }
}
