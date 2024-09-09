import 'dart:developer';

import 'package:final_project/repository/storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/roots.dart';
import '../../models/models.dart';
import 'task_editor.dart';

class GoalWizard extends StatefulWidget {
  GoalWizard({
    super.key,
    required this.storageRoot,
    this.goalIndex,
    this.appbar = false,
    required this.onDone,
  });

  final StorageRoot storageRoot;
  final int? goalIndex;
  final bool appbar;
  final Function() onDone;

  @override
  State<GoalWizard> createState() => _GoalWizardState();
}

class _GoalWizardState extends State<GoalWizard> {
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);
  static const TextStyle navButtonTextStyle = TextStyle(fontSize: 20);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int step = 1;

  @override
  Widget build(BuildContext context) {
    if (widget.goalIndex == null) {
      return const Card();
    }

    final goal = widget.storageRoot.goals[widget.goalIndex!];

    void persistGoal() {
      widget.storageRoot.updateGoalAt(widget.goalIndex!, goal);
      Storage.instance.updateGoals();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          switch (step) {
            1 => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Form(
                  key: _formKey,
                  child: _GoalSlideName(
                    goal: goal,
                    onSubmitted: persistGoal,
                  ),
                ),
              ),
            2 => _GoalSlideTasks(goal: goal),
            _ => const Text('invalid state'),
          },
          const Expanded(
            child: SizedBox(
              height: double.infinity,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (step == 1)
                    ElevatedButton(
                      onPressed: () => setState(() => step = 2),
                      child: const Text(
                        'Split this goal into tasks.',
                        style: navButtonTextStyle,
                      ),
                    ),
                  if (step == 2)
                    ElevatedButton(
                      onPressed: () => setState(() => step = 1),
                      child: const Text(
                        'Describe your goal.',
                        style: navButtonTextStyle,
                      ),
                      //style: ElevatedButton.styleFrom(backgroundColor: _colorScheme.secondary, textStyle: TextStyle(color: _colorScheme.surface)),
                    ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => widget.onDone(),
                    child: const Text(
                      'Done!',
                      style: navButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _GoalSlideName extends StatefulWidget {
  const _GoalSlideName({
    super.key,
    required this.goal,
    required this.onSubmitted,
  });

  final Goal goal;
  final void Function() onSubmitted;

  @override
  State<_GoalSlideName> createState() => _GoalSlideNameState();
}

class _GoalSlideNameState extends State<_GoalSlideName> {
  final nameController = TextEditingController();
  final deadlineController = TextEditingController();
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<DateTime?> _pickDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: widget.goal.deadline,
      firstDate: DateTime(2024, 7, 1),
      lastDate: DateTime(2099, 12, 31),
    );
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.goal.name ?? "";
    final goalTypeSet = <GoalType>{};
    if (widget.goal.goalType != null) {
      goalTypeSet.add(widget.goal.goalType!);
    }
    deadlineController.text = widget.goal.deadline == null ? "": DateFormat.yMMMEd().format(widget.goal.deadline!);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            "Describe your goal.",
            style: TextStyle(fontSize: 32.0, color: _colorScheme.onSurface),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            "Start planning your goals, task by task.",
            style: TextStyle(fontSize: 16.0, color: _colorScheme.onSurface),
          ),
        ),
        const SizedBox(height: 18),
        const Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Text('What do you want to accomplish?'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            widget.goal.name = value;
            widget.onSubmitted();
          },
        ),
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Text('What best describes your goal?'),
        ),
        const SizedBox(height: 8),
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
            widget.onSubmitted();
          },
        ),
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Text('Is there a deadline for this goal?'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: deadlineController,
          readOnly: true,
          onTap: () => _pickDate(context).then((deadline) {
            setState(() {
              widget.goal.deadline = deadline;
              widget.onSubmitted();
            });
          }),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class _GoalSlideTasks extends StatefulWidget {
  const _GoalSlideTasks({
    super.key,
    required this.goal,
  });

  final Goal goal;

  @override
  State<_GoalSlideTasks> createState() => _GoalSlideTasksState();
}

class _GoalSlideTasksState extends State<_GoalSlideTasks> {
  late final _colorScheme = Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1000,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "The tasks of this goal",
              style: TextStyle(fontSize: 32.0, color: _colorScheme.onSurface),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "Split this goal into tasks, make it simple!",
              style: TextStyle(fontSize: 16.0, color: _colorScheme.onSurface),
            ),
          ),
          Expanded(
            child: TaskList(goal: widget.goal),
          ),
        ],
      ),
    );
  }
}
