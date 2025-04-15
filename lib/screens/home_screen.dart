import 'package:flutter/material.dart';
import '../utils/http_requests.dart';
import './song_detail_screen.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = '';
  List<dynamic> results = [];

  // final _songs = <Song>[];
  // final _seenSongs = <Song>{};

  void getSongs() async {
    results = await searchSongs(query); // Llama a la tuya, la que ya tienes
    setState(() {}); // Actualiza el widget para mostrar los resultados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MuzikMatch')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (val) => query = val,
              decoration: InputDecoration(
                labelText: 'Buscar canción',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: getSongs,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final song = results[index];
                if (index.isOdd) return Divider(color: Color($hexTeal));
                return ListTile(
                  // leading: Image.network(song['artworkUrl60']),
                  leading: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color($hexTeal), width: 2),
                      borderRadius: BorderRadius.circular(
                        5,
                      ), // Opcional, para que sea redondeado
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(song['artworkUrl60']),
                    ),
                  ),
                  title: Text(song['trackName']),
                  subtitle: Text(song['artistName']),

                  //           trailing:   Icon(
                  // alreadySaved ? Icons.favorite : Icons.favorite_border,
                  // color: alreadySaved ? Colors.red : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongDetailScreen(song: song),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
