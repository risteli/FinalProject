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

  @override
  Widget build(BuildContext context) {
    bool doubleRail = MediaQuery.of(context).size.width.toInt() >= 1000;
    final navigatorStateKey = GlobalKey<NavigatorState>();

    return Scaffold(
      body: Row(
        children: [
          if (doubleRail)
            AppNavigationRail(
              selectedIndex: 0,
              backgroundColor: _backgroundColor,
              onDestinationSelected: (index) {
                setState(() {
                  log('selecting navigation $index');
                });
              },
              onCreateButtonPressed: () =>
                  navigatorStateKey.currentState!.pushNamed('/create-task'),
            ),
          Expanded(
            child: Container(
              // this should be replaced by navigation!
              color: _backgroundColor,
              child: GoalsAsyncLoader(
                child: GoalsPanel(
                  navigationStateKey: navigatorStateKey,
                ),
              ),
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
              selectedIndex: 0,
              onDestinationSelected: (index) {
                setState(() {
                  log('selecting navigation $index');
                });
              },
            ),
    );
  }
}
