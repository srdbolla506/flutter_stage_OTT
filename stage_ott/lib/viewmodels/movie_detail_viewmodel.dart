import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieDetailViewModel extends ChangeNotifier {
  final Movie movie;
  bool isFavorite;

  MovieDetailViewModel({required this.movie, required this.isFavorite});

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
