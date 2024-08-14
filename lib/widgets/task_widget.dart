import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database.dart';
import '../models/models.dart';
import '../repository/goals.dart';

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
  @override
  Widget build(BuildContext context) {
    final goalsRepo = GoalsRepo(Provider.of<AppDatabase>(context));
    final tasks = widget.goal.tasks;

    return Expanded(
      child: ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          log('reorder $oldIndex to $newIndex');
          setState(() => tasks.insert(newIndex, tasks.removeAt(oldIndex)));
          goalsRepo.updateTasks(widget.goal);
        },
        children: [
          for (var task in tasks)
            ListTile(
              key: Key('task-${task.id}'),
              title: Text(task.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    child:
                        Icon(task.repeatable ? Icons.repeat_on : Icons.repeat),
                    onTap: () => setState(() {
                      task.repeatable = !task.repeatable;
                      goalsRepo.updateTask(task);
                    }),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    child: Icon(Icons.delete),
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Task deletion'),
                        content: Text(
                            'Are you sure you want to want to delete task ${task.name}?'),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () => setState(() {
                                widget.goal.tasks.remove(task);
                                goalsRepo.updateTasks(widget.goal);
                                Navigator.pop(context, 'Delete');
                              }),
                              child: const Text('Delete')),
                          TextButton(
                              onPressed: () => Navigator.pop(context, 'No'),
                              child: const Text('No')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
