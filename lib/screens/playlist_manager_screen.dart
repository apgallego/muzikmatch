import 'package:flutter/material.dart';
import 'package:muzikmatch/constants.dart';
import '../classes/playlist.dart';

class PlaylistManagerScreen extends StatefulWidget {
  const PlaylistManagerScreen({super.key});

  @override
  _PlaylistManagerScreenState createState() => _PlaylistManagerScreenState();
}

class _PlaylistManagerScreenState extends State<PlaylistManagerScreen> {
  final _playlistList = <Playlist>{};

  void _showAddPlaylistDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create new playlist'),
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
              child: const Text(
                'Create',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newPlaylist = Playlist(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text.trim(),
                    nSongs: 0,
                    songs: [],
                  );

                  setState(() {
                    _playlistList.add(newPlaylist);
                  });

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
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
          );
        },
        separatorBuilder:
            (context, index) =>
                const Divider(color: Color($primaryColor)), // Divider here
      ),
    );
  }
}
