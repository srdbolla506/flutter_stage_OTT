import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_api.dart';
import '../services/database_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MovieListViewModel extends ChangeNotifier {
  List<Movie> _movies = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;

  bool _isOffline = false;
  bool get isOffline => _isOffline;

  String? get errorMessage => _errorMessage;

  // bool _isFetched = false;

  MovieListViewModel() {
    _checkConnectivity();
  }

  Future<void> _checkIfOffline() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _isOffline = (connectivityResult == ConnectivityResult.none);
  }

  Future<void> _checkConnectivity() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      _isOffline = (connectivityResult == ConnectivityResult.none);
      notifyListeners();
      print("Connectivity Status: $_isOffline");

      if (!_isOffline) {
        fetchMovies();
      } else {
        loadfromCache(); // load from Cache - sqlite for offline
      }
    } catch (e) {
      _errorMessage = "Failed to check internet connection.";
      notifyListeners();
    }

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        fetchMovies();
      }
    });
  }

  Future<void> loadfromCache() async {
    try {
      _movies = await DatabaseHelper.instance.getMovies();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Failed to load cached movies.";
    }
    notifyListeners();
  }

  Future<void> fetchMovies() async {
    print("Connectivity Status: $_isOffline");

    await _checkIfOffline();

    // If offline or not connected to internte, load cached data from sqlite
    if (isOffline) {
      await loadfromCache();
      return;
    }

    if (_movies.isNotEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    //Now fetch from API and update UI
    try {
      await MovieApi.fetchGenres();
      List<Movie> apiMovies = await MovieApi.getMovies();
      if (apiMovies.isNotEmpty) {
        _movies = apiMovies;
        await DatabaseHelper.instance.clearMovies(); // clear old data
        await DatabaseHelper.instance.insertMovies(_movies);
      } else {
        _errorMessage = "No movies found.";
      }
    } catch (e) {
      _errorMessage = "Error fetching movies. Showing cached data.";
      print(_errorMessage);
      await loadfromCache();
    }

    _isLoading = false;
    notifyListeners();
  }
}
