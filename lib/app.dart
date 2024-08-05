import 'package:flutter/material.dart';

import 'widgets/app_list_detail.dart';          // Add import
import 'widgets/app_floating_action_button.dart';
import 'widgets/app_bottom_navigation_bar.dart';
import 'widgets/app_navigation_rail.dart';
import 'widgets/goal_list_view.dart';
import 'widgets/task_list_view.dart';                     // Add import


class App extends StatefulWidget {
  const App({
    super.key,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);

  int selectedIndex = 0;
  bool controllerInitialized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppNavigationRail(
            selectedIndex: selectedIndex,
            backgroundColor: _backgroundColor,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: Container(
              color: _backgroundColor,
              // Update from here ...
              child: AppListDetail(
                one: GoalListView(
                  selectedIndex: selectedIndex,
                  onSelected: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                ),
                two: const TaskListView(),
              ),
              // ... to here.
            ),
          ),
        ],
      ),
      floatingActionButton: AppFloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
