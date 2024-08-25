import 'dart:developer';

import 'package:final_project/panels/goals/runner_tasks_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../models/roots.dart';
import '../../widgets/app_panels.dart';

class GoalsRunnerTasks extends StatefulWidget {
  const GoalsRunnerTasks({
    super.key,
    required this.goal,
    required this.onSelected,
  });

  final Goal goal;
  final Function(Task) onSelected;

  @override
  State<GoalsRunnerTasks> createState() => _GoalsRunnerTasksState();
}

class _GoalsRunnerTasksState extends State<GoalsRunnerTasks> {
  @override
  Widget build(BuildContext context) {
    log('building _GoalBrowserViewState ${widget.goal}');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goal.name),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            GoalsRunnerTasksList(
              goal: widget.goal,
              onSelected: widget.onSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class GoalsRunnerTasksList extends StatefulWidget {
  const GoalsRunnerTasksList({
    super.key,
    required this.goal,
    required this.onSelected,
  });

  final Goal goal;
  final Function(Task) onSelected;

  @override
  State<GoalsRunnerTasksList> createState() => _GoalsRunnerTasksListState();
}

class _GoalsRunnerTasksListState extends State<GoalsRunnerTasksList> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var tasks = widget.goal.tasks;
    log('building GoalsRunnerTasksListState ${tasks}');

    return ListView(
      shrinkWrap: true,
      children: List.generate(
        tasks.length,
        (index) {
          var task = tasks[index];
          return Padding(
            key: Key('goal-${index}'),
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GoalsRunnerTaskTile(
              task: task,
              onSelected: () {
                selectedIndex == index;
                widget.onSelected(task);
              },
              isSelected: selectedIndex == index,
            ),
          );
        },
      ),
    );
  }
}
