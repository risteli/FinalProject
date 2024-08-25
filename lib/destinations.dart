import 'package:flutter/material.dart';

class Destination {
  const Destination({
    required this.icon,
    required this.label,
    required this.widget,
  });

  final IconData icon;
  final String label;
  final Widget widget;
}
