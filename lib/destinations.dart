import 'package:flutter/material.dart';

class Destination {
  const Destination(this.icon, this.label);
  final IconData icon;
  final String label;
}

const List<Destination> destinations = <Destination>[
  Destination(Icons.sports_score_outlined, 'Goals'),
  Destination(Icons.schedule_outlined, 'Time'),
  Destination(Icons.emoji_events_outlined, 'Achievements'),
  Destination(Icons.settings_outlined, 'Settings'),
];
