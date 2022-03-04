import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movie_app/utils/text.dart';
import 'package:movie_app/widgets/toprated.dart';
import 'package:movie_app/widgets/trending.dart';
import 'package:movie_app/widgets/tv.dart';
import 'package:tmdb_api/tmdb_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List trendingMovies = [];
  List topRatedMovies = [];
  List tv = [];

  final String apikey = '1f1ae7de91409c4d2d378c8fc8c0109b';
  final readAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZjFhZTdkZTkxNDA5YzRkMmQzNzhjOGZjOGMwMTA5YiIsInN1YiI6IjYyMjExYzY5NmY0M2VjMDAxY2IzMDZhMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.LHH9nWldXuKm5og0TBqHOKdDRPPW6pE8j9ppQL_4_B0';

  @override
  void initState() {
    super.initState();
    loadmovies();
  }

  loadmovies() async {
    TMDB tmdbwithcustomlogs = TMDB(
      ApiKeys(apikey, readAccessToken),
      logConfig: const ConfigLogger(
        showErrorLogs: true,
        showLogs: true,
      ),
    );

    Map trendingresult = await tmdbwithcustomlogs.v3.trending.getTrending();
    Map topratedresult = await tmdbwithcustomlogs.v3.movies.getTopRated();
    Map tvresult = await tmdbwithcustomlogs.v3.tv.getPopular();
    print(trendingresult);
    setState(
      () {
        trendingMovies = trendingresult['results'];
        topRatedMovies = topratedresult['results'];
        tv = tvresult['results'];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const CustomText(
          text: 'The Movie App ',
          size: 20,
        ),
      ),
      body: ListView(
        children: [
          TV(
            tv: tv,
          ),
          TopRated(
            toprated: topRatedMovies,
          ),
          TrendingMovies(
            trending: trendingMovies,
          ),
        ],
      ),
    );
  }
}
