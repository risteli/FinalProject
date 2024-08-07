import 'dart:developer';

import 'package:final_project/goals.dart';
import 'package:flutter/material.dart';

import 'widgets/app_floating_action_button.dart';
import 'widgets/app_bottom_navigation_bar.dart';
import 'widgets/app_navigation_rail.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppNavigationRail(
            selectedIndex: 0,
            backgroundColor: _backgroundColor,
            onDestinationSelected: (index) {
              setState(() {
                log('selecting navigation $index');
              });
            },
          ),
          Expanded(
            child: Container(
              // this should be replaced by navigation!
              color: _backgroundColor,
              child: GoalsEditor(),
            ),
          ),
        ],
      ),
      floatingActionButton: AppFloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          setState(() {
            log('selecting navigation $index');
          });
        },
      ),
    );
  }
}
