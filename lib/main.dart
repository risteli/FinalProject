import 'dart:developer';

import 'package:final_project/repository/database.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppDatabase.instance.then((db) {
    log('starting MainApp');

    runApp(Provider<AppDatabase>(
      create: (_) => db,
      child: MainApp(),
    ));
  });
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      home: App(),
    );
  }
}
