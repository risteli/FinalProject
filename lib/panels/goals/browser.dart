import 'dart:developer';

import 'package:final_project/panels/goals/wizard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repository/database.dart';
import '../../models/roots.dart';

import '../../repository/goals.dart';
import '../../widgets/app_list_detail.dart';
import 'goal_tile.dart';
import '../../widgets/search_bar.dart' as search_bar;

class GoalBrowserView extends StatefulWidget {
  const GoalBrowserView({
    super.key,
  });

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
            builder: (context, goals, _) => GoalBrowserList(goals: goals),
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
  });

  final GoalsModel goals;

  @override
  State<GoalBrowserList> createState() => _GoalBrowserListState();
}

class _GoalBrowserListState extends State<GoalBrowserList> {
  @override
  Widget build(BuildContext context) {
    final goalsRepo = GoalsRepo(Provider.of<AppDatabase>(context));
    final appLayout = Provider.of<AppLayout>(context);

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
                if (appLayout.singlePanel) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider<GoalsModel>.value(
                          value: widget.goals,
                          child: GoalWizard(),
                      ),
                    ),
                  );
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
