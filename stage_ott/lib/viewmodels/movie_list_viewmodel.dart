import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_api.dart';
import '../services/database_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MovieListViewModel extends ChangeNotifier {
  List<Movie> _movies = [];

  bool _isLoading = false;
  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;

  bool _isOffline = false;
  bool get isOffline => _isOffline;

  // bool _isFetched = false;

  MovieListViewModel() {
    _checkConnectivity();
  }

  Future<void> _checkIfOffline() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _isOffline = (connectivityResult == ConnectivityResult.none);
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _isOffline = (connectivityResult == ConnectivityResult.none);
    notifyListeners();
    print("Connectivity Status: $_isOffline");

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
    // if (_movies.isNotEmpty) {
    //   _isOffline = false;
    // }
    _checkIfOffline();
    notifyListeners();
  }

  Future<void> fetchMovies() async {
    print("Connectivity Status: $_isOffline");

    await _checkIfOffline();

    if (isOffline) {
      await loadfromCache();
      return;
    }

    if (_movies.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    // if (_isFetched || _movies.isNotEmpty) {
    //   loadfromCache();
    //   return;
    // }
    // if (_isOffline) return; // skip API calls when offline

    // // Load from SQlite first to make UI faster
    // _movies = await DatabaseHelper.instance.getMovies();
    // notifyListeners();

    //Now fetch from API and update UI
    // _isFetched = true;

    try {
      await MovieApi.fetchGenres();
      List<Movie> apiMovies = await MovieApi.getMovies();
      if (apiMovies.isNotEmpty) {
        _movies = apiMovies;
        await DatabaseHelper.instance.clearMovies(); // clear old data
        await DatabaseHelper.instance.insertMovies(_movies);
      } else {
        await loadfromCache();
      }
    } catch (e) {
      await loadfromCache();
    }

    // _isFetched = false;
    _isLoading = false;
    notifyListeners();
  }

  // void retryFetch() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   if (connectivityResult != ConnectivityResult.none) {
  //     await fetchMovies();
  //   }
  // }
}
