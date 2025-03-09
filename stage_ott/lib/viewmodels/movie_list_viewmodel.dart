import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_api.dart';
import '../services/database_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MovieListViewModel extends ChangeNotifier {
  List<Movie> _movies = [];
  List<Movie> get movies => _movies;
  bool _isOffline = false;
  bool get isOffline => _isOffline;

  MovieListViewModel() {
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _isOffline = connectivityResult == ConnectivityResult.none;
    notifyListeners();

    if (!_isOffline) {
      fetchMovies();
    } else {
      loadfromCache(); // load from Cache - sqlite for offline
    }

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        fetchMovies();
      }
    });
  }

  Future<void> loadfromCache() async {
    _movies = await DatabaseHelper.instance.getMovies();
    notifyListeners();
  }

  Future<void> fetchMovies() async {
    if (_isOffline) return; // skip API calls when offline

    // // Load from SQlite first to make UI faster
    // _movies = await DatabaseHelper.instance.getMovies();
    // notifyListeners();

    //Now fetch from API and update UI
    try {
      List<Movie> apiMovies = await MovieApi.getMovies();
      if (apiMovies.isEmpty) {
        _isOffline = true;
        loadfromCache();
      } else {
        _isOffline = false;
        _movies = apiMovies;
        await DatabaseHelper.instance.clearMovies(); // clear old data
        await DatabaseHelper.instance.insertMovies(movies);
      }
    } catch (e) {
      _isOffline = true;
      loadfromCache();
    }

    notifyListeners();
  }

  void retryFetch() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      await fetchMovies();
    }
  }
}
