import 'package:flutter/material.dart';
import 'package:muzikmatch/constants.dart';
import 'package:muzikmatch/db/database_helper.dart';
import 'package:muzikmatch/screens/playlist_screen.dart';
import '../classes/playlist.dart';
import '../utils/utils.dart';

class PlaylistManagerScreen extends StatefulWidget {
  const PlaylistManagerScreen({super.key});

  @override
  _PlaylistManagerScreenState createState() => _PlaylistManagerScreenState();
}

class _PlaylistManagerScreenState extends State<PlaylistManagerScreen> {
  final _playlistList = <Playlist>{};
  final DbHelper _dbHelper = DbHelper();

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
      // ignore: use_build_context_synchronously
      showSnackBar("Error loading playlists", context);
    }
  }

  void _showAddPlaylistDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 2.0)),
            ),
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              'Create new playlist',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          backgroundColor: Color($secondaryColor),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Playlist name'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Type a valid name.';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color($primaryColor),
              ),
              onPressed: () {
                _createPlaylist(formKey, nameController);
              },
              child: const Text(
                'Create',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String playlistId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 2.0)),
            ),
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              'Delete playlist',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: Text('This action cannot be undone.'),
          backgroundColor: Colors.redAccent,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // operation is cancelled
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // user deletes playlist
                _deletePlaylist(playlistId);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createPlaylist(formKey, nameController) async {
    if (formKey.currentState!.validate()) {
      final newPlaylist = Playlist(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text.trim(),
        nSongs: 0,
        songs: [],
        playlistTimeMillis: 0,
      );

      try {
        await _dbHelper.insertPlaylist(newPlaylist);
        _loadPlaylists();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      } catch (e) {
        // ignore: use_build_context_synchronously
        showSnackBar("Error saving playlist", context);
      }
    }
  }

  Future<void> _deletePlaylist(String playlistId) async {
    try {
      await _dbHelper.deletePlaylist(playlistId);
      _loadPlaylists();
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar("Error deleting playlist", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlist Manager'),
        actions: <Widget>[
          IconButton(
            onPressed: _showAddPlaylistDialog,
            icon: Icon(Icons.add_circle_outlined),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: _playlistList.length,
        itemBuilder: (context, index) {
          final playlist = _playlistList.elementAt(index); // For sets
          return ListTile(
            title: Text(playlist.name),
            subtitle: Text('${playlist.nSongs} songs'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirmationDialog(context, playlist.id);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaylistScreen(playlist: playlist),
                ),
              ).then((_) {
                _loadPlaylists();
              });
            },
          );
        },
        separatorBuilder:
            (context, index) =>
                const Divider(color: Color($primaryColor)), // Divider here
      ),
    );
  }
}
