import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/collections.dart';

class GoalEditor extends StatelessWidget {
  const GoalEditor({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Consumer<GoalsModel>(
        builder: (context, goals, _) => ListView(
          children: const [
            SizedBox(height: 8),
            Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Describe your goal.", style: TextStyle(fontSize: 24)),
                    Text("What do you want to accomplish?",
                        style: TextStyle(fontSize: 12)),
                    TextField(),
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
