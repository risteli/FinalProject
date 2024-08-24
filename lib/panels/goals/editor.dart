import 'dart:developer';

import 'package:final_project/panels/goals/wizard.dart';
import 'package:final_project/repository/database.dart';
import 'package:final_project/repository/goals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/roots.dart';
import '../../models/models.dart';
import 'task_editor.dart';

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

    // navigation wizard?

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 28.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Consumer<GoalsModel>(
            builder: (context, goals, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Describe your goal.", style: TextStyle(fontSize: 24)),
                SizedBox(height: 8),
                GoalSlideName(
                  goal: goal,
                  onSubmitted: updateGoal,
                ),
                SizedBox(height: 16),
                GoalSlideType(
                  goal: goal,
                  onSubmitted: updateGoal,
                ),
                SizedBox(height: 16),
                GoalSlideTool(
                  goal: goal,
                  onSubmitted: updateGoal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
