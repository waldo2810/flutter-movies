import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:movies/types/movie.dart';
import 'package:movies/types/actor.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'dart:convert';

final apiKey = dotenv.env['API_KEY'];
final accessToken = dotenv.env['ACCESS_TOKEN'];
final Map<String, String> headers = {
  'Authorization': 'Bearer $accessToken',
  'accept': 'application/json'
};

List<Movie> parseMovies(String resBody) {
  final json = jsonDecode(resBody);
  final results = json['results'];
  return (results as List).map<Movie>((movie) {
    return Movie.fromJson(movie);
  }).toList();
}

List<Actor> parseActors(String resBody) {
  final json = jsonDecode(resBody);
  final results = json['cast'];
  var lol = (results as List)
      .map<Actor>((actor) {
        return Actor.fromJson(actor);
      })
      .toList()
      .sublist(0, 10);
  print(lol);
  return lol;
}

class TmdbService {
  Future<List<Movie>> getTrendingMovies() async {
    String url = getURL('/trending/movie/day');
    try {
      var res = await http.get(Uri.parse(url), headers: headers);
      String resBody = utf8.decode(res.bodyBytes);
      return parseMovies(resBody);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<Movie> requestMovie(int id) async {
    String url = getURL('/movie/$id');
    try {
      var res = await http.get(Uri.parse(url), headers: headers);
      Movie movie = jsonDecode(res.body);
      return movie;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<List<Actor>> requestCredits(int id) async {
    String url = getURL("/movie/$id/credits");
    try {
      var res = await http.get(Uri.parse(url), headers: headers);
      String resBody = utf8.decode(res.bodyBytes);
      return parseActors(resBody);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<List<Movie>> requestRecommendations(int id) async {
    String url = getURL('/movie/$id/recommendations');
    try {
      var response = await http.get(Uri.parse(url), headers: headers);
      String resBody = utf8.decode(response.bodyBytes);
      // return parseMovies(resBody);
      return [];
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<List<Movie>> requestSimilar(int id) async {
    String url = getURL("/movie/$id/similar");
    try {
      var response = await http.get(Uri.parse(url), headers: headers);
      String resBody = utf8.decode(response.bodyBytes);
      // return parseMovies(resBody);
      return [];
    } catch (error) {
      return Future.error("Can not get Movie List data");
    }
  }
}
