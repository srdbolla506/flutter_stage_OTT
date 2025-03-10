import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';
import '../viewmodels/favorite_viewmodel.dart';
import '../views/movie_detail_screen.dart';
import '../viewmodels/movie_detail_viewmodel.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    final favoriteVM = Provider.of<FavoriteViewModel>(context, listen: false);
    bool isFav = favoriteVM.isFavorite(movie.id);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (ctx) => ChangeNotifierProvider(
                  create:
                      (_) =>
                          MovieDetailViewModel(movie: movie, isFavorite: isFav),
                  child: MovieDetailScreen(movie: movie),
                ),
          ),
        );
      },
      child: Card(
        color: Colors.white.withOpacity(0.1),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Expanded(
              child: CachedNetworkImage(
                imageUrl: movie.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) =>
                        Center(child: CircularProgressIndicator()),
                errorWidget:
                    (context, url, error) =>
                        Icon(Icons.error, color: Colors.red),
              ),
            ),

            Container(
              color: isFav ? Colors.red[300] : Colors.amber[500],
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          // softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          movie.genres,
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                          maxLines: 1,
                          // softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red[800] : Colors.black54,
                    ),
                    onPressed: () {
                      favoriteVM.toggleFavorite(movie.id);
                      movie.isFavorite = favoriteVM.isFavorite(movie.id);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
