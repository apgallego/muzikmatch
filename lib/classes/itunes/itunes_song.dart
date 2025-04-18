class ITunesSong {
  final String wrapperType;
  final String kind;
  final int artistId;
  final int collectionId;
  final int trackId;
  final String artistName;
  final String collectionName;
  final String trackName;
  final String collectionCensoredName;
  final String trackCensoredName;
  final String artistViewUrl;
  final String collectionViewUrl;
  final String trackViewUrl;
  final String previewUrl;
  final String artworkUrl30;
  final String artworkUrl60;
  final String artworkUrl100;
  final double collectionPrice;
  final double trackPrice;
  final DateTime releaseDate;
  final String collectionExplicitness;
  final String trackExplicitness;
  final int discCount;
  final int discNumber;
  final int trackCount;
  final int trackNumber;
  final int trackTimeMillis;
  final String country;
  final String currency;
  final String primaryGenreName;
  final String? contentAdvisoryRating;
  final bool isStreamable;

  // Constructor
  ITunesSong({
    required this.wrapperType,
    required this.kind,
    required this.artistId,
    required this.collectionId,
    required this.trackId,
    required this.artistName,
    required this.collectionName,
    required this.trackName,
    required this.collectionCensoredName,
    required this.trackCensoredName,
    required this.artistViewUrl,
    required this.collectionViewUrl,
    required this.trackViewUrl,
    required this.previewUrl,
    required this.artworkUrl30,
    required this.artworkUrl60,
    required this.artworkUrl100,
    required this.collectionPrice,
    required this.trackPrice,
    required this.releaseDate,
    required this.collectionExplicitness,
    required this.trackExplicitness,
    required this.discCount,
    required this.discNumber,
    required this.trackCount,
    required this.trackNumber,
    required this.trackTimeMillis,
    required this.country,
    required this.currency,
    required this.primaryGenreName,
    this.contentAdvisoryRating,
    required this.isStreamable,
  });

  // Factory constructor to create a Song from a JSON map
  factory ITunesSong.fromJson(Map<String, dynamic> json) {
    return ITunesSong(
      wrapperType: json['wrapperType'] as String,
      kind: json['kind'] as String,
      artistId: json['artistId'] as int,
      collectionId: json['collectionId'] as int,
      trackId: json['trackId'] as int,
      artistName: json['artistName'] as String,
      collectionName: json['collectionName'] as String,
      trackName: json['trackName'] as String,
      collectionCensoredName: json['collectionCensoredName'] as String,
      trackCensoredName: json['trackCensoredName'] as String,
      artistViewUrl: json['artistViewUrl'] as String,
      collectionViewUrl: json['collectionViewUrl'] as String,
      trackViewUrl: json['trackViewUrl'] as String,
      previewUrl: json['previewUrl'] as String,
      artworkUrl30: json['artworkUrl30'] as String,
      artworkUrl60: json['artworkUrl60'] as String,
      artworkUrl100: json['artworkUrl100'] as String,
      collectionPrice: (json['collectionPrice'] as num).toDouble(),
      trackPrice: (json['trackPrice'] as num).toDouble(),
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      collectionExplicitness: json['collectionExplicitness'] as String,
      trackExplicitness: json['trackExplicitness'] as String,
      discCount: json['discCount'] as int,
      discNumber: json['discNumber'] as int,
      trackCount: json['trackCount'] as int,
      trackNumber: json['trackNumber'] as int,
      trackTimeMillis: json['trackTimeMillis'] as int,
      country: json['country'] as String,
      currency: json['currency'] as String,
      primaryGenreName: json['primaryGenreName'] as String,
      contentAdvisoryRating: json['contentAdvisoryRating'] as String?,
      isStreamable: json['isStreamable'] as bool,
    );
  }

  // Method to convert Song instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'wrapperType': wrapperType,
      'kind': kind,
      'artistId': artistId,
      'collectionId': collectionId,
      'trackId': trackId,
      'artistName': artistName,
      'collectionName': collectionName,
      'trackName': trackName,
      'collectionCensoredName': collectionCensoredName,
      'trackCensoredName': trackCensoredName,
      'artistViewUrl': artistViewUrl,
      'collectionViewUrl': collectionViewUrl,
      'trackViewUrl': trackViewUrl,
      'previewUrl': previewUrl,
      'artworkUrl30': artworkUrl30,
      'artworkUrl60': artworkUrl60,
      'artworkUrl100': artworkUrl100,
      'collectionPrice': collectionPrice,
      'trackPrice': trackPrice,
      'releaseDate': releaseDate.toIso8601String(),
      'collectionExplicitness': collectionExplicitness,
      'trackExplicitness': trackExplicitness,
      'discCount': discCount,
      'discNumber': discNumber,
      'trackCount': trackCount,
      'trackNumber': trackNumber,
      'trackTimeMillis': trackTimeMillis,
      'country': country,
      'currency': currency,
      'primaryGenreName': primaryGenreName,
      'contentAdvisoryRating': contentAdvisoryRating,
      'isStreamable': isStreamable,
    };
  }
}
