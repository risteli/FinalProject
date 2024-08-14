import 'dart:developer';

import 'package:flutter/material.dart';

class CheckButton extends StatefulWidget {
  const CheckButton({
    super.key,
    required this.enabledIcon,
    required this.disabledIcon,
  });

  final IconData enabledIcon;
  final IconData disabledIcon;

  @override
  State<CheckButton> createState() => _CheckButtonState();
}

class _CheckButtonState extends State<CheckButton> {
  bool state = false;
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;

  Icon get icon {
    return Icon(
      state ? widget.enabledIcon: widget.disabledIcon,
      color: Colors.grey,
      size: 20,
    );
  }

  void _toggle() {
    setState(() {
      log('now $state');
      state = !state;
    });
  }

  double get turns => state ? 1 : 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: turns,
      curve: Curves.decelerate,
      duration: const Duration(milliseconds: 300),
      child: FloatingActionButton(
        elevation: 0,
        shape: const CircleBorder(),
        backgroundColor: _colorScheme.surface,
        onPressed: () => _toggle(),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: icon,
        ),
      ),
    );
  }
}
