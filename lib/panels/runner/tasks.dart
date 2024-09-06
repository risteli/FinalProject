import 'dart:developer';

import 'package:final_project/panels/runner/tasks_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/models.dart';

class GoalsRunnerTasks extends StatefulWidget {
  const GoalsRunnerTasks({
    super.key,
    required this.goal,
    required this.onSelected,
    required this.singlePanel,
  });

  final Goal goal;
  final Function(Task) onSelected;
  final bool singlePanel;

  @override
  State<GoalsRunnerTasks> createState() => _GoalsRunnerTasksState();
}

class _GoalsRunnerTasksState extends State<GoalsRunnerTasks> {
  late final ColorScheme _colorScheme = Theme
      .of(context)
      .colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.singlePanel
          ? AppBar(
        title: Text(widget.goal.name),
      )
          : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            if (!widget.singlePanel)
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 8),
                child: Text(
                  widget.goal.name,
                  style: TextStyle(
                    fontSize: 32.0,
                    color: _colorScheme.onSurface,
                  ),
                ),
              ),
            if (widget.goal.deadline != null)
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 8),
                child: Text(
                  "Deadline: ${DateFormat.yMMMEd().format(
                      widget.goal.deadline!)}",
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                ),
              ),
            if (widget.goal.lastRunAt != null)
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 8, bottom: 8),
                child: Text(
                  "Last run: ${DateFormat.yMMMEd().format(
                      widget.goal.lastRunAt!)} ${DateFormat.Hm().format(
                      widget.goal.lastRunAt!)}",
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                ),
              ),
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
