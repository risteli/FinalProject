import 'dart:developer';

import 'package:flutter/material.dart';

import 'goal_editor.dart';
import 'widgets/app_list_detail.dart'; // Add import
import 'widgets/goal_list_view.dart';

class GoalsBrowser extends StatelessWidget {
  const GoalsBrowser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppListDetail(
      one: GoalListView(),
      two: GoalEditor(),
    );
  }
}
