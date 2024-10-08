import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/roots.dart';

import '../../repository/storage.dart';
import 'goal_tile.dart';

class GoalBrowserView extends StatefulWidget {
  const GoalBrowserView({
    super.key,
    required this.onSelected,
    this.selectedIndex,
  });

  final Function(BuildContext context, int) onSelected;
  final int? selectedIndex;

  @override
  State<GoalBrowserView> createState() => _GoalBrowserViewState();
}

class _GoalBrowserViewState extends State<GoalBrowserView> {
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
              "Your goals",
              style: TextStyle(fontSize: 32.0, color: _colorScheme.onSurface),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Start planning your goals, task by task.",
              style: TextStyle(fontSize: 16.0, color: _colorScheme.onSurface),
            ),
          ),
          const SizedBox(height: 8),
          _GoalBrowserList(
            onSelected: widget.onSelected,
            onUpdatedGoals: () => storage.updateGoals(),
            selectedIndex: widget.selectedIndex,
          ),
        ],
      ),
    );
  }
}

class _GoalBrowserList extends StatefulWidget {
  const _GoalBrowserList({
    super.key,
    required this.onSelected,
    required this.onUpdatedGoals,
    this.selectedIndex,
  });

  final Function(BuildContext context, int) onSelected;
  final Function() onUpdatedGoals;
  final int? selectedIndex;

  @override
  State<_GoalBrowserList> createState() => _GoalBrowserListState();
}

class _GoalBrowserListState extends State<_GoalBrowserList> {
  @override
  Widget build(BuildContext context) {
    late StorageRoot storageRoot = Provider.of<StorageRoot>(context);

    return ReorderableListView(
      shrinkWrap: true,
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          storageRoot.moveGoal(oldIndex, newIndex);
          widget.onUpdatedGoals();
        });
      },
      children: List.generate(
        storageRoot.goals.length,
        (index) {
          var goal = storageRoot.goals[index];
          return Padding(
            key: Key('goal-${index}'),
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GoalTile(
              goal: goal,
              onSelected: () => widget.onSelected(context, index),
              onDelete: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Goal "${goal.name}" removed.')));
                setState(() {
                  storageRoot.deleteGoalAt(index);
                  widget.onUpdatedGoals();
                });
              },
              isSelected: widget.selectedIndex == index,
            ),
          );
        },
      ),
    );
  }
}
