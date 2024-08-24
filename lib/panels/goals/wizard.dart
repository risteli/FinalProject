import 'dart:developer';

import 'package:final_project/repository/database.dart';
import 'package:final_project/repository/goals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/roots.dart';
import '../../models/models.dart';
import 'task_editor.dart';

class GoalWizard extends StatefulWidget {
  const GoalWizard({
    super.key,
    this.create = false,
  });

  final bool create;

  @override
  State<GoalWizard> createState() => _GoalWizardState();
}

class _GoalWizardState extends State<GoalWizard> {
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _step = 1;

  @override
  Widget build(BuildContext context) {
    final goalsRepo = GoalsRepo(Provider.of<AppDatabase>(context));
    final goalsModel = Provider.of<GoalsModel>(context);
    final goal =
        widget.create ? Goal() : goalsModel.items[goalsModel.selected!];

    void updateGoal() => setState(() {
          goalsRepo.update(goal).then((_) => log('goal update completed'));
          return;
        });

    log('using form $_formKey');

    Widget wizardControls = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (_step > 1)
          ElevatedButton(
            onPressed: () => setState(() => _step--),
            child: const Text('prev'),
          ),
        if (_step < 4)
          ElevatedButton(
            onPressed: () => setState(() => _step++),
            child: const Text('next'),
            //style: ElevatedButton.styleFrom(backgroundColor: _colorScheme.secondary, textStyle: TextStyle(color: _colorScheme.surface)),
          ),
        if (_step == 4)
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('done'),
          ),
      ],
    );

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        title: const Text('Here you can define your goal'),
      ),
      body: Card(
        color: _backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Form(
            key: _formKey,
            child: Consumer<GoalsModel>(
              builder: (context, goals, _) => switch (_step) {
                1 => GoalSlideName(
                    goal: goal,
                    controls: wizardControls,
                    onSubmitted: updateGoal,
                  ),
                2 => GoalSlideType(
                    goal: goal,
                    controls: wizardControls,
                    onSubmitted: updateGoal,
                  ),
                3 => GoalSlideTool(
                    goal: goal,
                    controls: wizardControls,
                    onSubmitted: updateGoal,
                  ),
                4 => GoalSlideTasks(
                    goal: goal,
                    controls: wizardControls,
                    onSubmitted: updateGoal,
                  ),
                _ => const Text('invalid state'),
              },
            ),
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

class GoalSlideTool extends StatefulWidget {
  const GoalSlideTool({
    super.key,
    required this.goal,
    this.controls,
    required this.onSubmitted,
  });

  final Goal goal;
  final Widget? controls;
  final void Function() onSubmitted;

  @override
  State<GoalSlideTool> createState() => _GoalSlideToolState();
}

class _GoalSlideToolState extends State<GoalSlideTool> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text("Which tools could be useful to progress on your goal?"),
        SegmentedButton<ToolType>(
          segments: <ButtonSegment<ToolType>>[
            ...ToolType.values.map(
              (toolType) => ButtonSegment<ToolType>(
                icon: Icon(toolType.icon),
                label: Text(toolType.description),
                value: toolType,
              ),
            ),
          ],
          selected: widget.goal.tool,
          showSelectedIcon: false,
          multiSelectionEnabled: true,
          emptySelectionAllowed: true,
          onSelectionChanged: (Set<ToolType> values) {
            widget.goal.tool = values;
            log('update for tool type: ${widget.goal.tool}');
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
