import 'package:flutter/material.dart';
import 'package:muzikmatch/db/database_helper.dart';
import 'package:muzikmatch/utils/utils.dart';
import '../classes/song.dart';
import '../constants.dart';
import '../classes/playlist.dart';

class PlaylistScreen extends StatefulWidget {
  final Playlist playlist;

  const PlaylistScreen({super.key, required this.playlist});

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late List<Song> songs;
  final DbHelper _dbHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    songs = List.from(widget.playlist.songs);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final song = songs.removeAt(oldIndex);
      songs.insert(newIndex, song);
      _dbHelper.updateSongOrder(widget.playlist.id, songs);
    });

    widget.playlist.songs = songs;
  }

  void _removeSong(
    int index,
    String playlistId,
    int songId,
    int songMillis,
  ) async {
    try {
      await _dbHelper.deleteSongFromPlaylist(playlistId, songId, songMillis);

      setState(() {
        songs.removeAt(index);
        widget.playlist.playlistTimeMillis -= songMillis;
        widget.playlist.nSongs--;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar("Error deleting song from playlist.", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.playlist.name)),
      body: ReorderableListView.builder(
        itemCount: songs.length,
        onReorder: _onReorder,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (context, index) {
          final song = songs[index];
          return ListTile(
            key: ValueKey(song.trackId),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color($primaryColor), width: 2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(song.artworkUrl60),
                  ),
                ),
              ],
            ),
            title: Text(song.trackName),
            subtitle: Text(song.artistName),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed:
                  () => _removeSong(
                    index,
                    widget.playlist.id,
                    song.trackId,
                    song.trackTimeMillis,
                  ),
            ),
          );
        },
      ),
    );
  }
}
