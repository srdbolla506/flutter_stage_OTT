import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/movie.dart';
import '../viewmodels/favorite_viewmodel.dart';
import '../viewmodels/movie_detail_viewmodel.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  MovieDetailScreen({required this.movie});

  @override
  MovieDetailScreenState createState() => MovieDetailScreenState();
}

class MovieDetailScreenState extends State<MovieDetailScreen> {
  late MovieDetailViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<MovieDetailViewModel>(context, listen: false);
    viewModel.loadTrailers(widget.movie.id); // Load trailers when screen opens
  }

  @override
  Widget build(BuildContext context) {
    final favoriteVM = Provider.of<FavoriteViewModel>(context);
    bool isFav = favoriteVM.isFavorite(widget.movie.id);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.movie.bannerUrl,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget:
                  (context, url, error) => Icon(Icons.error, color: Colors.red),
            ),
          ),

          // Gradient Overlay for readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),

          // Main Content (Title, Poster, Details)
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button and Favorite icon
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          favoriteVM.toggleFavorite(widget.movie.id);
                        },
                      ),
                    ],
                  ),
                ),

                // Movie Poster and details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Movie Poster
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: widget.movie.imageUrl,
                            width: screenWidth * 0.35,
                            height: screenWidth * 0.5,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12),

                        // Release Date and ratings
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.movie.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Release Date: ${widget.movie.releaseDate}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Rating: ${widget.movie.voteAverage}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.yellowAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Movie Synopsis
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Overview",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.movie.synopsis,
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        SizedBox(height: 16),

                        // Trailers Section
                        Text(
                          "Trailers",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        SizedBox(height: 8),

                        // Trailer List
                        Consumer<MovieDetailViewModel>(
                          builder: (comntext, viewModel, child) {
                            if (viewModel.trailers.isEmpty) {
                              return Center(
                                child: Text(
                                  "No trailers available",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              );
                            }

                            return Container(
                              height: 180,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: viewModel.trailers.length,
                                itemBuilder: (context, index) {
                                  String videoId = viewModel.trailers[index];
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              backgroundColor: Colors.black,
                                              content: YoutubePlayer(
                                                controller:
                                                    YoutubePlayerController(
                                                      initialVideoId: videoId,
                                                      flags: YoutubePlayerFlags(
                                                        autoPlay: true,
                                                      ),
                                                    ),
                                              ),
                                            ),
                                      );
                                    },
                                    child: Container(
                                      width: 150,
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white10,
                                      ),
                                      child: Icon(
                                        Icons.play_circle_outline,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // appBar: AppBar(title: Text(movie.title)),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       Image.network(
      //         movie.bannerUrl,
      //         height: 200,
      //         width: double.infinity,
      //         fit: BoxFit.cover,
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text(
      //               movie.title,
      //               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      //             ),
      //             SizedBox(height: 20),
      //             IconButton(
      //               icon: Icon(
      //                 favoriteVM.isFavorite(movie.id)
      //                     ? Icons.favorite
      //                     : Icons.favorite_border,
      //                 size: 30,
      //               ),
      //               onPressed: () {
      //                 favoriteVM.toggleFavorite(movie.id);
      //                 Navigator.pop(context);
      //               },
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
