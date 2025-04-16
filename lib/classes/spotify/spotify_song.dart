import 'package:muzikmatch/classes/spotify/spotify_album.dart';
import 'package:muzikmatch/classes/spotify/spotify_artist.dart';

class SpotifySong {
  final String id;
  final String name;
  final String previewUrl;
  final bool isExplicit;
  final int durationMs;
  final List<Artist> artists;
  final Album album;

  SpotifySong({
    required this.id,
    required this.name,
    required this.previewUrl,
    required this.isExplicit,
    required this.durationMs,
    required this.artists,
    required this.album,
  });

  factory SpotifySong.fromJson(Map<String, dynamic> json) {
    return SpotifySong(
      id: json['id'] as String,
      name: json['name'] as String,
      previewUrl: json['preview_url'] as String? ?? '',
      isExplicit: json['explicit'] as bool,
      durationMs: json['duration_ms'] as int,
      artists:
          (json['artists'] as List)
              .map((artistJson) => Artist.fromJson(artistJson))
              .toList(),
      album: Album.fromJson(json['album']),
    );
  }
}
