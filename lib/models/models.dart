import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Goal {
  Goal({
    this.name = '',
    this.goalType,
    this.tasks = const [],
  });

  int? id;
  late String name;
  GoalType? goalType;
  Set<ToolType> tool = {};
  List<Task> tasks = [];
  int position = 0;

  Map<String, Object?> toMap() {
    log(ToolType.values.byName("notes").name);
    return {
      'name': name,
      'type': goalType?.name,
      'position': position,
      'tool': tool.map((v) => v.name).join(','),
    };
  }

  Goal.fromMap(Map<String, Object?> map) {
    id = map['id'] as int?;
    name = map['name'] as String;
    position = map['position'] as int;
    goalType = map['type'] == null
        ? null
        : GoalType.values.byName(map['type'] as String);

    var toolString = map['tool'] as String?;

    tool = {};
    if (toolString != null) {
      for (var toolName in toolString.split(',')) {
        if (toolName == '') {
          continue;
        }

        var toolRead;
        try {
          toolRead = ToolType.values.byName(toolName);
        } on ArgumentError {
          log('invalid tool value "$toolName" from ${ToolType.values}');
          continue;
        }

        tool.add(toolRead);
      }
    }
  }

  @override
  String toString() {
    String tasksList = tasks.join(',');

    return "Goal(id=$id, p=$position, $name, ${goalType?.name}, $tasksList)";
  }
}

enum GoalType {
  learning(description: "Learn", icon: Icons.school),
  building(description: "Build", icon: Icons.construction),
  todo(description: "To-do", icon: Icons.list);

  const GoalType({required this.description, required this.icon});

  final IconData icon;
  final String description;
}

class Task {
  Task({required this.name, this.estimation, this.goalId, this.position = 0});

  late String name;

  int? id;
  int? goalId;
  Duration? estimation;
  int position = 0;
  bool repeatable = false;

  Map<String, Object?> toMap() {
    return {
      'goal_id': goalId,
      'name': name,
      'position': position,
      'repeatable': repeatable ? 1 : 0,
      'estimation': estimation?.inSeconds,
    };
  }

  Task.fromMap(Map<String, Object?> map) {
    id = map['id'] as int?;
    goalId = map['goal_id'] as int?;
    name = map['name'] as String;
    position = map['position'] as int;
    repeatable = (map['repeatable'] as int) == 1;
    var est = map['estimation'] as int?;

    if (est != null) {
      estimation = Duration(seconds: est!);
    }
  }

  @override
  String toString() {
    return "Task(id=$id, p=$position, goal_id=${goalId}, $name)";
  }
}

enum ToolType {
  stopwatch(description: "Stopwatch", icon: Icons.timer),
  notes(description: "Notes", icon: Icons.note);

  const ToolType({required this.description, required this.icon});

  final IconData icon;
  final String description;
}

abstract class Tool {
  ToolType get toolType;
}

class StopwatchTool implements Tool {
  late Stopwatch running = Stopwatch();

  @override
  ToolType get toolType => ToolType.stopwatch;
}
