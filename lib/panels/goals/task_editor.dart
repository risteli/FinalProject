import 'dart:developer';

import 'task_tile.dart';
import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../repository/storage.dart';

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

    return Scrollbar(
      thumbVisibility: true,
      child: ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          setState(() => tasks.insert(newIndex, tasks.removeAt(oldIndex)));
          Storage.instance.updateTasks(widget.goal);
        },
        children: [
          for (var task in tasks)
            TaskTile(
              key: Key('task-${task.id}'),
              goal: widget.goal,
              task: task,
              onDelete: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Task "${task.name}" removed')));
                setState(() {
                  widget.goal.tasks.remove(task);
                  Storage.instance.updateTasks(widget.goal);
                });
              },
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
                Storage.instance.createTask(task);
              });
            },
          ),
        ],
      ),
    );
  }
}
