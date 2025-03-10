import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/movie.dart';
import 'package:dio/dio.dart';

class MovieApi {
  static final String apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
  static const String baseUrl = "https://api.themoviedb.org/3";
  static final Dio dio = Dio(); // Persistent Connection
  static Map<int, String> _genreMap = {};

  //fetches movie genres dynamically from TMDB
  static Future<void> fetchGenres() async {
    final url = "$baseUrl/genre/movie/list?api_key=$apiKey";
    print(url);
    try {
      final response = await dio.get(url);
      print(response);

      if (response.statusCode == 200) {
        final data = response.data;

        _genreMap = {
          for (var genre in data['genres']) genre['id']: genre['name'],
        };
      } else {
        throw Exception("Failed to load genres: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching genres: $e");
    }
  }

  static Map<int, String> getGenres() => _genreMap;

  // fetches movies dynamically from TMDB
  static Future<List<Movie>> getMovies() async {
    final url = "$baseUrl/movie/popular?api_key=$apiKey";
    print(url);
    try {
      final response = await dio.get(url);
      print(response);
      if (response.statusCode == 200) {
        final data = response.data;
        List<Movie> movies =
            (data['results'] as List)
                .map((json) => Movie.fromJson(json))
                .toList();
        print("success fetching movies");
        print(movies.length);
        return movies;
      } else {
        throw Exception(
          "Failed to load movies. Status : ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Error fetching movies: $e");
      return [];
    }
  }

  static Future<List<String>> fetchMovieTrailers(int movieId) async {
    final url = "$baseUrl/movie/$movieId/videos?api_key=$apiKey";
    final response = await dio.get(url);

    if (response.statusCode == 200) {
      final jsonData = response.data;
      final videos = jsonData["results"] as List;

      // Extract only Youtube trailers
      return videos
          .where(
            (video) => video["site"] == "YouTube" && video["type"] == "Trailer",
          )
          .map<String>((video) => video["key"]) // Extract Youtube video Id
          .toList();
    } else {
      return [];
    }
  }
}

// import '../models/movie.dart';

// class MovieApi {
//   static Future<List<Movie>> getMovies() async {
//     await Future.delayed(Duration(seconds: 2)); // simulating network delay

//     return [
//       Movie(
//         id: 1,
//         title: "Inception",
//         imageUrl:
//             "https://www.google.com/url?sa=i&url=https%3A%2F%2Fencrypted-tbn0.gstatic.com%2Fimages%3Fq%3Dtbn%3AANd9GcT9oW0XQlu1lo1G_49M-YwGzKR6rUg-CtflZj07HfbT8d2GwKWg&psig=AOvVaw0MQPRLsSU8kZrG3lqdyR-j&ust=1741555606174000&source=images&cd=vfe&opi=89978449&ved=0CBAQjRxqFwoTCJiXjqy2-4sDFQAAAAAdAAAAABAE",
//         bannerUrl:
//             "https://www.reddit.com/r/movies/comments/2hti5m/beautiful_new_interstellar_banner/#lightbox",
//         synopsis: "A mind-bending thriller",
//       ),
//       Movie(
//         id: 2,
//         title: "Interstellar",
//         imageUrl:
//             "https://www.google.com/url?sa=i&url=https%3A%2F%2Fencrypted-tbn0.gstatic.com%2Fimages%3Fq%3Dtbn%3AANd9GcT9oW0XQlu1lo1G_49M-YwGzKR6rUg-CtflZj07HfbT8d2GwKWg&psig=AOvVaw0MQPRLsSU8kZrG3lqdyR-j&ust=1741555606174000&source=images&cd=vfe&opi=89978449&ved=0CBAQjRxqFwoTCJiXjqy2-4sDFQAAAAAdAAAAABAE",
//         bannerUrl:
//             "https://www.reddit.com/r/movies/comments/2hti5m/beautiful_new_interstellar_banner/#lightbox",
//         synopsis: "A journey through space and time.",
//       ),
//     ];
//   }
// }
