import 'dart:developer';

import 'package:flutter/material.dart';
import '../../models/roots.dart';

import '../../repository/goals.dart';
import 'goal_tile.dart';
import '../../widgets/search_bar.dart' as search_bar;

class GoalBrowserView extends StatefulWidget {
  const GoalBrowserView({
    super.key,
    required this.goalsModel,
    required this.onSelected,
    this.selectedIndex,
  });

  final GoalsModel goalsModel;
  final Function(BuildContext context, int) onSelected;
  final int? selectedIndex;

  @override
  State<GoalBrowserView> createState() => _GoalBrowserViewState();
}

class _GoalBrowserViewState extends State<GoalBrowserView> {
  final goalsRepo = GoalsRepo();

  @override
  Widget build(BuildContext context) {
    log('building _GoalBrowserViewState ${widget.selectedIndex}');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        children: [
          const SizedBox(height: 8),
          const search_bar.SearchBar(),
          const SizedBox(height: 8),
          GoalBrowserList(
            goalsModel: widget.goalsModel,
            onSelected: widget.onSelected,
            onUpdatedGoals: () => goalsRepo.updateGoals(widget.goalsModel),
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
    required this.goalsModel,
    required this.onSelected,
    required this.onUpdatedGoals,
    this.selectedIndex,
  });

  final GoalsModel goalsModel;
  final Function(BuildContext context, int) onSelected;
  final Function() onUpdatedGoals;
  final int? selectedIndex;

  @override
  State<GoalBrowserList> createState() => _GoalBrowserListState();
}

class _GoalBrowserListState extends State<GoalBrowserList> {
  @override
  Widget build(BuildContext context) {
    log('building GoalBrowserList ${widget.goalsModel.items} ${widget.selectedIndex}');

    return ReorderableListView(
      shrinkWrap: true,
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          widget.goalsModel.move(oldIndex, newIndex);
          widget.onUpdatedGoals();
        });
      },
      children: List.generate(
        widget.goalsModel.items.length,
        (index) {
          var goal = widget.goalsModel.items[index];
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
                  widget.goalsModel.delete(index);
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
