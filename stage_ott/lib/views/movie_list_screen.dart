import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../viewmodels/movie_list_viewmodel.dart';
import '../viewmodels/favorite_viewmodel.dart';
import '../views/movie_detail_screen.dart';
import '../widgets/movie_card.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<MovieListViewModel>(context, listen: false).fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    final movieListVM = Provider.of<MovieListViewModel>(context);
    final favoriteVM = Provider.of<FavoriteViewModel>(context);

    final movies =
        movieListVM.isOffline
            ? movieListVM.movies
                .where((movie) => favoriteVM.isFavorite(movie.id))
                .toList()
            : favoriteVM.showFavoritesOnly
            ? movieListVM.movies
                .where((movie) => favoriteVM.isFavorite(movie.id))
                .toList()
            : movieListVM.movies;

    print("🚀 Movie List Screen Loaded");
    print("➡️ isOffline: ${movieListVM.isOffline}");
    print("➡️ Total Movies: ${movieListVM.movies.length}");

    return Scaffold(
      appBar: AppBar(
        title: Text("Movies"),
        actions: [
          IconButton(
            onPressed: favoriteVM.toggleShowFavorites,
            icon: Icon(
              favoriteVM.showFavoritesOnly ? Icons.list : Icons.favorite,
            ),
          ),
        ],
      ),
      body:
          movieListVM.isOffline
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("No Internet. Showing favorite movies."),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: movieListVM.fetchMovies,
                      child: Text("Retry"),
                    ),
                  ],
                ),
              )
              : movieListVM.movies.isEmpty
              ? Center(child: Text("No movies found"))
              : GridView.builder(
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: movieListVM.movies.length,
                itemBuilder: (ctx, index) {
                  return MovieCard(movie: movieListVM.movies[index]);
                },
              ),
    );
  }
}
