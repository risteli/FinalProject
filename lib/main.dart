import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';

import 'repository/goals.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({
    super.key,
  });

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final GoalsRepo goalsRepo = GoalsRepo();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      home: ChangeNotifierProvider(
        create: (_) => goalsRepo.readAll(),
        child: App(),
      ),
    );
  }
}
