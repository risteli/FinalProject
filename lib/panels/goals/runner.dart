import 'dart:developer';

import 'package:flutter/cupertino.dart';
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
      onRestart: () {
        setState(() {
          task.status!.status = TaskStatusValue.ready;
        });
        log('restarting the task, now ${task.status!}');
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
    required this.onRestart,
  });

  final status;
  final Function() onStart;
  final Function() onStop;
  final Function() onDone;
  final Function() onRestart;

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
          _GoalCard(goal: goal),
          _TaskCard(task: task),
          if (task.status!.status != TaskStatusValue.done) ...[
            _StartStopCard(task: task, onStart: onStart, onStop: onStop),
            _DoneCard(task: task, onDone: onDone),
          ] else if (task.repeatable)
            _RestartCard(task: task, onRestart: onRestart)
          else
            _CompletedCard()
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
        colorScheme.secondary.withOpacity(0.14), colorScheme.surface);
    late final textStyle = TextStyle(color: colorScheme.secondary);

    return Card(
      color: backgroundColor,
      child: SizedBox(
        width: 200,
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(width: 8),
              Icon(goal.goalType?.icon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Your goal'),
                    const SizedBox(height: 8),
                    Text(
                      goal.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: textStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
        colorScheme.secondary.withOpacity(0.14), colorScheme.surface);
    late final textStyle = TextStyle(color: colorScheme.secondary);

    return Card(
      color: backgroundColor,
      child: SizedBox(
        width: 200,
        height: 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Task to complete'),
                    Text(
                      task.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: textStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StartStopCard extends StatelessWidget {
  const _StartStopCard(
      {required this.task, required this.onStart, required this.onStop});

  final Task task;
  final Function() onStart;
  final Function() onStop;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
        colorScheme.secondary.withOpacity(0.14), colorScheme.surface);
    late final textStyle = TextStyle(color: colorScheme.secondary);

    return Card(
      color: backgroundColor,
      child: SizedBox(
        width: 300,
        height: 150,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                        'If you want, you can keep track of how long the task takes!'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (task.status!.status == TaskStatusValue.ready ||
                            task.status!.status == TaskStatusValue.stopped)
                          ElevatedButton.icon(
                            onPressed: onStart,
                            icon: const Icon(Icons.start),
                            label: const Text('Start'),
                          ),
                        if (task.status!.status == TaskStatusValue.started)
                          ElevatedButton.icon(
                            onPressed: onStop,
                            icon: const Icon(Icons.stop),
                            label: const Text('Stop'),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoneCard extends StatelessWidget {
  const _DoneCard({required this.task, required this.onDone});

  final Task task;
  final Function() onDone;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
        colorScheme.secondary.withOpacity(0.14), colorScheme.surface);
    late final textStyle = TextStyle(color: colorScheme.secondary);

    return Card(
      color: backgroundColor,
      child: SizedBox(
        width: 300,
        height: 150,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Tap here when the task is done!'),
                    ElevatedButton.icon(
                      onPressed: onDone,
                      icon: const Icon(Icons.done),
                      label: const Text('Done'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RestartCard extends StatelessWidget {
  const _RestartCard({required this.task, required this.onRestart});

  final Task task;
  final Function() onRestart;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
        colorScheme.secondary.withOpacity(0.14), colorScheme.surface);
    late final textStyle = TextStyle(color: colorScheme.secondary);

    return Card(
      color: backgroundColor,
      child: SizedBox(
        width: 300,
        height: 150,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                        'You completed this task already, but you can do it again!'),
                    ElevatedButton.icon(
                      onPressed: onRestart,
                      icon: const Icon(Icons.repeat),
                      label: const Text('Restart'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletedCard extends StatelessWidget {
  const _CompletedCard();

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
        colorScheme.secondary.withOpacity(0.14), colorScheme.surface);
    late final textStyle = TextStyle(color: colorScheme.secondary);

    return Card(
      color: backgroundColor,
      child: const SizedBox(
        width: 300,
        height: 150,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('You completed this task already.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
