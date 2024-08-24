import 'dart:developer';

import 'package:final_project/panels/goals/wizard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repository/database.dart';
import '../../models/roots.dart';

import '../../repository/goals.dart';
import '../../widgets/app_panels.dart';
import 'goal_tile.dart';
import '../../widgets/search_bar.dart' as search_bar;

class GoalBrowserView extends StatefulWidget {
  const GoalBrowserView({
    super.key,
    required this.goalsModel,
    required this.onSelected,
    this.selectedIndex,
  });

  final GoalsModel goalsModel;
  final Function(BuildContext context, int) onSelected;
  final int? selectedIndex;

  @override
  State<GoalBrowserView> createState() => _GoalBrowserViewState();
}

class _GoalBrowserViewState extends State<GoalBrowserView> {
  @override
  Widget build(BuildContext context) {
    log('building _GoalBrowserViewState ${widget.selectedIndex}');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        children: [
          const SizedBox(height: 8),
          const search_bar.SearchBar(),
          const SizedBox(height: 8),
          GoalBrowserList(
            goalsModel: widget.goalsModel,
            onSelected: widget.onSelected,
            selectedIndex: widget.selectedIndex,
          ),
        ],
      ),
    );
  }
}

class GoalBrowserList extends StatefulWidget {
  const GoalBrowserList({
    super.key,
    required this.goalsModel,
    required this.onSelected,
    this.selectedIndex,
  });

  final GoalsModel goalsModel;
  final Function(BuildContext context, int) onSelected;
  final int? selectedIndex;

  @override
  State<GoalBrowserList> createState() => _GoalBrowserListState();
}

class _GoalBrowserListState extends State<GoalBrowserList> {
  @override
  Widget build(BuildContext context) {
    final goalsRepo = GoalsRepo();

    log('building GoalBrowserList ${widget.goalsModel.items} ${widget.selectedIndex}');

    return ReorderableListView(
      shrinkWrap: true,
      onReorder: (int oldIndex, int newIndex) {
        log('reorder $oldIndex to $newIndex');
        setState(() => widget.goalsModel.move(oldIndex, newIndex));
        goalsRepo.updateGoals(widget.goalsModel);
      },
      children: List.generate(
        widget.goalsModel.items.length,
        (index) {
          return Padding(
            key: Key('goal-${index}'),
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GoalTile(
              goal: widget.goalsModel.items[index],
              onSelected: () => widget.onSelected(context, index),
              isSelected: widget.selectedIndex == index,
            ),
          );
        },
      ),
    );
  }
}
