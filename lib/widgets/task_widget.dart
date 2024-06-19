import 'package:flutter/material.dart';
import '../models/models.dart';
import 'check_button.dart';

enum EmailType {
  preview,
  threaded,
  primaryThreaded,
}

class TaskWidget extends StatefulWidget {
  const TaskWidget({
    super.key,
    required this.task,
    this.isSelected = false,
    this.isPreview = true,
    this.isThreaded = false,
    this.showHeadline = false,
    this.onSelected,
  });

  final bool isSelected;
  final bool isPreview;
  final bool showHeadline;
  final bool isThreaded;
  final void Function()? onSelected;
  final Task task;

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;
  late Color unselectedColor = Color.alphaBlend(
    _colorScheme.primary.withOpacity(0.08),
    _colorScheme.surface,
  );

  Color get _surfaceColor => switch (widget) {
    TaskWidget(isPreview: false) => _colorScheme.surface,
    TaskWidget(isSelected: true) => _colorScheme.primaryContainer,
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
            TaskContent(
              task: widget.task,
              isPreview: widget.isPreview,
              isThreaded: widget.isThreaded,
              isSelected: widget.isSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class TaskContent extends StatefulWidget {
  const TaskContent({
    super.key,
    required this.task,
    required this.isPreview,
    required this.isThreaded,
    required this.isSelected,
  });

  final Task task;
  final bool isPreview;
  final bool isThreaded;
  final bool isSelected;

  @override
  State<TaskContent> createState() => _TaskContentState();
}

class _TaskContentState extends State<TaskContent> {
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  Widget get contentSpacer => SizedBox(height: widget.isThreaded ? 20 : 2);

  TextStyle? get contentTextStyle => switch (widget) {
    TaskContent(isThreaded: true) => _textTheme.bodyLarge,
    TaskContent(isSelected: true) => _textTheme.bodyMedium
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
                        widget.task.name,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: widget.isSelected
                            ? _textTheme.labelMedium?.copyWith(
                            color: _colorScheme.onSecondaryContainer)
                            : _textTheme.labelMedium
                            ?.copyWith(color: _colorScheme.onSurface),
                      ),
                      Text(
                        'Estimation: ' + widget.task.estimation.toString(),
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
                if (constraints.maxWidth - 200 > 0) ...[
                  const CheckButton(),
                ]
              ],
            );
          }),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.task.name,
                maxLines: widget.isPreview ? 2 : 100,
                overflow: TextOverflow.ellipsis,
                style: contentTextStyle,
              ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
