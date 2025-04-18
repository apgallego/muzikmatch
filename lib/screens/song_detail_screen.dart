import 'package:flutter/material.dart';
import 'package:muzikmatch/classes/song.dart'; // Importamos la clase Song
import '../utils/utils.dart';
import '../constants.dart';

class SongDetailScreen extends StatefulWidget {
  final Song song;

  const SongDetailScreen({super.key, required this.song});

  @override
  State<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  bool isPlaying = false;
  bool isLoadingArtwork = false;

  // Create data rows
  Widget buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.black)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void togglePreview() {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      playPreview(widget.song);
    } else {
      stopPreview();
    }
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.song;

    return Scaffold(
      appBar: AppBar(title: Text(song.trackName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color($primaryColor), width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    getBiggerArtwork(
                      song.artworkUrl100,
                      1000,
                    ), // Usamos la URL correcta
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // Imagen ya cargada
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildDetailRow('🎵 Title: ', song.trackName),
            buildDetailRow('👤 Artist: ', song.artistName),
            buildDetailRow('💿 Album: ', song.collectionName),
            buildDetailRow('📀 Genre: ', song.primaryGenreName),
            buildDetailRow(
              '⏱️ Length: ',
              '${formatMillis(song.trackTimeMillis)} min', // Calculamos la duración
            ),
            const SizedBox(height: 20),
            // Verificamos si hay un previewUrl
            Center(
              child: ElevatedButton(
                onPressed: togglePreview,
                child: Text(
                  isPlaying ? 'Stop preview 🔇' : 'Listen preview 🔊',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
