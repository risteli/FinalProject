import 'package:flutter/material.dart';

import '../destinations.dart';
import 'app_floating_action_button.dart'; // Add this import

class AppNavigationRail extends StatefulWidget {
  const AppNavigationRail({
    super.key,
    required this.backgroundColor,
    required this.selectedIndex,
    this.onDestinationSelected,
    this.onCreateButtonPressed,
  });

  final Color backgroundColor;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final Function()? onCreateButtonPressed;

  @override
  State<AppNavigationRail> createState() => _AppNavigationRailState();
}

class _AppNavigationRailState extends State<AppNavigationRail> {
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: widget.selectedIndex,
      backgroundColor: widget.backgroundColor,
      onDestinationSelected: widget.onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      leading: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppFloatingActionButton(
            elevation: 0,
            onPressed: widget.onCreateButtonPressed,
            child: const Icon(Icons.add),
          ),
        ],
      ),
      groupAlignment: -0.8,
      destinations: destinations.map((d) {
        return NavigationRailDestination(
          icon: Icon(d.icon),
          label: Text(d.label),
        );
      }).toList(),
    );
  }
}
