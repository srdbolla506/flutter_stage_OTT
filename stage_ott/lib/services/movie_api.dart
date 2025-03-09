import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/movie.dart';

class MovieApi {
  static final String apiKey =
      dotenv.env['TMDB_API_KEY'] ?? ''; //"71babfa32fbfec96b843ae587e926dff";
  static const String baseUrl = "https://api.themoviedb.org/3/movie/popular";

  // fetches movies dynamically from TMDB
  static Future<List<Movie>> getMovies() async {
    final url = "$baseUrl?api_key=$apiKey";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Movie> movies =
            (data['results'] as List)
                .map((json) => Movie.fromJson(json))
                .toList();
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
