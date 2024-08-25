import 'dart:developer';

import 'package:final_project/panels/goals/panel.dart';
import 'package:final_project/panels/goals/loader.dart';
import 'package:final_project/panels/goals/runner.dart';
import 'package:flutter/material.dart';

import 'destinations.dart';
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

  final goalsNavigatorStateKey = GlobalKey<NavigatorState>();
  final runnerNavigatorStateKey = GlobalKey<NavigatorState>();

  late final List<Destination> destinations = <Destination>[
    Destination(
      icon: Icons.sports_score_outlined,
      label: 'Goals',
      widget: GoalsAsyncLoader(
        child: GoalsPanel(
          navigationStateKey: goalsNavigatorStateKey,
        ),
      ),
    ),
    Destination(
      icon: Icons.schedule_outlined,
      label: 'Run',
      widget: GoalsAsyncLoader(
        child: RunnerPanel(
          navigationStateKey: runnerNavigatorStateKey,
        ),
      ),
    ),
    const Destination(
      icon: Icons.emoji_events_outlined,
      label: 'Achievements',
      widget: Text('Achiev placeholder'),
    ),
//    Destination(icon: Icons.settings_outlined, label: 'Settings', widget: Text('Run placeholder'),),
  ];

  int currentIndex = 0;

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
              destinations: destinations,
              onDestinationSelected: (index) =>
                  setState(() => currentIndex = index),
              onCreateButtonPressed: () => goalsNavigatorStateKey.currentState!
                  .pushNamed(routeCreateGoal),
            ),
          Expanded(
            child: Container(
              // this should be replaced by navigation!
              color: _backgroundColor,
              child: (0 <= currentIndex && currentIndex < destinations.length)
                  ? destinations[currentIndex].widget
                  : const Text('invalid page index'),
            ),
          ),
        ],
      ),
      floatingActionButton: doubleRail
          ? null
          : AppFloatingActionButton(
              onPressed: () => goalsNavigatorStateKey.currentState!
                  .pushNamed(routeCreateGoal),
              child: const Icon(Icons.add),
            ),
      bottomNavigationBar: doubleRail
          ? null
          : AppBottomNavigationBar(
              selectedIndex: currentIndex,
              destinations: destinations,
              onDestinationSelected: (index) =>
                  setState(() => currentIndex = index),
            ),
    );
  }
}
