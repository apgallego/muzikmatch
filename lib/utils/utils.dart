import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';

//get bigger song artworks
String getBiggerArtwork($artwork, px) {
  String artwork = $artwork.replaceAll(
    RegExp(r'\d+x\d+bb.jpg'),
    '${px}x${px}bb.jpg',
  );
  return artwork;
}

//open preview URL
void launchPreviewUrl(Map<String, dynamic> song) async {
  final url = song['previewUrl'];
  if (url != null) {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not open preview URL.';
    }
  }
}

// play preview URL

final AudioPlayer player = AudioPlayer();

void playPreview(Map<String, dynamic> song) {
  player.play(UrlSource(song['previewUrl']));
}

void stopPreview() {
  player.stop();
}
