import 'package:flutter/material.dart';
import 'package:stage_ott/services/movie_api.dart';
import '../models/movie.dart';
import '../services/database_helper.dart';

class MovieDetailViewModel extends ChangeNotifier {
  final Movie movie;
  bool isFavorite;
  List<String> trailers = [];

  Future<void> loadTrailers(int movieId) async {
    trailers = await MovieApi.fetchMovieTrailers(movieId);
    notifyListeners();
  }

  MovieDetailViewModel({required this.movie, required this.isFavorite});

  void toggleFavorite() async {
    isFavorite = !isFavorite;
    if (isFavorite) {
      await DatabaseHelper.instance.addFavorite(movie.id);
    } else {
      await DatabaseHelper.instance.removeFavorite(movie.id);
    }
    notifyListeners();
  }
}
