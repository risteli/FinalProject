import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../models/roots.dart';

class RunTask extends StatefulWidget {
  const RunTask({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<RunTask> createState() => _RunTaskState();
}

class _RunTaskState extends State<RunTask> {
  final runController = TaskProgressController();

  @override
  void dispose() {
    log('disposing of task $widget.task');
    if (widget.task.status!.status == TaskStatusValue.started) {
      widget.task.status!.status = TaskStatusValue.stopped;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storageRoot = Provider.of<StorageRoot>(context);

    var taskStatus = widget.task.status!;

    taskStatus.timebox ??= storageRoot.config.defaultTimebox;
    taskStatus.cooldown ??= storageRoot.config.defaultCooldown;

    return RunTaskUI(
      runController: runController,
      runTaskController: RunTaskUIController(
        onStart: () {
          setState(() {
            taskStatus.status = TaskStatusValue.started;
            taskStatus.startedAt ??= DateTime.now();
            taskStatus.lastRunAt = DateTime.now();
            taskStatus.duration ??= const Duration();
          });
          log('starting the task, now ${taskStatus}');
          runController.resume();
        },
        onStop: () {
          setState(() {
            taskStatus!.status = TaskStatusValue.stopped;
          });
          log('stopping the task, now ${taskStatus}');
          runController.pause();
        },
        onDone: () {
          setState(() {
            taskStatus!.status = TaskStatusValue.done;
          });
          log('completing the task, now ${taskStatus!}');
        },
        onRestart: () {
          setState(() {
            taskStatus!.status = TaskStatusValue.ready;
          });
          log('restarting the task, now ${taskStatus!}');
        },
        onSetDuration: (duration) {
          setState(() {
            widget.task.estimation = duration;
          });
        },
      ),
    );
  }
}

class RunTaskUI extends StatelessWidget {
  const RunTaskUI({
    super.key,
    required this.runTaskController,
    required this.runController,
  });

  final TaskProgressController runController;
  final RunTaskUIController runTaskController;

  @override
  Widget build(BuildContext context) {
    final storageRoot = Provider.of<StorageRoot>(context);

    final task = ModalRoute.of(context)!.settings.arguments as Task;
    final goal = storageRoot.findGoalById(task.goalId);

    Duration duration = task.estimation ?? const Duration(minutes: 25);

    return Card(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: _InfoCard(
              goal: goal,
              task: task,
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TaskProgress(
                      task: task,
                      duration: duration,
                      controller: runController,
                      onSetDuration: runTaskController.onSetDuration,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (task.status!.status != TaskStatusValue.done) ...[
                          _StartStopCard(
                              task: task,
                              onStart: runTaskController.onStart,
                              onStop: runTaskController.onStop),
                          _DoneCard(
                              task: task, onDone: runTaskController.onDone),
                        ] else if (task.repeatable)
                          _RestartCard(
                              task: task,
                              onRestart: runTaskController.onRestart)
                        else
                          const _CompletedCard()
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

class RunTaskUIController {
  const RunTaskUIController({
    required this.onStart,
    required this.onStop,
    required this.onDone,
    required this.onRestart,
    required this.onSetDuration,
  });

  final Function() onStart;
  final Function() onStop;
  final Function() onDone;
  final Function() onRestart;
  final Function(Duration) onSetDuration;
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.goal, required this.task});

  final Goal goal;
  final Task task;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
        colorScheme.secondary.withOpacity(0.14), colorScheme.surface);

    return Card(
      color: backgroundColor,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(width: 8),
              Icon(
                goal.goalType?.icon,
                size: 80.0,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                        color: colorScheme.secondary,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      task.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                        color: colorScheme.secondary,
                        fontSize: 16.0,
                      ),
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

// based on https://github.com/AndresR173/countdown_progress_indicator/blob/main/lib/countdown_progress_indicator.dart

class TaskProgress extends StatefulWidget {
  const TaskProgress({
    super.key,
    required this.task,
    required this.duration,
    required this.controller,
    required this.onSetDuration,
  });

  final Task task;
  final Duration duration;
  final TaskProgressController controller;
  final Function(Duration) onSetDuration;

  @override
  State<TaskProgress> createState() => _TaskProgressState();
}

class _TaskProgressState extends State<TaskProgress>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  late final _colorScheme = Theme.of(context).colorScheme;
  late final _progressValueColor = _colorScheme.secondary;
  late final _progressBackgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.30), _colorScheme.surface);

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.duration.inSeconds.toDouble(),
    ).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        log('completed');
      }
    });

    _animationController.addListener(() {
      setState(() {});
    });

    widget.controller._state = this;
  }

  @override
  void reassemble() {
    if (widget.task.status!.status == TaskStatusValue.started) {
      _animationController.forward();
    }
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: CircularProgressIndicator(
                strokeWidth: 24.0,
                valueColor: AlwaysStoppedAnimation<Color>(_progressValueColor),
                backgroundColor: _progressBackgroundColor,
                value: _animation.value / widget.duration.inSeconds,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showMaterialNumberPicker(
                          context: context,
                          title: 'How many minutes do you want to run this task?',
                          step: 5,
                          minNumber: 5,
                          maxNumber: 100,
                          selectedNumber: widget.duration.inMinutes,
                          onChanged: (newDuration) => widget
                              .onSetDuration(Duration(minutes: newDuration)),
                        );
                      },
                      child: Text(
                        Duration(
                                seconds: widget.duration.inSeconds -
                                    _animation.value.toInt())
                            .toString()
                            .split('.')[0],
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _animationController.forward(from: 0.0),
                      child: const Icon(Icons.restart_alt),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskProgressController {
  late _TaskProgressState _state;

  void pause() => _state._animationController.stop(canceled: false);

  void resume() => _state._animationController.forward();
}
