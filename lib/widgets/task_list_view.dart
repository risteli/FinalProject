import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/collections.dart';
import 'task_widget.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Consumer<GoalsModel>(
        builder: (context, goals, _) => ListView(
          children: goals.selected == null ? []: [
            const SizedBox(height: 8),
            ...List.generate(goals.items[goals.selected!].tasks.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TaskWidget(
                  task: goals.items[goals.selected!].tasks[index],
                  isPreview: false,
                  isThreaded: true,
                  showHeadline: index == 0,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
