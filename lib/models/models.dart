import 'dart:developer';

class Goal {
  Goal({
    required this.name,
    required this.goalType,
    this.tasks = const [],
  });

  int? id;
  late final String name;
  late final GoalType goalType;
  List<Task> tasks = [];

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'type': goalType.name,
    };
  }

  Goal.fromMap(Map<String, Object?> map) {
    id = map['id'] as int?;
    name = map['name'] as String;
    goalType = GoalType.values.byName(map['type'] as String);
  }

  @override
  String toString() {
    String tasksList = tasks.join(',');

    return "Goal(id=$id, $name, ${goalType.name}, $tasksList)";
  }
}

enum GoalType {
  learning,
  building,
  todo,
}

class Task {
  Task({this.name = "", this.estimation});

  late final String name;

  int? id;
  int? goalId;
  Set<Tool> tool = {};
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

abstract class Tool {
  String get name;
}

class StopwatchTool implements Tool {
  late Stopwatch running = Stopwatch();

  @override
  String get name => 'Stopwatch';
}
