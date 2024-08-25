import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  late Color unselectedColor = Color.alphaBlend(
    _colorScheme.primary.withOpacity(0.08),
    _colorScheme.surface,
  );

  Color get _surfaceColor => switch (widget) {
        GoalTile(isSelected: true) => _colorScheme.primaryContainer,
        _ => unselectedColor,
      };

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.goal.id!.toString()),
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
      child: Card(
        elevation: 0,
        color: _surfaceColor,
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GoalContent(
              goal: widget.goal,
              onSelected: widget.onSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class GoalContent extends StatefulWidget {
  const GoalContent({
    super.key,
    required this.goal,
    required this.onSelected,
    this.isSelected = false,
  });

  final Goal goal;
  final void Function()? onSelected;
  final bool isSelected;

  @override
  State<GoalContent> createState() => _GoalContentState();
}

class _GoalContentState extends State<GoalContent> {
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  Widget get contentSpacer => SizedBox(height: 2);

  String get activeTasksCounterLabel {
    return 'Active tasks: ${widget.goal.tasks.length}';
  }

  TextStyle? get contentTextStyle => switch (widget) {
        GoalContent(isSelected: true) => _textTheme.bodyMedium
            ?.copyWith(color: _colorScheme.onPrimaryContainer),
        _ =>
          _textTheme.bodyMedium?.copyWith(color: _colorScheme.onSurfaceVariant),
      };

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
                if (constraints.maxWidth - 200 > 0) ...[
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 6.0)),
                ],
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
                                color: _colorScheme.onSecondaryContainer)
                            : _textTheme.labelMedium
                                ?.copyWith(color: _colorScheme.onSurface),
                      ),
                      Text(
                        activeTasksCounterLabel,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: widget.isSelected
                            ? _textTheme.labelMedium?.copyWith(
                                color: _colorScheme.onSecondaryContainer)
                            : _textTheme.labelMedium?.copyWith(
                                color: _colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  child: Icon(Icons.chevron_right),
                  onTap: widget.onSelected,
                )
              ],
            );
          }),
        ],
      ),
    );
  }
}
