import 'dart:developer';

import 'package:final_project/panels/goals/wizard.dart';
import 'package:flutter/material.dart';

import 'editor.dart';
import '../../widgets/app_list_detail.dart'; // Add import
import 'browser.dart';

class GoalsPanel extends StatelessWidget {
  const GoalsPanel({
    super.key,
    this.create = false,
  });

  final bool create;

  @override
  Widget build(BuildContext context) {
    return AppListDetail(
      one: GoalBrowserView(),
      two: GoalWizard(),
    );
  }
}
