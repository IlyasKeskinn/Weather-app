import 'package:flutter/material.dart';
import 'package:weather/screens/home_screens.dart';
import 'package:weather/screens/loading_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData.dark(),
      home: const LoadingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
