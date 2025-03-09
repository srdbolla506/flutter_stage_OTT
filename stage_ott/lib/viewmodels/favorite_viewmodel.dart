import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../services/database_helper.dart';

class FavoriteViewModel extends ChangeNotifier {
  final Set<int> _favoriteMovies = {};
  static const String favoriteKey = "favorite_movies";
  bool _showFavoritesOnly = false;

  Set<int> get favoriteMovies => _favoriteMovies;
  bool get showFavoritesOnly => _showFavoritesOnly;

  FavoriteViewModel() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<String>? favorites = prefs.getStringList(favoriteKey);
    // if (favorites != null) {
    //   _favoriteMovies.addAll(favorites.map((id) => int.parse(id)));
    // }

    List<int> favoriteIds = await DatabaseHelper.instance.getFavoriteMovieIds();
    _favoriteMovies.addAll(favoriteIds);

    notifyListeners();
  }

  void toggleFavorite(int movieId) async {
    if (_favoriteMovies.contains(movieId)) {
      _favoriteMovies.remove(movieId);
      await DatabaseHelper.instance.removeFavorite(movieId);
    } else {
      _favoriteMovies.add(movieId);
      await DatabaseHelper.instance.addFavorite(movieId);
    }
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setStringList(
    //   favoriteKey,
    //   _favoriteMovies.map((id) => id.toString()).toList(),
    // );
    notifyListeners();
  }

  bool isFavorite(int movieId) => _favoriteMovies.contains(movieId);

  void toggleShowFavorites() {
    _showFavoritesOnly = !_showFavoritesOnly;
    notifyListeners();
  }
}
