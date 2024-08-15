import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repository/database.dart';
import '../../models/models.dart';
import '../../repository/goals.dart';

class TaskTile extends StatefulWidget {
  const TaskTile({
    super.key,
    required this.goal,
    required this.task,
  });

  final Goal goal;
  final Task task;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  final taskController = TextEditingController();
  bool isEditing = false;

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goalsRepo = GoalsRepo(Provider.of<AppDatabase>(context));

    Widget nameField;

    if (isEditing) {
      taskController.value = TextEditingValue(text: widget.task.name);

      nameField = TextField(
        key: const Key('task-new'),
        controller: taskController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.add),
          labelText: 'Describe the task',
        ),
        onSubmitted: (value) {
          setState(() {
            widget.task.name = value;
            goalsRepo.updateTask(widget.task);
            isEditing = false;
          });
        },
      );
    } else {
      nameField = GestureDetector(
        child: Text(widget.task.name),
        onTap: () => setState(() => isEditing = true),
      );
    }

    return ListTile(
      title: nameField,
      leading: GestureDetector(
        child: Icon(widget.task.repeatable ? Icons.repeat_on : Icons.repeat),
        onTap: () => setState(() {
          widget.task.repeatable = !widget.task.repeatable;
          goalsRepo.updateTask(widget.task);
        }),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: Icon(Icons.delete),
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Task deletion'),
                content: Text(
                    'Are you sure you want to want to delete task ${widget.task.name}?'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => setState(() {
                            widget.goal.tasks.remove(widget.task);
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
    );
  }
}
