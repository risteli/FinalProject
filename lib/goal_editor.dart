import 'dart:developer';

import 'package:final_project/database.dart';
import 'package:final_project/repository/goals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/collections.dart';
import 'models/models.dart';
import 'widgets/task_widget.dart';

class GoalEditor extends StatefulWidget {
  const GoalEditor({
    super.key,
  });

  @override
  State<GoalEditor> createState() => _GoalEditorState();
}

class _GoalEditorState extends State<GoalEditor> {
  final nameController = TextEditingController();

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

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 28.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Consumer<GoalsModel>(
            builder: (context, goals, _) => ListView(
              children: [
                Text("Describe your goal.", style: TextStyle(fontSize: 24)),
                SizedBox(height: 8),
                Text("What do you want to accomplish?",
                    style: TextStyle(fontSize: 12)),
                TextField(
                  controller: nameController,
                  onSubmitted: (value) {
                    goal.name = value;
                    updateGoal();
                  },
                ),
                SizedBox(height: 16),
                Text("What best describes your goal?",
                    style: TextStyle(fontSize: 12)),
                SizedBox(height: 12),
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
                SizedBox(height: 16),
                Text("Which tools could be useful to progress on your goal?",
                    style: TextStyle(fontSize: 12)),
                SizedBox(height: 12),
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
                  onSelectionChanged: (Set<ToolType> values) {
                    log('update for tool type: ${values.first}');
                    goal.tool = values;
                    updateGoal();
                  },
                ),
                SizedBox(height: 16),
                Text("List the tasks needed to accomplish your goal:",
                    style: TextStyle(fontSize: 12)),
                SizedBox(height: 8),
                TaskList(tasks: goal.tasks)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
