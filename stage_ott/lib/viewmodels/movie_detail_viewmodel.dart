import 'package:flutter/material.dart';
import 'package:stage_ott/services/movie_api.dart';
import '../models/movie.dart';

class MovieDetailViewModel extends ChangeNotifier {
  final Movie movie;
  bool isFavorite;
  List<String> trailers = [];

  Future<void> loadTrailers(int movieId) async {
    trailers = await MovieApi.fetchMovieTrailers(movieId);
    notifyListeners();
  }

  MovieDetailViewModel({required this.movie, required this.isFavorite});

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
