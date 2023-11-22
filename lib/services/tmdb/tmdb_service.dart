// import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

class TmdbService {
  Future<List<Movie>> getTrendingMovies() async {
    String url = getURL('/trending/movie/day');
    try {
      var res = await http.get(Uri.parse(url), headers: headers);
      String resBody = utf8.decode(res.bodyBytes);
      print({'status': res.statusCode, 'endpoint': 'getTrendingMovies'});

      return parseMovies(resBody);
    } catch (error) {
      print("error in trending");
      return Future.error(error);
    }
  }

  Future<Movie> requestMovie(int id) async {
    String url = getURL('/movie/$id');
    try {
      var res = await http.get(Uri.parse(url), headers: headers);
      String responseBody = utf8.decode(res.bodyBytes);
      var json = jsonDecode(responseBody);
      final movie = Movie.fromJson(json);
      print({'status': res.statusCode, 'endpoint': 'requestMovie'});
      return movie;
    } catch (error) {
      print("error in req movie");
      return Future.error(error);
    }
  }

  Future<List<Actor>> requestCredits(int id) async {
    String url = getURL("/movie/$id/credits");
    try {
      var response = await http.get(Uri.parse(url), headers: headers);
      String responseBody = utf8.decode(response.bodyBytes);
      var json = jsonDecode(responseBody);
      var results = json['cast'];
      var actors = (results as List).map((actor) {
        return Actor.fromJson(actor);
      });
      return actors.toList().sublist(0, 10);
    } catch (error) {
      print("error in credits");
      return Future.error(error);
    }
  }

  Future<List<Movie>> requestRecommendations(int id) async {
    String url = getURL('/movie/$id/recommendations');
    try {
      var response = await http.get(Uri.parse(url), headers: headers);
      String resBody = utf8.decode(response.bodyBytes);
      print({
        'status': response.statusCode,
        'endpoint': 'requestRecommendations'
      });
      return parseMovies(resBody);
    } catch (error) {
      print("error in recommendations");
      return Future.error(error);
    }
  }

  Future<List<Movie>> requestSimilar(int id) async {
    String url = getURL("/movie/$id/similar");
    try {
      var response = await http.get(Uri.parse(url), headers: headers);
      String resBody = utf8.decode(response.bodyBytes);
      print({'status': response.statusCode, 'endpoint': 'requestSimilar'});
      return parseMovies(resBody);
    } catch (error) {
      return Future.error("Can not get Movie List data");
    }
  }
}
