import 'dart:developer';

import 'package:flutter/material.dart';

import 'editor.dart';
import '../../widgets/app_list_detail.dart'; // Add import
import 'browser.dart';

class GoalsPanel extends StatelessWidget {
  const GoalsPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppListDetail(
      one: GoalBrowserView(),
      two: GoalEditor(),
    );
  }
}
