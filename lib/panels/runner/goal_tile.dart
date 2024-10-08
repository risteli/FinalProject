import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';

class GoalsRunnerGoalTile extends StatefulWidget {
  const GoalsRunnerGoalTile({
    super.key,
    required this.goal,
    required this.isSelected,
    required this.onSelected,
  });

  final bool isSelected;
  final void Function() onSelected;
  final Goal goal;

  @override
  State<GoalsRunnerGoalTile> createState() => _GoalsRunnerGoalTileState();
}

class _GoalsRunnerGoalTileState extends State<GoalsRunnerGoalTile> {
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;
  late Color unselectedColor = Color.alphaBlend(
    _colorScheme.primary.withOpacity(0.08),
    _colorScheme.surface,
  );

  Color get _surfaceColor => switch (widget) {
        GoalsRunnerGoalTile(isSelected: true) => _colorScheme.primaryContainer,
        _ => unselectedColor,
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
          widget.onSelected();
      },
      child: Card(
        elevation: 0,
        color: _surfaceColor,
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _TileContent(
              goal: widget.goal,
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
    required this.goal,
    this.isSelected = false,
  });

  final Goal goal;
  final bool isSelected;

  @override
  State<_TileContent> createState() => _TileContentState();
}

class _TileContentState extends State<_TileContent> {
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  TextStyle? get contentTextStyle => switch (widget) {
    _TileContent(isSelected: true) => _textTheme.bodyMedium
            ?.copyWith(color: _colorScheme.onPrimaryContainer),
        _ =>
          _textTheme.bodyMedium?.copyWith(color: _colorScheme.onSurfaceVariant),
      };

  @override
  Widget build(BuildContext context) {
    final statusCount = widget.goal.countTasksByStatus();
    final int totalTasks = widget.goal.tasks.length;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: totalTasks > 0? (statusCount[TaskStatusValue.done]! / totalTasks): 0,
                      color: _colorScheme.primary.withOpacity(0.80),
                      backgroundColor: _colorScheme.primary.withOpacity(0.40),
                    ),
                    Center(
                      child: Icon(
                        widget.goal.goalType?.icon,
                        color: _colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.goal.name ?? "",
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: widget.isSelected
                            ? _textTheme.labelMedium?.copyWith(
                                color: _colorScheme.onSecondaryContainer, fontSize: 16)
                            : _textTheme.labelMedium
                                ?.copyWith(color: _colorScheme.onSurface, fontSize: 16),
                      ),
                      if (widget.goal.deadline != null)
                      Text(
                        'Deadline: ${DateFormat.yMMMEd().format(widget.goal.deadline!)}',
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: widget.isSelected
                            ? _textTheme.labelMedium?.copyWith(
                            color: _colorScheme.onSecondaryContainer, fontSize: 11)
                            : _textTheme.labelMedium
                            ?.copyWith(color: _colorScheme.onSurface, fontSize: 11),
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
