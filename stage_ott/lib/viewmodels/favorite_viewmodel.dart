import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../services/database_helper.dart';

class FavoriteViewModel extends ChangeNotifier {
  final Set<int> _favoriteMovies = {};
  String? _errorMessage;

  Set<int> get favoriteMovies => _favoriteMovies;
  String? get errorMessage => _errorMessage;

  FavoriteViewModel() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      List<int> favoriteIds =
          await DatabaseHelper.instance.getFavoriteMovieIds();
      _favoriteMovies.addAll(favoriteIds);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Failed to load favorite movies.";
    }
    notifyListeners();
  }

  void toggleFavorite(int movieId) async {
    try {
      if (_favoriteMovies.contains(movieId)) {
        _favoriteMovies.remove(movieId);
        await DatabaseHelper.instance.removeFavorite(movieId);
      } else {
        _favoriteMovies.add(movieId);
        await DatabaseHelper.instance.addFavorite(movieId);
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Error updating favorites";
    }
    notifyListeners();
  }

  bool isFavorite(int movieId) => _favoriteMovies.contains(movieId);
}
