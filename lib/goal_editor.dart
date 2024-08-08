import 'dart:developer';

import 'package:final_project/database.dart';
import 'package:final_project/repository/goals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/collections.dart';
import 'models/models.dart';

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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Consumer<GoalsModel>(
        builder: (context, goals, _) => ListView(
          children: [
            SizedBox(height: 8),
            Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    ...GoalType.values.map(
                      (goalType) => RadioListTile(
                        title: Text(goalType.description),
                        value: goalType,
                        groupValue: goal.goalType,
                        onChanged: (GoalType? value) {
                          log('update for $goalType: $value');
                          goal.goalType = value;
                          updateGoal();
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Text("Which tools could be useful to progress on your goal?",
                        style: TextStyle(fontSize: 12)),
                    ...ToolType.values.map(
                          (toolType) => CheckboxListTile(
                        title: Text(toolType.name),
                        value: goal.tool.contains(toolType),
                        onChanged: (bool? value) {
                          if (value == null || value == false) {
                            goal.tool.remove(toolType);
                          } else {
                            goal.tool.add(toolType);
                          }
                          updateGoal();
                        },
                      ),
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
