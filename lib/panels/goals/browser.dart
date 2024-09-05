import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/roots.dart';

import '../../repository/storage.dart';
import 'goal_tile.dart';
import '../../widgets/search_bar.dart' as search_bar;

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
          Text(
            "Your goals",
            style: TextStyle(fontSize: 32.0, color: _colorScheme.onSurface),
          ),
          Text(
            "Start planning your goals, task by task.",
            style: TextStyle(fontSize: 16.0, color: _colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          GoalBrowserList(
            onSelected: widget.onSelected,
            onUpdatedGoals: () => storage.updateGoals(),
            selectedIndex: widget.selectedIndex,
          ),
        ],
      ),
    );
  }
}

class GoalBrowserList extends StatefulWidget {
  const GoalBrowserList({
    super.key,
    required this.onSelected,
    required this.onUpdatedGoals,
    this.selectedIndex,
  });

  final Function(BuildContext context, int) onSelected;
  final Function() onUpdatedGoals;
  final int? selectedIndex;

  @override
  State<GoalBrowserList> createState() => _GoalBrowserListState();
}

class _GoalBrowserListState extends State<GoalBrowserList> {
  @override
  Widget build(BuildContext context) {
    late StorageRoot storageRoot = Provider.of<StorageRoot>(context);

    log('building GoalBrowserList ${storageRoot.goals} ${widget.selectedIndex}');

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
                    SnackBar(content: Text('Goal "${goal.name}" dismissed')));
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
