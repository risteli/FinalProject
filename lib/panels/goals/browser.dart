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
    this.onSelected,
  });

  final Function(BuildContext context)? onSelected;

  @override
  State<GoalBrowserView> createState() => _GoalBrowserViewState();
}

class _GoalBrowserViewState extends State<GoalBrowserView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        children: [
          const SizedBox(height: 8),
          search_bar.SearchBar(),
          const SizedBox(height: 8),
          Consumer<GoalsModel>(
            builder: (context, goals, _) => GoalBrowserList(
              goals: goals,
              onSelected: widget.onSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class GoalBrowserList extends StatefulWidget {
  const GoalBrowserList({
    super.key,
    required this.goals,
    this.onSelected,
  });

  final GoalsModel goals;
  final Function(BuildContext context)? onSelected;

  @override
  State<GoalBrowserList> createState() => _GoalBrowserListState();
}

class _GoalBrowserListState extends State<GoalBrowserList> {
  @override
  Widget build(BuildContext context) {
    final goalsRepo = GoalsRepo(Provider.of<AppDatabase>(context));

    return ReorderableListView(
      shrinkWrap: true,
      onReorder: (int oldIndex, int newIndex) {
        log('reorder $oldIndex to $newIndex');
        setState(() => widget.goals.move(oldIndex, newIndex));
        goalsRepo.updateGoals(widget.goals);
      },
      children: List.generate(
        widget.goals.items.length,
        (index) {
          return Padding(
            key: Key('goal-${index}'),
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GoalTile(
              goal: widget.goals.items[index],
              onSelected: () {
                widget.goals.select = index;
                if (widget.onSelected != null) {
                  widget.onSelected!(context);
                }
              },
              isSelected: widget.goals.selected == index,
            ),
          );
        },
      ),
    );
  }
}
