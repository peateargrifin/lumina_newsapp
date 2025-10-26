import 'package:flutter/material.dart';
import 'package:news/pages/splash.dart';

void main() {
  runApp(const MyApp());
}

//news 46094d62da3c46e5a39393b871a0a903

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: splash(),

    );
  }
}
