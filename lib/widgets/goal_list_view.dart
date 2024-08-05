import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/collections.dart';

import 'goal_widget.dart';
import 'search_bar.dart' as search_bar;

class GoalListView extends StatelessWidget {
  const GoalListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Consumer<GoalsModel>(
        builder: (context, goals, _) => ListView(
          children: [
            const SizedBox(height: 8),
            search_bar.SearchBar(),
            const SizedBox(height: 8),
            ...List.generate(
              goals.items.length,
              (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: GoalWidget(
                    goal: goals.items[index],
                    onSelected: () => goals.select = index,
                    isSelected: goals.selected == index,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
