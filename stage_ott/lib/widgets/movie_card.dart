import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';
import '../viewmodels/favorite_viewmodel.dart';
import '../views/movie_detail_screen.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    final favoriteVM = Provider.of<FavoriteViewModel>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => MovieDetailScreen(movie: movie)),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: movie.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget:
                  (context, url, error) => Icon(Icons.error, color: Colors.red),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    movie.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Consumer<FavoriteViewModel>(
                    builder: (context, favoriteVM, _) {
                      return IconButton(
                        icon: Icon(
                          favoriteVM.isFavorite(movie.id)
                              ? Icons.favorite
                              : Icons.favorite_border,

                          color:
                              favoriteVM.isFavorite(movie.id)
                                  ? Colors.red
                                  : null,
                        ),

                        onPressed: () {
                          favoriteVM.toggleFavorite(movie.id);
                        },
                      );
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
