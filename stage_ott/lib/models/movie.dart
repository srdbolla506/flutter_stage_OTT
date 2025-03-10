import 'package:stage_ott/services/movie_api.dart';

class Movie {
  final int id;
  final String title;
  final String imageUrl;
  final String bannerUrl;
  final String synopsis;
  final String genres;
  final String releaseDate;
  final double voteAverage;
  bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.bannerUrl,
    required this.synopsis,
    required this.genres,
    required this.releaseDate,
    required this.voteAverage,
    this.isFavorite = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final genreIds = List<int>.from(json['genre_ids'] ?? []);

    String genreNames = genreIds
        .map((id) => MovieApi.getGenres()[id] ?? "Unknown") // Map Ids to names
        .join(", ");

    return Movie(
      id: json['id'],
      title: json['title'] ?? "Unknown title",
      imageUrl:
          json['poster_path'] != null
              ? "https://image.tmdb.org/t/p/w500${json['poster_path']}"
              : "https://via.placeholder.com/500", // Fallback image
      bannerUrl:
          json['backdrop_path'] != null
              ? "https://image.tmdb.org/t/p/w500${json['backdrop_path']}"
              : "https://via.placeholder.com/500", // Fallback banner
      synopsis: json['overview'] ?? "No synopsis available",
      genres: genreNames,
      releaseDate: json['release_date'] ?? "Unknown",
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
    );
  }

  // Converts Movie object into a Map for SQlite stoarge
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'bannerUrl': bannerUrl,
      'synopsis': synopsis,
      'genres': genres,
      'releaseDate': releaseDate,
      'voteAverage': voteAverage,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  // Converts a Map from Sqlite into a Movie Object
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      bannerUrl: map['bannerUrl'],
      synopsis: map['synopsis'],
      genres: map['genres'],
      releaseDate: map['releaseDate'],
      voteAverage: (map['voteAverage'] as num).toDouble(),
      isFavorite: (map['isFavorite'] == 1),
    );
  }
}
