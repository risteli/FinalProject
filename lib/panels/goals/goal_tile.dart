import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';

class GoalTile extends StatefulWidget {
  const GoalTile({
    super.key,
    required this.goal,
    required this.isSelected,
    required this.onSelected,
    required this.onDelete,
  });

  final bool isSelected;
  final void Function() onSelected;
  final void Function() onDelete;
  final Goal goal;

  @override
  State<GoalTile> createState() => _GoalTileState();
}

class _GoalTileState extends State<GoalTile> {
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;

  Color get _surfaceColor => switch (widget) {
        GoalTile(isSelected: true) => Color.alphaBlend(
            _colorScheme.primary.withOpacity(0.50),
            _colorScheme.surface,
          ),
        _ => Color.alphaBlend(
            _colorScheme.primary.withOpacity(0.20),
            _colorScheme.surface,
          ),
      };

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.goal.id?.toString() ?? 'new-task'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        widget.onDelete();
      },
      background: Container(
        color: Colors.redAccent,
        alignment: AlignmentDirectional.centerEnd,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.delete_forever),
        ),
      ),
      child: GestureDetector(
        onTap: widget.onSelected,
        child: Card(
          elevation: 0,
          color: _surfaceColor,
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _GoalContent(
                goal: widget.goal,
                isSelected: widget.isSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalContent extends StatefulWidget {
  const _GoalContent({
    super.key,
    required this.goal,
    this.isSelected = false,
  });

  final Goal goal;
  final bool isSelected;

  @override
  State<_GoalContent> createState() => _GoalContentState();
}

class _GoalContentState extends State<_GoalContent> {
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;
  late final textStyle = widget.isSelected
      ? _textTheme.labelMedium
          ?.copyWith(color: _colorScheme.onSecondaryContainer)
      : _textTheme.labelMedium?.copyWith(color: _colorScheme.onSurface);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: 1 / 6,
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
              const SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.goal.name ?? "",
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: textStyle?.copyWith(fontSize: 16.0),
                    ),
                    if (widget.goal.deadline != null)
                      Text(
                        'Deadline for this task: ${DateFormat.yMMMEd().format(widget.goal.deadline!)}',
                        style: textStyle,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
