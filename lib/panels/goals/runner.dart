import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../models/roots.dart';

class RunTask extends StatefulWidget {
  const RunTask({
    super.key,
  });

  @override
  State<RunTask> createState() => _RunTaskState();
}

class _RunTaskState extends State<RunTask> {
  @override
  Widget build(BuildContext context) {
    final goalsModel = Provider.of<GoalsModel>(context);

    final task = ModalRoute.of(context)!.settings.arguments as Task;
    final goal = goalsModel.findById(task.goalId);

    log('run task $task ${task.status}');

    return RunTaskUI(
      status: task.status!,
      onStart: () {
        setState(() {
          task.status!.status = TaskStatusValue.started;
        });
        log('starting the task, now ${task.status!}');
      },
      onStop: () {
        setState(() {
          task.status!.status = TaskStatusValue.stopped;
        });
        log('stopping the task, now ${task.status!}');
      },
      onDone: () {
        setState(() {
          task.status!.status = TaskStatusValue.done;
        });
        log('completing the task, now ${task.status!}');
      },
    );
  }
}

class RunTaskUI extends StatelessWidget {
  const RunTaskUI({
    super.key,
    required this.status,
    required this.onStart,
    required this.onStop,
    required this.onDone,
  });

  final status;
  final Function() onStart;
  final Function() onStop;
  final Function() onDone;

  @override
  Widget build(BuildContext context) {
    final goalsModel = Provider.of<GoalsModel>(context);

    final task = ModalRoute.of(context)!.settings.arguments as Task;
    final goal = goalsModel.findById(task.goalId);

    log('run task $task');

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Goal: ${goal.name}"),
          Text("Task: ${task.name}"),
          if (status.status == TaskStatusValue.ready ||
              status.status == TaskStatusValue.stopped)
            ElevatedButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.start),
              label: const Text('Start'),
            ),
          if (status.status == TaskStatusValue.started)
            ElevatedButton.icon(
              onPressed: onStop,
              icon: const Icon(Icons.stop),
              label: const Text('Stop'),
            ),
          ElevatedButton.icon(
            onPressed: onDone,
            icon: const Icon(Icons.done),
            label: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
