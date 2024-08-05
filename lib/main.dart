import 'package:flutter/material.dart';

import 'models/data.dart' as data;

import 'app.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      home: App(),
    );
  }
}
