import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../classes/song.dart';
import '../classes/playlist.dart';

class DbHelper {
  static const _dbName = 'muzikmatch.db';
  static const _dbVersion = 1;

  static const tablePlaylists = 'playlists';
  static const tableSongs = 'songs';
  static const tablePlaylistSongs = 'playlist_songs';

  // Db instance
  Database? _database;

  // Db get (lazy initialization)
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDb();
    return _database!;
  }

  // initialize db
  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  // create tables
  Future<void> _onCreate(Database db, int version) async {
    // songs
    await db.execute('''
      CREATE TABLE $tableSongs (
        id INTEGER PRIMARY KEY,
        trackName TEXT NOT NULL,
        artistName TEXT NOT NULL,
        artworkUrl60 TEXT
      );
    ''');

    // playlists
    await db.execute('''
      CREATE TABLE $tablePlaylists (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        nSongs INTEGER NOT NULL
      );
    ''');

    // playlists_songs
    await db.execute('''
      CREATE TABLE $tablePlaylistSongs (
        playlistId TEXT,
        songId INTEGER,
        FOREIGN KEY (playlistId) REFERENCES $tablePlaylists (id),
        FOREIGN KEY (songId) REFERENCES $tableSongs (id),
        PRIMARY KEY (playlistId, songId)
      );
    ''');
  }

  // insert song
  Future<void> insertSong(Song song) async {
    final db = await database;
    await db.insert(
      tableSongs,
      song.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // insert playlist
  Future<void> insertPlaylist(Playlist playlist) async {
    final db = await database;

    // insert playlist
    await db.insert(tablePlaylists, {
      'id': playlist.id,
      'name': playlist.name,
      'nSongs': playlist.nSongs,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    // insert associated songs to playlist
    for (var song in playlist.songs) {
      await db.insert(tablePlaylistSongs, {
        'playlistId': playlist.id,
        'songId': song.trackId,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // get all songs
  Future<List<Song>> getAllSongs() async {
    final db = await database;
    final result = await db.query(tableSongs);

    return result.map((map) => Song.fromMap(map)).toList();
  }

  // get all playlists
  Future<List<Playlist>> getAllPlaylists() async {
    final db = await database;
    final result = await db.query(tablePlaylists);

    List<Playlist> playlists = [];
    for (var map in result) {
      // get songs from a specific playlist
      final playlistId = map['id'] as String;
      final songs = await getSongsFromPlaylist(playlistId);

      playlists.add(
        Playlist(
          id: playlistId,
          name: map['name'] as String,
          nSongs: map['nSongs'] as int,
          songs: songs,
        ),
      );
    }

    return playlists;
  }

  // get all songs associated to a certain playlist
  Future<List<Song>> getSongsFromPlaylist(String playlistId) async {
    final db = await database;

    final result = await db.query(
      tablePlaylistSongs,
      where: 'playlistId = ?',
      whereArgs: [playlistId],
    );

    List<Song> songs = [];
    for (var map in result) {
      final songId = map['songId'] as int;

      // get song
      final songMap = await db.query(
        tableSongs,
        where: 'id = ?',
        whereArgs: [songId],
      );

      if (songMap.isNotEmpty) {
        songs.add(Song.fromMap(songMap.first));
      }
    }

    return songs;
  }

  // update playlist
  Future<void> updatePlaylist(Playlist playlist) async {
    final db = await database;

    await db.update(
      tablePlaylists,
      {'name': playlist.name, 'nSongs': playlist.nSongs},
      where: 'id = ?',
      whereArgs: [playlist.id],
    );
  }

  // delete playlist
  Future<void> deletePlaylist(String playlistId) async {
    final db = await database;

    // delete associated songs
    await db.delete(
      tablePlaylistSongs,
      where: 'playlistId = ?',
      whereArgs: [playlistId],
    );

    // delete playlist
    await db.delete(tablePlaylists, where: 'id = ?', whereArgs: [playlistId]);
  }

  // delete a song from a specific playlist
  Future<void> deleteSongFromPlaylist(String playlistId, int songId) async {
    final db = await database;

    await db.delete(
      tablePlaylistSongs,
      where: 'playlistId = ? AND songId = ?',
      whereArgs: [playlistId, songId],
    );
  }
}
