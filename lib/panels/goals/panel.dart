import 'dart:developer';

import 'package:final_project/panels/goals/wizard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../models/roots.dart';
import '../../routes.dart';
import '../../widgets/app_panels.dart';
import 'browser.dart';

class GoalsPanel extends StatelessWidget {
  const GoalsPanel({
    super.key,
    required this.navigationStateKey,
  });

  final GlobalKey<NavigatorState> navigationStateKey;

  @override
  Widget build(BuildContext context) {
    log('navigation key ${navigationStateKey}');
    return Navigator(
      key: navigationStateKey,
      onGenerateRoute: (RouteSettings settings) {
        log('route changed ${settings.name}');

        final page = switch (settings.name) {
          routeEditGoals => _EditGoals(),
          routeCreateGoal => _CreateGoal(),
          _ => throw StateError('Invalid route: ${settings.name}'),
        };

        return MaterialPageRoute(
          builder: (_) => page,
          settings: settings,
        );
      },
    );
  }
}

class _EditGoals extends StatefulWidget {
  @override
  State<_EditGoals> createState() => _EditGoalsState();
}

class _EditGoalsState extends State<_EditGoals> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    log('building _EditGoalsState ${selectedIndex}');

    return Consumer<StorageRoot>(
      builder: (context, storageRoot, _) => AppPanels(
        singleLayout: GoalBrowserView(
          storageRoot: storageRoot,
          selectedIndex: selectedIndex,
          onSelected: (context, newSelectedIndex) {
            setState(() {
              selectedIndex = newSelectedIndex;
              log('selected $selectedIndex');
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GoalWizard(
                  storageRoot: storageRoot,
                  goalIndex: selectedIndex!,
                  onDone: () => Navigator.pop(context),
                ),
              ),
            );
          },
        ),
        doubleLayoutLeft: GoalBrowserView(
          storageRoot: storageRoot,
          selectedIndex: selectedIndex,
          onSelected: (context, newSelectedIndex) {
            setState(() {
              selectedIndex = newSelectedIndex;
              log('selected $selectedIndex');
            });
          },
        ),
        doubleLayoutRight: selectedIndex == null
            ? const Card()
            : GoalWizard(
                storageRoot: storageRoot,
                goalIndex: selectedIndex!,
                onDone: () => setState(() => selectedIndex = null),
              ),
      ),
    );
  }
}

class _CreateGoal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StorageRoot>(
      builder: (context, storageRoot, _) => AppPanels(
        singleLayout: GoalWizard(
          storageRoot: storageRoot,
          onDone: () => Navigator.pop(context),
        ),
        doubleLayoutLeft: GoalBrowserView(
          storageRoot: storageRoot,
          onSelected: (context, _) {
            log('ignoring selection');
          },
        ),
        doubleLayoutRight: GoalWizard(
          storageRoot: storageRoot,
          onDone: () => const Card(),
        ),
      ),
    );
  }
}
