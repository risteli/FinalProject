import 'dart:developer';

import 'package:final_project/panels/goals/wizard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../models/roots.dart';
import '../../routes.dart';
import '../../top.dart';
import '../../widgets/app_panels.dart';
import 'browser.dart';

class GoalsPanel extends StatefulWidget {
  const GoalsPanel({
    super.key,
    required this.topController,
  });

  final TopController topController;

  @override
  State<GoalsPanel> createState() => _GoalsPanelState();
}

class _GoalsPanelState extends State<GoalsPanel> {
  int? selectedIndex;
  late StorageRoot storageRoot =
      Provider.of<StorageRoot>(context, listen: false);

  @override
  void initState() {
    super.initState();
    widget.topController.onCreate = create;
  }

  @override
  void dispose() {
    widget.topController.onCreate = null;
    super.dispose();
  }

  void create() {
    setState(() {
      storageRoot.addGoal(Goal());
      selectedIndex = storageRoot.goalsLength - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    StorageRoot storageRoot = Provider.of<StorageRoot>(context);

    if (selectedIndex != null && selectedIndex! >= storageRoot.goalsLength) {
      selectedIndex = storageRoot.goalsLength - 1;
    }

    log('building _EditGoalsState ${selectedIndex}');
    return AppPanels(
      singleLayout: selectedIndex == null
          ? GoalBrowserView(
              storageRoot: storageRoot,
              selectedIndex: selectedIndex,
              onSelected: (context, newSelectedIndex) {
                setState(() {
                  selectedIndex = newSelectedIndex;
                  log('selected ${selectedIndex}');
                });
              },
            )
          : GoalWizard(
              storageRoot: storageRoot,
              goalIndex: selectedIndex,
              appbar: true,
              onDone: () => setState(
                () {
                  selectedIndex = null;
                  log('selected ${selectedIndex}');
                },
              ),
            ),
      doubleLayoutLeft: GoalBrowserView(
        storageRoot: storageRoot,
        selectedIndex: selectedIndex,
        onSelected: (context, newSelectedIndex) {
          setState(() {
            selectedIndex = newSelectedIndex;
            log('selected ${selectedIndex}');
          });
        },
      ),
      doubleLayoutRight: GoalWizard(
        storageRoot: storageRoot,
        goalIndex: selectedIndex,
        onDone: () => setState(() {}),
      ),
    );
  }
}
