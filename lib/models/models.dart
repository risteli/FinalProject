import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Goal {
  Goal({
    this.name = '',
    this.goalType,
    List<Task>? tasks,
    this.position = 0,
    this.deadline,
  }) : tasks = tasks ?? [];

  int? id;
  late String name;
  GoalType? goalType;
  List<Task> tasks;
  int position = 0;
  DateTime? deadline;

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'type': goalType?.name,
      'position': position,
      'deadline': deadline?.millisecondsSinceEpoch,
    };
  }

  Goal.fromMap(Map<String, Object?> map) : tasks = [] {
    id = map['id'] as int?;
    name = map['name'] as String;
    position = map['position'] as int;
    goalType = map['type'] == null
        ? null
        : GoalType.values.byName(map['type'] as String);
    deadline = map['deadline'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(map['deadline'] as int);
  }

  Map<TaskStatusValue, int> countTasksByStatus() {
    Map<TaskStatusValue, int> count = {};
    for (var statusValue in TaskStatusValue.values) {
      count[statusValue] = 0;
    }

    for (var task in tasks) {
      if (task.status != null) {
        count[task.status!.status] = count[task.status!.status]! + 1;
      }
    }

    return count;
  }

  DateTime? get lastRunAt {
    DateTime? last;

    for (var task in tasks) {
      if (task.status?.lastRunAt != null) {
        if (last == null || last.isBefore(task.status!.lastRunAt!)) {
          last = task.status!.lastRunAt!;
        }
      }
    }

    return last;
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
  Task({
    required this.name,
    this.goalId,
    this.position = 0,
    this.repeatable = false,
    TaskStatus? status,
  }) : status = status ?? TaskStatus();

  late String name;

  int? id;
  int? goalId;
  int position = 0;
  bool repeatable = false;
  TaskStatus status;

  Map<String, Object?> toMap() {
    return {
      'goal_id': goalId,
      'name': name,
      'position': position,
      'repeatable': repeatable ? 1 : 0,
    };
  }

  Task.fromMap(Map<String, Object?> map) : status = TaskStatus() {
    id = map['id'] as int?;
    goalId = map['goal_id'] as int?;
    name = map['name'] as String;
    position = map['position'] as int;
    repeatable = (map['repeatable'] as int) == 1;
  }

  @override
  String toString() {
    return "Task(id=$id, p=$position, goal_id=${goalId}, $name)";
  }
}

enum TaskStatusValue {
  ready(value: "ready"),
  started(value: "started"),
  stopped(value: "stopped"),
  done(value: "done");

  const TaskStatusValue({required this.value});

  final String value;
}

class TaskStatus {
  TaskStatus({
    this.status = TaskStatusValue.ready,
    this.startedAt,
    this.lastRunAt,
    this.duration,
    this.timebox,
    this.cooldown,
  });

  TaskStatusValue status;
  DateTime? startedAt;
  DateTime? lastRunAt;
  Duration? duration;
  Duration? timebox;
  Duration? cooldown;

  Map<String, Object?> toMap(int taskId) {
    return {
      'task_id': taskId,
      'status': status.value,
      'started_at': startedAt?.millisecondsSinceEpoch,
      'last_run_at': lastRunAt?.millisecondsSinceEpoch,
      'duration': duration?.inSeconds,
      'timebox': timebox?.inSeconds,
      'cooldown': cooldown?.inSeconds,
    };
  }

  TaskStatus.fromMap(Map<String, Object?> map)
      : status = TaskStatusValue.ready {
    status = map['status'] == null
        ? TaskStatusValue.ready
        : TaskStatusValue.values.byName(map['status'] as String);

    startedAt = map['started_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(map['started_at'] as int);
    lastRunAt = map['last_run_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(map['last_run_at'] as int);
    duration = map['duration'] == null
        ? null
        : Duration(seconds: map['duration'] as int);
    timebox = map['timebox'] == null
        ? null
        : Duration(seconds: map['timebox'] as int);
    cooldown = map['cooldown'] == null
        ? null
        : Duration(seconds: map['cooldown'] as int);
  }

  @override
  String toString() {
    return "TaskStatus(status=$status)";
  }
}
