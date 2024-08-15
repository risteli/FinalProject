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
  });

  @override
  State<GoalWizard> createState() => _GoalWizardState();
}

class _GoalWizardState extends State<GoalWizard> {
  final nameController = TextEditingController();
  int step = 1;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goalsRepo = GoalsRepo(Provider.of<AppDatabase>(context));
    final goalsModel = Provider.of<GoalsModel>(context);
    final goal = goalsModel.items[goalsModel.selected!];

    void updateGoal() => setState(() {
          goalsRepo.update(goal).then((_) => log('goal update completed'));
          return;
        });

    nameController.text = goal.name ?? "";

    final goalTypeSet = <GoalType>{};
    if (goal.goalType != null) {
      goalTypeSet.add(goal.goalType!);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Describe your goal')),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 28.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Consumer<GoalsModel>(
              builder: (context, goals, _) => Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: switch (step) {
                      1 => <Widget>[
                          Text(
                            "What do you want to accomplish?",
                            style: TextStyle(fontSize: 12),
                          ),
                          TextField(
                            controller: nameController,
                            onSubmitted: (value) {
                              goal.name = value;
                              updateGoal();
                            },
                          ),
                        ],
                      2 => <Widget>[
                          Text("What best describes your goal?",
                              style: TextStyle(fontSize: 12)),
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
                            onSelectionChanged: (Set<GoalType> values) {
                              log('update for goal type: ${values.first}');
                              goal.goalType = values.first;
                              updateGoal();
                            },
                          ),
                        ],
                      3 => <Widget>[
                          Text(
                              "Which tools could be useful to progress on your goal?",
                              style: TextStyle(fontSize: 12)),
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
                            selected: goal.tool,
                            showSelectedIcon: false,
                            multiSelectionEnabled: true,
                            emptySelectionAllowed: true,
                            onSelectionChanged: (Set<ToolType> values) {
                              log('update for tool type: ${values.first}');
                              goal.tool = values;
                              updateGoal();
                            },
                          ),
                        ],
                      4 => <Widget>[
                          Text("List the tasks needed to accomplish your goal:",
                              style: TextStyle(fontSize: 12)),
                          TaskList(goal: goal)
                        ],
                      _ => <Widget>[Text('invalid state')],
                    } +
                    <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                        if (step > 1)
                          ElevatedButton(
                            onPressed: () => setState(() => step--),
                            child: const Text('prev'),
                          ),
                        if (step < 4)
                          ElevatedButton(
                            onPressed: () => setState(() => step++),
                            child: const Text('next'),
                          ),
                        if (step == 4)
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('done'),
                          ),
                      ])
                    ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
