import 'dart:developer';

import 'package:flutter/material.dart';
import '../models/models.dart';

class TaskList extends StatefulWidget {
  const TaskList({
    super.key,
    required this.tasks,
  });

  final List<Task> tasks;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {},
        children: [
          for (var task in widget.tasks)
            ListTile(
              key: Key(task.name),
              title: Text(task.name),
              trailing: Icon(Icons.repeat),
            ),
          for (var task in widget.tasks)
            ListTile(
              key: Key('2${task.name}'),
              title: Text(task.name),
              trailing: Icon(Icons.repeat),
            ),
        ],
      ),
    );
  }
}
