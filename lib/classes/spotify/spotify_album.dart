class Album {
  final String id;
  final String name;
  final String spotifyUrl;
  final String releaseDate;
  final List<String> images;

  Album({
    required this.id,
    required this.name,
    required this.spotifyUrl,
    required this.releaseDate,
    required this.images,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as String,
      name: json['name'] as String,
      spotifyUrl: json['external_urls']['spotify'] as String,
      releaseDate: json['release_date'] as String,
      images:
          (json['images'] as List)
              .map((imageJson) => imageJson['url'] as String)
              .toList(),
    );
  }
}
