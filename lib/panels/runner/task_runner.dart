import 'dart:developer';

import 'package:final_project/repository/storage.dart';
import 'package:flutter/material.dart';
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
  late final taskStatus = widget.task.status!;

  void start() {
    taskStatus.status = TaskStatusValue.started;
    taskStatus.startedAt ??= DateTime.now();
    taskStatus.lastRunAt = DateTime.now();
    taskStatus.duration ??= const Duration();

    Storage.instance.updateTaskStatus(taskStatus);
    runController.resume();
  }

  void stop() {
    taskStatus.status = TaskStatusValue.stopped;
    if (taskStatus.startedAt != null) {
      taskStatus.duration = (taskStatus.duration ?? const Duration()) +
          DateTime.now().difference(taskStatus.lastRunAt!);
    }

    Storage.instance.updateTaskStatus(taskStatus);
    runController.pause();
  }

  void done() {
    if (taskStatus.status == TaskStatusValue.started) {
      stop();
    }

    taskStatus.status = TaskStatusValue.done;
    Storage.instance.updateTaskStatus(taskStatus);
    Storage.instance.addTaskToHistory(taskStatus);
  }

  void restart() {
    if (taskStatus.status == TaskStatusValue.done && widget.task.repeatable) {
      taskStatus.status = TaskStatusValue.ready;
      Storage.instance.updateTaskStatus(taskStatus);
    }
  }

  @override
  void dispose() {
    taskStatus.status = TaskStatusValue.stopped;
    if (taskStatus.startedAt != null) {
      taskStatus.duration = (taskStatus.duration ?? const Duration()) +
          DateTime.now().difference(taskStatus.lastRunAt!);
    }

    Storage.instance.updateTaskStatus(taskStatus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storageRoot = Provider.of<StorageRoot>(context);

    taskStatus.timebox ??= storageRoot.config.defaultTimebox;
    taskStatus.cooldown ??= storageRoot.config.defaultCooldown;

    return _RunTaskUI(
      runController: runController,
      runTaskController: _RunTaskUIController(
        onStart: () => setState(() => start()),
        onStop: () => setState(() => stop()),
        onDone: () => setState(() => done()),
        onRestart: () => setState(() => restart()),
        onSetTimebox: (duration) => setState(() {
          taskStatus.timebox = duration;
          Storage.instance.updateTaskStatus(taskStatus);
        }),
      ),
    );
  }
}

class _RunTaskUI extends StatelessWidget {
  const _RunTaskUI({
    super.key,
    required this.runTaskController,
    required this.runController,
  });

  final TaskProgressController runController;
  final _RunTaskUIController runTaskController;

  @override
  Widget build(BuildContext context) {
    final storageRoot = Provider.of<StorageRoot>(context);

    final task = ModalRoute.of(context)!.settings.arguments as Task;
    final goal = storageRoot.findGoalById(task.goalId);

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
                    child: _TimeboxCard(
                      task: task,
                      timebox: const Duration(seconds: 10),
                      //task.status!.timebox!,
                      cooldown: const Duration(seconds: 5),
                      //task.status!.cooldown!,
                      controller: runController,
                      onSetTimebox: runTaskController.onSetTimebox,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
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

class _RunTaskUIController {
  const _RunTaskUIController({
    required this.onStart,
    required this.onStop,
    required this.onDone,
    required this.onRestart,
    required this.onSetTimebox,
  });

  final Function() onStart;
  final Function() onStop;
  final Function() onDone;
  final Function() onRestart;
  final Function(Duration) onSetTimebox;
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
                    const Text('Keep track of how long the task takes'),
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

class _TimeboxCard extends StatefulWidget {
  const _TimeboxCard({
    super.key,
    required this.task,
    required this.timebox,
    required this.cooldown,
    required this.controller,
    required this.onSetTimebox,
  });

  final Task task;
  final Duration timebox;
  final Duration cooldown;
  final TaskProgressController controller;
  final Function(Duration) onSetTimebox;

  @override
  State<_TimeboxCard> createState() => _TimeboxCardState();
}

class _TimeboxCardState extends State<_TimeboxCard>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  late final _colorScheme = Theme.of(context).colorScheme;
  late final _progressValueColor = _colorScheme.primary;
  late final _progressBackgroundColor = _colorScheme.onPrimary;

  late final backgroundColor = Color.alphaBlend(
      _colorScheme.secondary.withOpacity(0.14), _colorScheme.surface);

  bool isTimebox = true;

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
      duration: widget.timebox,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.timebox.inSeconds.toDouble(),
    ).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && isTimebox) {
        isTimebox = false;
        _animationController.duration = widget.cooldown;

        _animation = Tween<double>(
          begin: 0.0,
          end: widget.cooldown.inSeconds.toDouble(),
        ).animate(_animationController);

        _animationController.reverse();
      }
      if (status == AnimationStatus.dismissed && !isTimebox) {
        isTimebox = true;
        _animationController.duration = widget.timebox;

        _animation = Tween<double>(
          begin: 0.0,
          end: widget.timebox.inSeconds.toDouble(),
        ).animate(_animationController);
      }
    });

    _animationController.addListener(() {
      setState(() {});
    });

    widget.controller._state = this;
    isTimebox = true;
  }

  @override
  void reassemble() {
    if (widget.task.status!.status == TaskStatusValue.started) {
      _animationController.forward();
    }
    super.reassemble();
  }

  var timeFormatter = (Duration d) =>
      "${d.inMinutes.toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final size = constraints.maxWidth > constraints.maxHeight
            ? constraints.maxHeight
            : constraints.maxWidth;
        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: Card(
              color: backgroundColor,
              child: Padding(
                padding: EdgeInsets.all(size / 30.0),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(size / 30.0),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: CircularProgressIndicator(
                            strokeWidth: size / 13.0,
                            color: _progressValueColor,
                            backgroundColor: _progressBackgroundColor,
                            value: _animation.value /
                                (isTimebox
                                    ? widget.timebox.inSeconds
                                    : widget.cooldown.inSeconds),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(size / 60.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showMaterialNumberPicker(
                                      context: context,
                                      title:
                                          'How many minutes do you want to run this task?',
                                      step: 5,
                                      minNumber: 5,
                                      maxNumber: 120,
                                      selectedNumber: widget.timebox.inMinutes,
                                      onChanged: (newDuration) =>
                                          widget.onSetTimebox(
                                              Duration(minutes: newDuration)),
                                    );
                                  },
                                  child: Text(
                                    timeFormatter(isTimebox
                                        ? Duration(
                                            seconds: widget.timebox.inSeconds -
                                                _animation.value.toInt())
                                        : Duration()),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Colors.black,
                                            fontSize: size / 9.0,
                                            fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      isTimebox ? "TIMEBOX" : "COOLDOWN",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              color: Colors.black,
                                              fontSize: size / 12.0,
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showMaterialNumberPicker(
                                      context: context,
                                      title:
                                          'How many minutes do you want to pause after this task?',
                                      step: 5,
                                      minNumber: 0,
                                      maxNumber: 100,
                                      selectedNumber: widget.cooldown.inMinutes,
                                      onChanged: (newDuration) =>
                                          widget.onSetTimebox(
                                              Duration(minutes: newDuration)),
                                    );
                                  },
                                  child: Text(
                                    timeFormatter(isTimebox
                                        ? widget.cooldown
                                        : Duration(
                                            seconds: _animation.value.toInt())),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Colors.black,
                                            fontSize: size / 9.0,
                                            fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TaskProgressController {
  late _TimeboxCardState _state;

  void pause() => _state._animationController.stop(canceled: false);

  void resume() => _state._animationController.forward();
}
