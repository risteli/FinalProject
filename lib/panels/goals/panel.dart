import 'dart:developer';

import 'package:final_project/panels/goals/wizard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../models/roots.dart';
import '../../widgets/app_panels.dart';
import 'browser.dart';

const routeEditGoals = '/';
const routeCreateGoal = '/create-goal';

class GoalsPanel extends StatelessWidget {
  const GoalsPanel({
    super.key,
    required this.navigationStateKey,
  });

  final GlobalKey<NavigatorState> navigationStateKey;

  @override
  Widget build(BuildContext context) {
    final goalsModel = Provider.of<GoalsModel>(context);

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

    return Consumer<GoalsModel>(
      builder: (context, goalsModel, _) => AppPanels(
        singleLayout: GoalBrowserView(
          goalsModel: goalsModel,
          selectedIndex: selectedIndex,
          onSelected: (context, newSelectedIndex) {
            setState(() {
              selectedIndex = newSelectedIndex;
              log('selected $selectedIndex');
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    GoalWizard(goal: goalsModel.items[selectedIndex!]),
              ),
            );
          },
        ),
        doubleLayoutLeft: GoalBrowserView(
          goalsModel: goalsModel,
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
                goal: goalsModel.items[selectedIndex!],
              ),
      ),
    );
  }
}

class _CreateGoal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GoalsModel>(
      builder: (context, goalsModel, _) => AppPanels(
        singleLayout: GoalWizard(goal: Goal()),
        doubleLayoutLeft: GoalBrowserView(
          goalsModel: goalsModel,
          onSelected: (context, _) {
            log('ignoring selection');
          },
        ),
        doubleLayoutRight: GoalWizard(goal: Goal()),
      ),
    );
  }
}
