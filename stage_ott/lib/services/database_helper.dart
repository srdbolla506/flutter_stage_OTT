import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/movie.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper();
  static Database? _database;
  DatabaseHelper();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('movies.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE movies (
        id INTEGER PRIMARY KEY,
        title TEXT,
        imageUrl TEXT,
        bannerUrl TEXT,
        synopsis TEXT,
        genres TEXT,
        releaseDate TEXT,
        voteAverage REAL,
        isFavorite INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY
      )
    ''');
  }

  // Inserts multiple movies efficiently using batch
  Future<void> insertMovies(List<Movie> movies) async {
    final db = await database;
    final batch = db.batch();

    try {
      for (var movie in movies) {
        batch.insert(
          'movies',
          movie.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true); // Executes all inserts in one go
    } catch (e) {
      print("Error inserting movies: $e");
    }
  }

  // Retrieve all movies from Sqlite
  Future<List<Movie>> getMovies() async {
    final db = await database;
    try {
      final result = await db.query('movies');
      return result.map((json) => Movie.fromMap(json)).toList();
    } catch (e) {
      print("Error fetching movies from database: $e");
      return [];
    }
  }

  Future<void> clearMovies() async {
    final db = await database;
    try {
      await db.delete('movies');
    } catch (e) {
      print("Error clearing movies: $e");
    }
  }

  // favourites storage
  Future<void> addFavorite(int movieId) async {
    final db = await database;
    try {
      await db.insert('favorites', {
        'id': movieId,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print("Error adding favorite: $e");
    }
  }

  Future<void> removeFavorite(int movieId) async {
    final db = await database;
    try {
      await db.delete('favorites', where: 'id = ?', whereArgs: [movieId]);
    } catch (e) {
      print("Error removing favorite: $e");
    }
  }

  Future<List<int>> getFavoriteMovieIds() async {
    final db = await database;
    try {
      final result = await db.query('favorites');
      return result.map((row) => row['id'] as int).toList();
    } catch (e) {
      print("Error fetching favorite movie Ids: $e");
      return [];
    }
  }
}
