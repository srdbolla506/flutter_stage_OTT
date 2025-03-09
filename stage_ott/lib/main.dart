import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'views/movie_list_screen.dart';
import 'viewmodels/movie_list_viewmodel.dart';
import 'viewmodels/favorite_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // for async initialization
  await dotenv.load(fileName: "assets/.env"); // load .env file

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieListViewModel()),
        ChangeNotifierProvider(create: (_) => FavoriteViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies App',
      debugShowCheckedModeBanner: false,
      home: MovieListScreen(),
      // theme: ThemeData(
      // This is the theme of your application.
      //
      // TRY THIS: Try running your application with "flutter run". You'll see
      // the application has a purple toolbar. Then, without quitting the app,
      // try changing the seedColor in the colorScheme below to Colors.green
      // and then invoke "hot reload" (save your changes or press the "hot
      // reload" button in a Flutter-supported IDE, or press "r" if you used
      // the command line to start the app).
      //
      // Notice that the counter didn't reset back to zero; the application
      // state is not lost during the reload. To reset the state, use hot
      // restart instead.
      //
      // This works for code too, not just values: Most code changes can be
      // tested with just a hot reload.
      // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
