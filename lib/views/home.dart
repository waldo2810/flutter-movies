import 'package:flutter/material.dart';
import 'package:movies/widgets/movie_tile.dart';
import 'package:movies/services/tmdb/tmdb_service.dart';
import 'package:movies/types/movie.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _movieService = TmdbService();

  @override
  void initState() {
    super.initState();
    loadTrending();
  }

  Future<List<Movie>> loadTrending() async {
    return _movieService.getTrendingMovies();
  }

  Widget _movieList(movies) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (BuildContext context,int index) {
        return MovieTile(movies[index]);
      },
      padding: const EdgeInsets.all(2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        child: FutureBuilder(
          future: loadTrending(),
          builder: (context,snapshot){
            if (!snapshot.hasData){
              return const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey)
                  )
                ]
              );
            } else {
              final movies = snapshot.data;
              return _movieList(movies);
            }
          }
        )
      )
    );
  }
}
