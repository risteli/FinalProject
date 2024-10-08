import 'dart:developer';

import 'package:final_project/panels/runner/task_runner.dart';
import 'package:final_project/panels/runner/browser.dart';
import 'package:final_project/panels/runner/tasks.dart';
import 'package:final_project/routes.dart';
import 'package:flutter/material.dart';
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
    return Consumer<StorageRoot>(
      builder: (context, storageRoot, _) {
        routeToRunner(task) => widget.navigationStateKey.currentState!
            .pushNamed(routeRunTask, arguments: task).then((_) => setState(() => {}));

        return AppPanels(
          singleLayout: GoalsRunnerBrowser(
            storageRoot: storageRoot,
            selectedIndex: selectedIndex,
            onSelected: (context, newSelectedIndex) {
              setState(() {
                selectedIndex = newSelectedIndex;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return GoalsRunnerTasks(
                      goal: storageRoot.goals[newSelectedIndex!],
                      singlePanel: true,
                      onSelected: routeToRunner,
                    );
                  },
                ),
              ).then((_) => setState(() => {}));
            },
          ),
          doubleLayoutLeft: GoalsRunnerBrowser(
            storageRoot: storageRoot,
            selectedIndex: selectedIndex,
            onSelected: (context, newSelectedIndex) {
              setState(() {
                selectedIndex = newSelectedIndex;
              });
            },
          ),
          doubleLayoutRight: GoalsRunnerTasks(
            goal: storageRoot.goals[selectedIndex!],
            singlePanel: false,
            onSelected: routeToRunner,
          ),
        );
      },
    );
  }
}
