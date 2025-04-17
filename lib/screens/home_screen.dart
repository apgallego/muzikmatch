import 'package:flutter/material.dart';
import 'package:muzikmatch/classes/playlist.dart';
import 'package:muzikmatch/classes/song.dart';
import 'package:muzikmatch/db/database_helper.dart';
import 'package:muzikmatch/screens/playlist_manager_screen.dart';
import 'package:muzikmatch/utils/utils.dart';
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
  List<Song> results = [];
  final List<Playlist> _playlistList = [];
  final DbHelper _dbHelper = DbHelper();

  bool isLoading = false;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  void _loadPlaylists() async {
    try {
      final lists = await _dbHelper.getAllPlaylists();

      setState(() {
        _playlistList.clear();
        _playlistList.addAll(lists);
      });
    } catch (e) {
      //show snackbar after first frame, in case the context was   not fully loaded
      // ignore: use_build_context_synchronously
      showSnackBar("Error loading playlists", context);
    }
  }

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

  void _showPlaylistSelectionDialog(BuildContext context, Song song) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add to playlist'),
          backgroundColor: Color($secondaryColor),
          content:
              _playlistList.isEmpty
                  ? const Text('No playlists available!')
                  : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children:
                          _playlistList.map((playlist) {
                            return ListTile(
                              title: Text(playlist.name),
                              onTap: () {
                                setState(() {
                                  playlist.songs.add(
                                    song,
                                  ); // Aquí asumes que tienes la lista de canciones dentro
                                  playlist.nSongs = playlist.songs.length;
                                });
                                Navigator.of(context).pop();
                              },
                            );
                          }).toList(),
                    ),
                  ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
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
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      )
                      : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final song = results[index];

                          // Separador opcional entre elementos
                          if (index.isOdd) {
                            return Divider(color: Color($primaryColor));
                          }

                          return ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color($primaryColor),
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
                            trailing: IconButton(
                              onPressed: () {
                                _showPlaylistSelectionDialog(context, song);
                              },
                              icon: Icon(Icons.add_circle_outline),
                            ),
                          );
                        },
                      ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color($primaryColor),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PlaylistManagerScreen(),
            ),
          );
        },
        tooltip: 'Create playlist',
        child: const Icon(Icons.playlist_add),
      ),
    );
  }
}
