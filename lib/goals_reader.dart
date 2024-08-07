import 'dart:developer';

import 'package:final_project/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/collections.dart';
import 'repository/goals.dart';

import 'widgets/app_list_detail.dart'; // Add import
import 'widgets/goal_list_view.dart';
import 'widgets/task_list_view.dart'; // Add import

class GoalsReader extends StatelessWidget {
  const GoalsReader({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GoalsModel>(
        future: GoalsRepo(Provider.of<AppDatabase>(context)).readAll(),
        builder: (BuildContext context, AsyncSnapshot<GoalsModel> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                children: <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasData) {
            return ChangeNotifierProvider(
              create: (_) => snapshot.data!,
              child: child,
            );
          }

          return const Center(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.warning_outlined,
                  color: Colors.orange,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('No data'),
                ),
              ],
            ),
          );
        });
  }
}
