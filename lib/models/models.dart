class Attachment {
  const Attachment({
    required this.url,
  });

  final String url;
}

class Email {
  const Email({
    required this.sender,
    required this.recipients,
    required this.subject,
    required this.content,
    this.replies = 0,
    this.attachments = const [],
  });

  final User sender;
  final List<User> recipients;
  final String subject;
  final String content;
  final List<Attachment> attachments;
  final double replies;
}

class Name {
  const Name({
    required this.first,
    required this.last,
  });

  final String first;
  final String last;
  String get fullName => '$first $last';
}

class User {
  const User({
    required this.name,
    required this.avatarUrl,
    required this.lastActive,
  });

  final Name name;
  final String avatarUrl;
  final DateTime lastActive;
}

class Goal {
  Goal({
    required this.name,
    required this.goalType,
    this.tasks = const [],
  });

  final String name;
  final GoalType goalType;
  final List<Task> tasks;
}

enum GoalType {
  learning,
  building,
  todo,
}

class Task {
  Task({
    required this.name,
    required this.tool,
    required this.estimation,
  });

  final String name;
  final Set<Tool> tool;
  final Duration estimation;
}

abstract class Tool {
  String get name;
}

class StopwatchTool implements Tool {
  late Stopwatch running = Stopwatch();

  @override
  String get name => 'Stopwatch';
}
