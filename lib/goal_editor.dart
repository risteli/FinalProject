import 'dart:developer';

import 'package:final_project/database.dart';
import 'package:final_project/repository/goals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/collections.dart';

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

    void updateGoal() => goalsRepo.update(goal).then((_) => log('goal update completed'));

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
