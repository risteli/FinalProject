import 'dart:developer';

import 'package:final_project/panels/goals/panel.dart';
import 'package:final_project/panels/goals/loader.dart';
import 'package:flutter/material.dart';

import 'widgets/app_floating_action_button.dart';
import 'widgets/app_bottom_navigation_bar.dart';
import 'widgets/app_navigation_rail.dart';

class App extends StatefulWidget {
  const App({
    super.key,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);
  int currentIndex = 0;
  final navigatorStateKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    bool doubleRail = MediaQuery.of(context).size.width.toInt() >= 1000;

    return Scaffold(
      body: Row(
        children: [
          if (doubleRail)
            AppNavigationRail(
              selectedIndex: currentIndex,
              backgroundColor: _backgroundColor,
              onDestinationSelected: (index) =>
                  setState(() => currentIndex = index),
              onCreateButtonPressed: () =>
                  navigatorStateKey.currentState!.pushNamed('/create-task'),
            ),
          Expanded(
            child: Container(
              // this should be replaced by navigation!
              color: _backgroundColor,
              child: switch (currentIndex) {
                0 => GoalsAsyncLoader(
                    child: GoalsPanel(
                      navigationStateKey: navigatorStateKey,
                    ),
                  ),
                _ => Text('invalid page'),
              },
            ),
          ),
        ],
      ),
      floatingActionButton: doubleRail
          ? null
          : AppFloatingActionButton(
              onPressed: () =>
                  navigatorStateKey.currentState!.pushNamed('/create-task'),
              child: const Icon(Icons.add),
            ),
      bottomNavigationBar: doubleRail
          ? null
          : AppBottomNavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) =>
                  setState(() => currentIndex = index),
            ),
    );
  }
}
