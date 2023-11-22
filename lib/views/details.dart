import 'package:flutter/material.dart';
import 'dart:async';
import 'package:movies/types/actor.dart';
import 'package:movies/types/movie.dart';
import 'package:movies/services/tmdb/tmdb_service.dart';
import 'package:movies/widgets/section.dart';
import 'package:movies/widgets/actor_tile.dart';
import 'package:movies/widgets/content_tile.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);
  @override
  State createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _service = TmdbService();
  final ScrollController _sliverScrollController = ScrollController();

  Widget _actorList(actors) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: actors.length,
          itemBuilder: (BuildContext context, int index) {
            return ActorTile(actors[index]);
          },
          padding: const EdgeInsets.all(5),
        ));
  }

  Widget _contentList(movies) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          return ContentTile(movies[index]);
        });
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
      body: CustomScrollView(
        controller: _sliverScrollController,
        slivers: [
          SliverAppBar(
              pinned: true,
              stretch: true,
              collapsedHeight: 60,
              expandedHeight: 200,
              flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                return FlexibleSpaceBar(
                    title: Text(arguments['title'],
                        style: const TextStyle(fontSize: 16, shadows: <Shadow>[
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(2.5, 2.5),
                          )
                        ])),
                    background: Image.network(arguments['backdropPath'],
                        fit: BoxFit.cover));
              })),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return FutureBuilder(
              future: Future.wait([
                _service.requestMovie(arguments['id']),
                _service.requestCredits(arguments['id']),
                _service.requestSimilar(arguments['id']),
                _service.requestRecommendations(arguments['id']),
              ]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (!snapshot.hasData) {
                  return const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blueGrey))
                          ]));
                } else {
                  final movie = snapshot.data?[0] as Movie;
                  final actors = snapshot.data?[1] as List<Actor>;
                  final similarMovies = snapshot.data?[2] as List<Movie>;
                  final recommendations = snapshot.data?[3] as List<Movie>;

                  return Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: SizedBox(
                                height: 180,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: arguments['posterPath'])),
                              )),
                          Text(arguments['title'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.star, color: Colors.yellow),
                                Text(arguments['voteAvg'].toString())
                              ]),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 32, right: 32, bottom: 10),
                              child: Text(
                                movie.overview,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              )),
                          Container(
                            margin: const EdgeInsets.only(top: 16, bottom: 16),
                            padding: const EdgeInsets.only(top: 16),
                            child: Section(
                                'Casting',
                                SizedBox(
                                    height: 130, child: _actorList(actors))),
                          ),
                          if (similarMovies.isNotEmpty)
                            Container(
                                margin: const EdgeInsets.only(bottom: 32),
                                padding: const EdgeInsets.only(top: 16),
                                child: Section(
                                    "Similar Movies",
                                    SizedBox(
                                        height: 130,
                                        child: _contentList(similarMovies)))),
                          if (recommendations.isNotEmpty)
                            Container(
                                margin: const EdgeInsets.only(bottom: 64),
                                padding: const EdgeInsets.only(top: 16),
                                child: Section(
                                    "Recommendations",
                                    SizedBox(
                                        height: 130,
                                        child: _contentList(recommendations)))),
                        ],
                      ));
                }
              },
            );
          }, childCount: 1))
        ],
      ),
    );
  }
}
