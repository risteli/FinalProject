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
  final newTaskController = TextEditingController();

  @override
  void dispose() {
    newTaskController.dispose();
    super.dispose();
  }

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
            TaskWidget(
              key: Key('task-${task.id}'),
              goal: widget.goal,
              task: task,
            ),
          TextField(
            key: Key('task-new'),
            controller: newTaskController,
            decoration: InputDecoration(
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
                goalsRepo.createTask(task);
              });
            },
          ),
        ],
      ),
    );
  }
}

class TaskWidget extends StatefulWidget {
  const TaskWidget({
    super.key,
    required this.goal,
    required this.task,
  });

  final Goal goal;
  final Task task;

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
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
