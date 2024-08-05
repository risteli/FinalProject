import 'dart:ui';

import 'package:flutter/material.dart';

class AppFloatingActionButton extends StatefulWidget {
  const AppFloatingActionButton({
    super.key,
    this.elevation,
    this.onPressed,
    this.child,
  });

  final VoidCallback? onPressed;
  final Widget? child;
  final double? elevation;

  @override
  State<AppFloatingActionButton> createState() =>
      _AppFloatingActionButton();
}

class _AppFloatingActionButton extends State<AppFloatingActionButton> {
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: widget.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),

      backgroundColor: _colorScheme.tertiaryContainer,
      foregroundColor: _colorScheme.onTertiaryContainer,
      onPressed: widget.onPressed,
      child: widget.child,
    );
  }
}
