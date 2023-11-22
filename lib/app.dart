import 'package:flutter/material.dart';
import 'package:movies/views/home.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  State createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
      ),
      body: const Home(),
    );
  }
}
