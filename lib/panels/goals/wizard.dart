import 'dart:developer';

import 'package:final_project/repository/storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/roots.dart';
import '../../models/models.dart';
import 'task_editor.dart';

class GoalWizard extends StatefulWidget {
  GoalWizard({
    super.key,
    required this.storageRoot,
    this.goalIndex,
    this.appbar = false,
    this.step = 1,
    required this.onDone,
  });

  final StorageRoot storageRoot;
  final int? goalIndex;
  int step;
  final bool appbar;
  final Function() onDone;

  @override
  State<GoalWizard> createState() => _GoalWizardState();
}

class _GoalWizardState extends State<GoalWizard> {
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (widget.goalIndex == null) {
      return const Card();
    }

    final goal = widget.storageRoot.goals[widget.goalIndex!];

    log('GoalWizard ${widget.storageRoot.goals} step ${widget.step}');

    void persistGoal() {
      widget.storageRoot.updateGoalAt(widget.goalIndex!, goal);
      Storage.instance.updateGoals();
    }

    Widget wizardControls = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (widget.step > 1)
          ElevatedButton(
            onPressed: () => setState(() => widget.step--),
            child: const Text('prev'),
          ),
        if (widget.step < 4)
          ElevatedButton(
            onPressed: () => setState(() => widget.step++),
            child: const Text('next'),
            //style: ElevatedButton.styleFrom(backgroundColor: _colorScheme.secondary, textStyle: TextStyle(color: _colorScheme.surface)),
          ),
        if (widget.step == 4)
          ElevatedButton(
            onPressed: () => widget.onDone(),
            child: const Text('done'),
          ),
      ],
    );

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: widget.appbar?AppBar(
        backgroundColor: _backgroundColor,
        title: const Text('Here you can define your goal'),
      ):null,
      body: Card(
        color: _backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Form(
            key: _formKey,
            child: switch (widget.step) {
              1 => GoalSlideName(
                  goal: goal,
                  controls: wizardControls,
                  onSubmitted: persistGoal,
                ),
              2 => GoalSlideType(
                  goal: goal,
                  controls: wizardControls,
                  onSubmitted: persistGoal,
                ),
              3 => GoalSlideTasks(
                  goal: goal,
                  controls: wizardControls,
                  onSubmitted: persistGoal,
                ),
              _ => const Text('invalid state'),
            },
          ),
        ),
      ),
    );
  }
}

class GoalSlideName extends StatefulWidget {
  const GoalSlideName({
    super.key,
    required this.goal,
    this.controls,
    required this.onSubmitted,
  });

  final Goal goal;
  final Widget? controls;
  final void Function() onSubmitted;

  @override
  State<GoalSlideName> createState() => _GoalSlideNameState();
}

class _GoalSlideNameState extends State<GoalSlideName> {
  final nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('now slide name ${widget.goal.name}');
    nameController.text = widget.goal.name ?? "";

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text("What do you want to accomplish?"),
        TextField(
            controller: nameController,
            onSubmitted: (value) {
              widget.goal.name = value;
              log('update for goal name: ${widget.goal.name}');
              widget.onSubmitted();
            }),
        if (widget.controls != null) widget.controls!,
      ],
    );
  }
}

class GoalSlideType extends StatefulWidget {
  const GoalSlideType({
    super.key,
    required this.goal,
    this.controls,
    required this.onSubmitted,
  });

  final Goal goal;
  final Widget? controls;
  final void Function() onSubmitted;

  @override
  State<GoalSlideType> createState() => _GoalSlideTypeState();
}

class _GoalSlideTypeState extends State<GoalSlideType> {
  @override
  Widget build(BuildContext context) {
    final goalTypeSet = <GoalType>{};
    if (widget.goal.goalType != null) {
      goalTypeSet.add(widget.goal.goalType!);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text("What best describes your goal?"),
        SegmentedButton<GoalType>(
          segments: <ButtonSegment<GoalType>>[
            ...GoalType.values.map(
              (goalType) => ButtonSegment<GoalType>(
                icon: Icon(goalType.icon),
                label: Text(goalType.description),
                value: goalType,
              ),
            ),
          ],
          selected: goalTypeSet,
          showSelectedIcon: false,
          emptySelectionAllowed: true,
          onSelectionChanged: (Set<GoalType> values) {
            widget.goal.goalType = values.first;
            log('update for goal type: ${widget.goal.goalType}');
            widget.onSubmitted();
          },
        ),
        if (widget.controls != null) widget.controls!,
      ],
    );
  }
}

class GoalSlideTasks extends StatefulWidget {
  const GoalSlideTasks({
    super.key,
    required this.goal,
    this.controls,
    required this.onSubmitted,
  });

  final Goal goal;
  final Widget? controls;
  final void Function() onSubmitted;

  @override
  State<GoalSlideTasks> createState() => _GoalSlideTasksState();
}

class _GoalSlideTasksState extends State<GoalSlideTasks> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text("List the tasks needed to accomplish your goal:"),
        TaskList(goal: widget.goal),
        if (widget.controls != null) widget.controls!,
      ],
    );
  }
}
