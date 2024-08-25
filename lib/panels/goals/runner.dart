import 'dart:developer';

import 'package:final_project/panels/goals/runner_goals.dart';
import 'package:final_project/panels/goals/runner_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../models/roots.dart';
import '../../widgets/app_panels.dart';

class RunnerPanel extends StatelessWidget {
  const RunnerPanel({
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
          '/' => _RunnableGoals(),
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

class _RunnableGoals extends StatefulWidget {
  const _RunnableGoals({
    super.key,
  });

  @override
  State<_RunnableGoals> createState() => _RunnableGoalsState();
}

class _RunnableGoalsState extends State<_RunnableGoals> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    log('building RunnableGoalsState');

    return Consumer<GoalsModel>(
      builder: (context, goalsModel, _) => AppPanels(
        singleLayout: GoalsRunnerGoals(
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
                    GoalsRunnerTasks(goal: goalsModel.items[selectedIndex!]),
              ),
            );
          },
        ),
        doubleLayoutLeft: GoalsRunnerGoals(
          goalsModel: goalsModel,
          selectedIndex: selectedIndex,
          onSelected: (context, newSelectedIndex) {
            setState(() {
              selectedIndex = newSelectedIndex;
              log('selected $selectedIndex');
            });
          },
        ),
        doubleLayoutRight: GoalsRunnerTasks(
          goal: goalsModel.items[selectedIndex!],
        ),
      ),
    );
  }
}
