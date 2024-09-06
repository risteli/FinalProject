import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/models.dart';

class GoalsRunnerTaskTile extends StatefulWidget {
  const GoalsRunnerTaskTile({
    super.key,
    required this.task,
    required this.isSelected,
    required this.onSelected,
  });

  final bool isSelected;
  final void Function() onSelected;
  final Task task;

  @override
  State<GoalsRunnerTaskTile> createState() => _GoalsRunnerTaskTileState();
}

class _GoalsRunnerTaskTileState extends State<GoalsRunnerTaskTile> {
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;
  late Color unselectedColor = Color.alphaBlend(
    _colorScheme.primary.withOpacity(0.08),
    _colorScheme.surface,
  );

  Color get _surfaceColor => switch (widget) {
        GoalsRunnerTaskTile(isSelected: true) => _colorScheme.primaryContainer,
        _ => unselectedColor,
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onSelected,
      child: Card(
        elevation: 0,
        color: _surfaceColor,
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _TileContent(
              task: widget.task,
            ),
          ],
        ),
      ),
    );
  }
}

class _TileContent extends StatefulWidget {
  const _TileContent({
    super.key,
    required this.task,
    this.isSelected = false,
  });

  final Task task;
  final bool isSelected;

  @override
  State<_TileContent> createState() => _TileContentState();
}

class _TileContentState extends State<_TileContent> {
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: switch (widget.task.status?.status) {
                    TaskStatusValue.done => Icon(
                        Icons.done,
                        color: _colorScheme.primary,
                      ),
                    TaskStatusValue.stopped => Icon(
                      Icons.stop,
                      color: _colorScheme.primary,
                    ),
                    TaskStatusValue.ready => Icon(
                      Icons.not_started,
                      color: _colorScheme.primary,
                    ),
                    _ => Icon(
                      Icons.question_mark,
                      color: _colorScheme.primary,
                    ),
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.task.name ?? "",
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: widget.isSelected
                            ? _textTheme.labelMedium?.copyWith(
                                color: _colorScheme.onSecondaryContainer, fontSize: 16)
                            : _textTheme.labelMedium
                                ?.copyWith(color: _colorScheme.onSurface, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
