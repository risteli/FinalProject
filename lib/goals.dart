import 'dart:developer';

import 'package:flutter/material.dart';

import 'widgets/app_list_detail.dart'; // Add import
import 'widgets/goal_list_view.dart';
import 'widgets/task_list_view.dart'; // Add import

class GoalsEditor extends StatelessWidget {
  const GoalsEditor({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppListDetail(
      one: GoalListView(),
      two: TaskListView(),
    );
  }
}
