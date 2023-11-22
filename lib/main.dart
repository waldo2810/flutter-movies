import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movies/views/details.dart';
import 'app.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const App(),
        '/detail': (context) => const DetailScreen(),
      },
    );
  }
}
