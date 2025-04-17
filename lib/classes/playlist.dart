import '../classes/song.dart';

class Playlist {
  final String id;
  String name;
  int nSongs;
  List<Song> songs;

  Playlist({
    required this.id,
    required this.name,
    required this.nSongs,
    required this.songs,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] as String,
      name: json['name'] as String,
      nSongs: json['nSongs'] as int,
      songs:
          (json['songs'] as List)
              .map((songJson) => Song.fromJson(songJson))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nSongs': nSongs,
      'songs': songs.map((song) => song.toJson()).toList(),
    };
  }
}
