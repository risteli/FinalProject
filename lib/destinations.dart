import 'package:flutter/material.dart';

class Destination {
  const Destination({
    required this.icon,
    required this.label,
    required this.widget,
    this.hasAddAction = false,
  });

  final IconData icon;
  final String label;
  final Widget widget;
  final bool hasAddAction;
}
