import 'dart:developer';

import 'package:final_project/panels/goals/runner.dart';
import 'package:final_project/panels/goals/runner_goals.dart';
import 'package:final_project/panels/goals/runner_tasks.dart';
import 'package:final_project/routes.dart';
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
    return Navigator(
      key: navigationStateKey,
      onGenerateRoute: (RouteSettings settings) {
        final page = switch (settings.name) {
          routeShowRunnables =>
            _RunnableGoals(navigationStateKey: navigationStateKey),
          routeRunTask =>
            RunTask(task: settings.arguments as Task),
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
    required this.navigationStateKey,
  });

  final GlobalKey<NavigatorState> navigationStateKey;

  @override
  State<_RunnableGoals> createState() => _RunnableGoalsState();
}

class _RunnableGoalsState extends State<_RunnableGoals> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    log('building RunnableGoalsState');

    return Consumer<StorageRoot>(
      builder: (context, storageRoot, _) {
        routeToRunner(task) => widget.navigationStateKey.currentState!
            .pushNamed(routeRunTask, arguments: task);

        return AppPanels(
          singleLayout: GoalsRunnerGoals(
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
                  builder: (_) {
                    return GoalsRunnerTasks(
                      goal: storageRoot.goals[newSelectedIndex!],
                      onSelected: routeToRunner,
                    );
                  },
                ),
              );
            },
          ),
          doubleLayoutLeft: GoalsRunnerGoals(
            storageRoot: storageRoot,
            selectedIndex: selectedIndex,
            onSelected: (context, newSelectedIndex) {
              setState(() {
                selectedIndex = newSelectedIndex;
                log('selected $selectedIndex');
              });
            },
          ),
          doubleLayoutRight: GoalsRunnerTasks(
            goal: storageRoot.goals[selectedIndex!],
            onSelected: routeToRunner,
          ),
        );
      },
    );
  }
}
