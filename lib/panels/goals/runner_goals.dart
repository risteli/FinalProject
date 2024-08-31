import 'dart:developer';

import 'package:final_project/panels/goals/runner_goals_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../models/roots.dart';
import '../../repository/storage.dart';
import '../../widgets/app_panels.dart';

class GoalsRunnerGoals extends StatefulWidget {
  const GoalsRunnerGoals({
    super.key,
    required this.goalsModel,
    required this.selectedIndex,
    required this.onSelected,
  });

  final GoalsModel goalsModel;
  final int selectedIndex;
  final Function(BuildContext context, int) onSelected;

  @override
  State<GoalsRunnerGoals> createState() => _GoalsRunnerGoalsState();
}

class _GoalsRunnerGoalsState extends State<GoalsRunnerGoals> {
  final storage = Storage();

  @override
  Widget build(BuildContext context) {
    log('building _GoalBrowserViewState ${widget.selectedIndex}');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        children: [
          GoalsRunnerGoalsList(
            goalsModel: widget.goalsModel,
            onSelected: widget.onSelected,
            selectedIndex: widget.selectedIndex,
          ),
        ],
      ),
    );
  }
}


class GoalsRunnerGoalsList extends StatefulWidget {
  const GoalsRunnerGoalsList({
    super.key,
    required this.goalsModel,
    required this.onSelected,
    this.selectedIndex,
  });

  final GoalsModel goalsModel;
  final Function(BuildContext context, int) onSelected;
  final int? selectedIndex;

  @override
  State<GoalsRunnerGoalsList> createState() => _GoalsRunnerGoalsListState();
}

class _GoalsRunnerGoalsListState extends State<GoalsRunnerGoalsList> {
  @override
  Widget build(BuildContext context) {
    log('building GoalsRunnerGoalsList ${widget.goalsModel.items} ${widget.selectedIndex}');

    return ListView(
      shrinkWrap: true,
      children: List.generate(
        widget.goalsModel.items.length,
            (index) {
          var goal = widget.goalsModel.items[index];
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
