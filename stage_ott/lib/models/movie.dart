class Movie {
  final int id;
  final String title;
  final String imageUrl;
  final String bannerUrl;
  final String synopsis;

  Movie({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.bannerUrl,
    required this.synopsis,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? "No title",
      imageUrl:
          json['poster_path'] != null
              ? "https://image.tmdb.org/t/p/w500${json['poster_path']}"
              : "https://via.placeholder.com/500", // Fallback image
      bannerUrl:
          json['backdrop_path'] != null
              ? "https://image.tmdb.org/t/p/w500${json['backdrop_path']}"
              : "https://via.placeholder.com/500", // Fallback banner
      synopsis: json['overview'] ?? "No synopsis available",
    );
  }

  // Converts Movie object into a Map for SQlite stoarge
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'bannerurl': bannerUrl,
      'synopsis': synopsis,
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
    );
  }
}
