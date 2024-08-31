import 'dart:developer';

import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../repository/storage.dart';

class TaskTile extends StatefulWidget {
  const TaskTile({
    super.key,
    required this.goal,
    required this.task,
    required this.onDelete,
  });

  final Goal goal;
  final Task task;
  final void Function() onDelete;

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
            Storage.instance.updateTask(widget.task);
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

    return  Dismissible(
      key: Key(widget.goal.id!.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        widget.onDelete();
      },
      background: Container(
        color: Colors.redAccent,
        alignment: AlignmentDirectional.centerEnd,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.delete_forever),
        ),
      ),
      child: ListTile(
        title: nameField,
        leading: GestureDetector(
          child: Icon(widget.task.repeatable ? Icons.repeat_on : Icons.repeat),
          onTap: () => setState(() {
            widget.task.repeatable = !widget.task.repeatable;
            Storage.instance.updateTask(widget.task);
          }),
        ),
      ),
    );
  }
}
