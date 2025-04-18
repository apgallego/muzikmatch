import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:muzikmatch/classes/song.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

void playPreview(Song song) {
  player.play(UrlSource(song.previewUrl));
}

void stopPreview() {
  player.stop();
}

//show snackbar error
void showSnackBar(text, context) {
  //show snackbar after first frame, in case the context was   not fully loaded
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.redAccent,
      ),
    );
  });
}

//delete db
Future<void> deleteLocalDatabase() async {
  final path = join(await getDatabasesPath(), 'muzikmatch.db');
  await deleteDatabase(path);
  print('✅ Base de datos eliminada correctamente.');
}

//format millis
String formatMillis(millis) => (millis / 60000).toStringAsFixed(2);
