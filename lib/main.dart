import 'package:flutter/material.dart';
import 'package:flutter_draggable/home_1.dart';
import 'package:flutter_draggable/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      //home: const HomePage(),
      home: const Home1(),
    );
  }
}
