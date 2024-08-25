import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/roots.dart';
import '../../repository/goals.dart';

class GoalsAsyncLoader extends StatelessWidget {
  const GoalsAsyncLoader({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GoalsRepo.instance.load(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            log('error while loading data on GoalsAsyncLoader: ${snapshot.error}');
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Error while loading the data.'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              ),
            );
          }

          return ChangeNotifierProvider<GoalsModel>.value(
            value: GoalsRepo.instance.goals,
            child: child,
          );
        });
  }
}
