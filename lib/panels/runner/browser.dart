import 'dart:developer';

import 'package:final_project/panels/runner/goal_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/roots.dart';
import '../../repository/storage.dart';

class GoalsRunnerBrowser extends StatefulWidget {
  const GoalsRunnerBrowser({
    super.key,
    required this.storageRoot,
    required this.selectedIndex,
    required this.onSelected,
  });

  final StorageRoot storageRoot;
  final int selectedIndex;
  final Function(BuildContext context, int) onSelected;

  @override
  State<GoalsRunnerBrowser> createState() => _GoalsRunnerBrowserState();
}

class _GoalsRunnerBrowserState extends State<GoalsRunnerBrowser> {
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;
  final storage = Storage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Time for action!",
              style: TextStyle(fontSize: 32.0, color: _colorScheme.onSurface),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Which goal do you want to work on?",
              style: TextStyle(fontSize: 16.0, color: _colorScheme.onSurface),
            ),
          ),
          const SizedBox(height: 8),
          _GoalsRunnerGoalsList(
            storageRoot: widget.storageRoot,
            onSelected: widget.onSelected,
            selectedIndex: widget.selectedIndex,
          ),
        ],
      ),
    );
  }
}

class _GoalsRunnerGoalsList extends StatefulWidget {
  const _GoalsRunnerGoalsList({
    super.key,
    required this.storageRoot,
    required this.onSelected,
    this.selectedIndex,
  });

  final StorageRoot storageRoot;
  final Function(BuildContext context, int) onSelected;
  final int? selectedIndex;

  @override
  State<_GoalsRunnerGoalsList> createState() => _GoalsRunnerGoalsListState();
}

class _GoalsRunnerGoalsListState extends State<_GoalsRunnerGoalsList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: List.generate(
        widget.storageRoot.goals.length,
        (index) {
          var goal = widget.storageRoot.goals[index];

          return Padding(
            key: Key('goal-${index}'),
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GoalsRunnerGoalTile(
              goal: goal,
              onSelected: () => widget.onSelected(context, index),
              isSelected: widget.selectedIndex == index,
            ),
          );
        },
      ),
    );
  }
}
