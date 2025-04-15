import 'package:flutter/material.dart';
import '../utils/utils.dart';

class SongDetailScreen extends StatelessWidget {
  final Map<String, dynamic> song;

  const SongDetailScreen({super.key, required this.song});

  // dynamically create rows
  Widget buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.black)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(song['trackName'] ?? 'Detalle')),
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
                  border: Border.all(color: Colors.deepPurple, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    getBiggerArtwork(song['artworkUrl100'], 1000),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // build data rows
            buildDetailRow('🎵 Título: ', song['trackName'] ?? ''),
            buildDetailRow('👤 Artista: ', song['artistName'] ?? ''),
            buildDetailRow('💿 Álbum: ', song['collectionName'] ?? ''),
            buildDetailRow('📀 Género: ', song['primaryGenreName'] ?? ''),
            buildDetailRow(
              '⏱️ Duración: ',
              '${((song['trackTimeMillis'] ?? 0) / 60000).toStringAsFixed(2)} min',
            ),

            const SizedBox(height: 20),

            if (song['previewUrl'] != null)
              ElevatedButton(
                onPressed: () => launchPreviewUrl(song),
                child: Text('Escuchar vista previa 🔊'),
              ),
          ],
        ),
      ),
    );
  }
}
