import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/track.dart';

class MusicService {
  static const String _baseUrl = 'https://itunes.apple.com/search';

  Future<List<Track>> fetchTracks(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse('$_baseUrl?term=$query&media=music&limit=200');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        final List<Track> tracks = [];

        for (var element in results) {
          if (element['previewUrl'] != null) {
            tracks.add(Track.fromJson(element));
          }
        }

        return tracks;
      } else {
        throw Exception('Failed to load tracks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching tracks: $e');
    }
  }
}
