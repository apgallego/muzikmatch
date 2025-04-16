class Artist {
  final String id;
  final String name;
  final String spotifyUrl;

  Artist({required this.id, required this.name, required this.spotifyUrl});

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] as String,
      name: json['name'] as String,
      spotifyUrl: json['external_urls']['spotify'] as String,
    );
  }
}
