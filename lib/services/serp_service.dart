import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SerpService {
  static String get _apiKey => dotenv.get('SERP_API_KEY');

  static Future<Map<String, dynamic>> search(String query, {String engine = 'google'}) async {
    final url = Uri.parse('https://serpapi.com/search.json?q=$query&engine=$engine&api_key=$_apiKey');
    
    print('Searching SerpApi for "$query" using engine: $engine...');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load search results: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in SerpService.search: $e');
      rethrow;
    }
  }
}
