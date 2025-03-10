import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../viewmodels/movie_list_viewmodel.dart';
import '../viewmodels/favorite_viewmodel.dart';
import '../views/movie_detail_screen.dart';
import '../widgets/movie_card.dart';
import '../models/movie.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool _showFavorites = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
    Provider.of<MovieListViewModel>(context, listen: false).fetchMovies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieListVM = Provider.of<MovieListViewModel>(context);
    final favoriteVM = Provider.of<FavoriteViewModel>(context);

    final bool isOffline = movieListVM.isOffline;

    // final movies =
    //     movieListVM.isOffline
    //         ? movieListVM.movies
    //             .where((movie) => favoriteVM.isFavorite(movie.id))
    //             .toList()
    //         : favoriteVM.showFavoritesOnly
    //         ? movieListVM.movies
    //             .where((movie) => favoriteVM.isFavorite(movie.id))
    //             .toList()
    //         : movieListVM.movies;

    final List<Movie> movies =
        _showFavorites
            ? movieListVM.movies
                .where((movie) => favoriteVM.favoriteMovies.contains(movie.id))
                .where(
                  (movie) => movie.title.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ),
                )
                .toList()
            : movieListVM.movies.where((movie) {
              return movie.title.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
            }).toList();

    print("Movie List Screen Loaded");
    print("isOffline: ${movieListVM.isOffline}");
    print("Total Movies: ${movieListVM.movies.length}");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search Movies...",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white),
                )
                : Text("Movies", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  _searchQuery = "";
                }
                _isSearching = !_isSearching;
              });
            },
            icon: Icon(_isSearching ? Icons.close : Icons.search),
          ),

          IconButton(
            onPressed: () {
              setState(() {
                _showFavorites = !_showFavorites;
              });
            },
            icon: Icon(_showFavorites ? Icons.list : Icons.favorite),
          ),
        ],
      ),
      body:
          isOffline && !_showFavorites
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No Internet. Showing favorite movies.",
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: movieListVM.fetchMovies,
                      child: Text("Retry"),
                    ),
                  ],
                ),
              )
              : movies.isEmpty
              ? Center(
                child: Text(
                  _showFavorites ? "No favorite movies" : "No movies found",
                  style: TextStyle(color: Colors.white70),
                ),
              )
              : GridView.builder(
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: movies.length,
                itemBuilder: (ctx, index) {
                  return MovieCard(movie: movies[index]);
                },
              ),
    );
  }
}
