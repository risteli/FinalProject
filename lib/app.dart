import 'dart:developer';

import 'package:final_project/panels/achiev/panel.dart';
import 'package:final_project/panels/goals/panel.dart';
import 'package:final_project/repository/loader.dart';
import 'package:final_project/panels/runner/panel.dart';
import 'package:final_project/routes.dart';
import 'package:final_project/top.dart';
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

  final topController = TopController();

  late final List<Destination> destinations = <Destination>[
    Destination(
      icon: Icons.sports_score_outlined,
      label: 'Goals',
      widget: GoalsPanel(
        topController: topController,
      ),
      hasAddAction: true,
    ),
    Destination(
      icon: Icons.schedule_outlined,
      label: 'Run',
      widget: RunnerPanel(
        navigationStateKey: runnerNavigatorStateKey,
      ),
    ),
    const Destination(
      icon: Icons.emoji_events_outlined,
      label: 'Achievements',
      widget: AchievPanel(),
    ),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final doubleRail = size.width.toInt() >= 1000 && size.height.toInt() >= 500;

    return StorageAsyncLoader(
      child: Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              if (doubleRail)
                AppNavigationRail(
                  selectedIndex: currentIndex,
                  backgroundColor: _backgroundColor,
                  destinations: destinations,
                  onDestinationSelected: (index) =>
                      setState(() => currentIndex = index),
                  onCreateButtonPressed: () => topController.create(),
                ),
              Expanded(
                child: Container(
                  color: _backgroundColor,
                  child:
                      (0 <= currentIndex && currentIndex < destinations.length)
                          ? destinations[currentIndex].widget
                          : const Text('invalid page index'),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: doubleRail || !destinations[currentIndex].hasAddAction
            ? null
            : AppFloatingActionButton(
                onPressed: () => topController.create(),
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
      ),
    );
  }
}
