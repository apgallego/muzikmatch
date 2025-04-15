import 'package:flutter/material.dart';
import '../utils/utils.dart';
import '../constants.dart';

class SongDetailScreen extends StatefulWidget {
  final Map<String, dynamic> song;

  const SongDetailScreen({super.key, required this.song});

  @override
  State<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  bool isPlaying = false;
  bool isLoadingArtwork = false;

  // dinámicamente crea filas de detalles
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
                  border: Border.all(color: Color($hexTeal), width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    getBiggerArtwork(song['artworkUrl100'] ?? '', 1000),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
              Center(
                child: ElevatedButton(
                  onPressed: togglePreview,
                  child: Text(
                    isPlaying
                        ? 'Parar vista previa 🔇'
                        : 'Escuchar vista previa 🔊',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
