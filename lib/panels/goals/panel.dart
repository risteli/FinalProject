import 'dart:developer';

import 'package:final_project/panels/goals/wizard.dart';
import 'package:flutter/material.dart';

import 'editor.dart';
import '../../widgets/app_panels.dart'; // Add import
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
        final page = switch (settings.name) {
          routeHome => AppPanels(
              singleLayout: GoalBrowserView(
                  onSelected: (context) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GoalWizard(),
                    ),
                  ),
              ),
              doubleLayoutLeft: const GoalBrowserView(),
              doubleLayoutRight: const GoalWizard(),
            ),
          routeCreateTask => const AppPanels(
            singleLayout: GoalWizard(create: true,),
            doubleLayoutLeft: GoalBrowserView(),
            doubleLayoutRight: GoalWizard(create: true),
          ),
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
