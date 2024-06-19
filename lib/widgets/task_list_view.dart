import 'package:flutter/material.dart';

import '../models/fixture.dart' as data;
import 'task_widget.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ListView(
        children: [
          const SizedBox(height: 8),
          ...List.generate(data.goals[0].tasks.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TaskWidget(
                task: data.goals[0].tasks[index],
                isPreview: false,
                isThreaded: true,
                showHeadline: index == 0,
              ),
            );
          }),
        ],
      ),
    );
  }
}
