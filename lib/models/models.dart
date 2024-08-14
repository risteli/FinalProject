import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Goal {
  Goal({
    required this.name,
    required this.goalType,
    this.tasks = const [],
  });

  int? id;
  late String name;
  GoalType? goalType;
  Set<ToolType> tool = {};
  List<Task> tasks = [];

  Map<String, Object?> toMap() {
    log(ToolType.values.byName("notes").name);
    return {
      'name': name,
      'type': goalType?.name,
      'tool': tool.map((v) => v.name).join(','),
    };
  }

  Goal.fromMap(Map<String, Object?> map) {
    id = map['id'] as int?;
    name = map['name'] as String;
    goalType = GoalType.values.byName(map['type'] as String);

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

    return "Goal(id=$id, $name, ${goalType?.name}, $tasksList)";
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
  Task({required this.name, this.estimation});

  late String name;

  int? id;
  int? goalId;
  Duration? estimation;

  Map<String, Object?> toMap() {
    return {
      'goal_id': goalId,
      'name': name,
      'estimation': estimation?.inSeconds,
    };
  }

  Task.fromMap(Map<String, Object?> map) {
    id = map['id'] as int?;
    goalId = map['goal_id'] as int?;
    name = map['name'] as String;
    var est = map['estimation'] as int?;

    if (est != null) {
      estimation = Duration(seconds: est!);
    }
  }

  @override
  String toString() {
    return "Task(id=$id, goal_id=${goalId}, $name)";
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
