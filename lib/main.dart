import 'dart:developer';

import 'package:final_project/database.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppDatabase.instance.then((db) {
    log('starting MainApp');

    runApp(MainApp(db: db));
  });
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
    required this.db,
  });

  final AppDatabase db;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      home: App(),
    );
  }
}
