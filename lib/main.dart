import 'package:flutter/material.dart';
import 'package:wordle/home_page.dart';

void main() {
  runApp(WordleApp());
}

class WordleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordle',
      theme: ThemeData.dark(),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
