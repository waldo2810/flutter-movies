class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final double voteAvg;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAvg,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: "https://image.tmdb.org/t/p/w500${json['poster_path']}",
      backdropPath: "https://image.tmdb.org/t/p/w500${json['backdrop_path']}",
      releaseDate: json['release_date'],
      voteAvg: json['vote_average'],
    );
  }
}
