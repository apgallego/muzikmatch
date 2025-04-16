import 'package:flutter/material.dart';
import 'package:muzikmatch/classes/song.dart';
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
  List<Song> results = []; // Cambiado a una lista de objetos Song

  bool isLoading = false;

  final TextEditingController _controller = TextEditingController();

  // Lógica de obtención de canciones
  void getSongs() async {
    setState(() {
      isLoading = true;
    });

    final response = await searchSongs(query);

    setState(() {
      results = (response).map((songJson) => Song.fromJson(songJson)).toList();
      isLoading = false;
    });
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
              controller: _controller,
              onChanged: (val) => query = val,
              onSubmitted: (val) {
                query = val;
                getSongs();
              },
              decoration: InputDecoration(
                labelText: 'Search Song',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: Icon(Icons.search), onPressed: getSongs),
                    IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          query = '';
                          _controller.clear();
                          results = [];
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Mostramos un cargador mientras se busca
          if (isLoading) const Center(child: CircularProgressIndicator()),

          // Mostramos los resultados cuando termina la búsqueda
          if (!isLoading)
            Expanded(
              child:
                  results.isEmpty
                      ? Center(
                        child: Text(
                          'No songs found. Try another search 🎧',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      )
                      : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final song = results[index];

                          // Separador opcional entre elementos
                          if (index.isOdd) {
                            return Divider(color: Color($hexTeal));
                          }

                          return ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color($hexTeal),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(song.artworkUrl60),
                              ),
                            ),
                            title: Text(song.trackName),
                            subtitle: Text(song.artistName),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => SongDetailScreen(song: song),
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
