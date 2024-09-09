import 'dart:developer';

import 'package:final_project/repository/database.dart';
import 'package:final_project/repository/storage.dart';
import 'package:flutter/material.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppDatabaseInit.init(resetDatabase: true).then((db) {
    Storage();
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorSchemeSeed: Colors.pink.shade300,
      ),
      darkTheme: ThemeData.dark(),
      home: const App(),
    );
  }
}
