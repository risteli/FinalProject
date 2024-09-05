import 'dart:developer';

import 'package:final_project/panels/runner/tasks_tile.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goal.name),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            _GoalsRunnerTasksList(
              goal: widget.goal,
              onSelected: widget.onSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalsRunnerTasksList extends StatefulWidget {
  const _GoalsRunnerTasksList({
    super.key,
    required this.goal,
    required this.onSelected,
  });

  final Goal goal;
  final Function(Task) onSelected;

  @override
  State<_GoalsRunnerTasksList> createState() => _GoalsRunnerTasksListState();
}

class _GoalsRunnerTasksListState extends State<_GoalsRunnerTasksList> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var tasks = widget.goal.tasks;
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
