import 'package:flutter/material.dart';

import '../models/fixture.dart' as data;
import '../models/models.dart';
import 'goal_widget.dart';
import 'search_bar.dart' as search_bar;

class GoalListView extends StatelessWidget {
  const GoalListView({
    super.key,
    this.selectedIndex,
    this.onSelected,
  });

  final int? selectedIndex;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        children: [
          const SizedBox(height: 8),
          search_bar.SearchBar(),
          const SizedBox(height: 8),
          ...List.generate(
            data.goals.length,
                (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GoalWidget(
                  goal: data.goals[index],
                  onSelected: onSelected != null
                      ? () {
                    onSelected!(index);
                  }
                      : null,
                  isSelected: selectedIndex == index,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
