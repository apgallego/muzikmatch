class Song {
  String trackId;
  String? collectionId;
  String? artistId;
  String name;
  String artist;
  String album;
  String? artwork;
  String? genre;
  int? trackTimeMillis;
  String? releaseDate;
  String? contentAdvisoryRating;
  bool isStreameable = false;

  /// Create a [Song] from the strings [first] and [second].
  Song(this.trackId, this.name, this.artist, this.album) {
    if (trackId == 0 || name.isEmpty || artist.isEmpty || album.isEmpty) {
      throw ArgumentError(
        "Song needs more data. "
            "Received: '$trackId', '$name'",
        '$artist'
            ", '$album'",
      );
    }
  }
}
