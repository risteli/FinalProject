import 'dart:developer';

import 'task_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repository/database.dart';
import '../../models/models.dart';
import '../../repository/goals.dart';

class TaskList extends StatefulWidget {
  const TaskList({
    super.key,
    required this.goal,
  });

  final Goal goal;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final newTaskController = TextEditingController();

  @override
  void dispose() {
    newTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.goal.tasks;

    return Expanded(
      child: ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          log('reorder $oldIndex to $newIndex');
          setState(() => tasks.insert(newIndex, tasks.removeAt(oldIndex)));
          GoalsRepo.instance.updateTasks(widget.goal);
        },
        children: [
          for (var task in tasks)
            TaskTile(
              key: Key('task-${task.id}'),
              goal: widget.goal,
              task: task,
            ),
          TextField(
            key: const Key('task-new'),
            controller: newTaskController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.add),
              labelText: 'You can add a new task here',
            ),
            onSubmitted: (value) {
              setState(() {
                var task = Task(
                  name: value,
                  goalId: widget.goal.id,
                  position: tasks.length,
                );
                tasks.add(task);
                newTaskController.clear();
                GoalsRepo.instance.createTask(task);
              });
            },
          ),
        ],
      ),
    );
  }
}
