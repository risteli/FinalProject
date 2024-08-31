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
          routeEditGoals => _EditGoals(selectedIndex: 0),
          routeCreateGoal => _EditGoals(),
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
  _EditGoals({
    super.key,
    this.selectedIndex,
  });

  int? selectedIndex;

  @override
  State<_EditGoals> createState() => _EditGoalsState();
}

class _EditGoalsState extends State<_EditGoals> {
  @override
  Widget build(BuildContext context) {
    StorageRoot storageRoot = Provider.of<StorageRoot>(context);

    if (widget.selectedIndex == null) {
      storageRoot.addGoal(Goal());
      widget.selectedIndex = storageRoot.goalsLength-1;
    } else if (widget.selectedIndex! >= storageRoot.goalsLength) {
      widget.selectedIndex = storageRoot.goalsLength-1;
    }

    log('building _EditGoalsState ${widget.selectedIndex}');
    return AppPanels(
      singleLayout: GoalBrowserView(
        storageRoot: storageRoot,
        selectedIndex: widget.selectedIndex,
        onSelected: (context, newSelectedIndex) {
          setState(() {
            widget.selectedIndex = newSelectedIndex;
            log('selected ${widget.selectedIndex}');
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GoalWizard(
                storageRoot: storageRoot,
                goalIndex: widget.selectedIndex,
                appbar: true,
                onDone: () => Navigator.pop(context),
              ),
            ),
          );
        },
      ),
      doubleLayoutLeft: GoalBrowserView(
        storageRoot: storageRoot,
        selectedIndex: widget.selectedIndex,
        onSelected: (context, newSelectedIndex) {
          setState(() {
            widget.selectedIndex = newSelectedIndex;
            log('selected ${widget.selectedIndex}');
          });
        },
      ),
      doubleLayoutRight: GoalWizard(
        storageRoot: storageRoot,
        goalIndex: widget.selectedIndex,
        onDone: () => setState(() {}),
      ),
    );
  }
}
