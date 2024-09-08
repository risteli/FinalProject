import 'dart:developer';

import 'package:final_project/repository/database.dart';
import 'package:sqflite/sqflite.dart';

import '../models/roots.dart';
import '../models/models.dart';

class Storage {
  Storage._privateConstructor() {
    db = AppDatabase.instance.database;
    root = StorageRoot();
  }

  static Storage? _instance;

  late final Database db;
  late final StorageRoot root;

  factory Storage() {
    _instance ??= Storage._privateConstructor();
    return _instance!;
  }

  static Storage get instance => _instance!;

  Future<StorageRoot> load() async {
    var configKV = await db.query(
      AppDatabase.configTable,
    );

    Map<String, String> configMap = {};
    for (var record in configKV) {
      configMap[record['key'] as String] = record['value'] as String;
    }
    root.setConfig(configMap);

    var rawGoals = await db.query(
      AppDatabase.goalsTable,
      where: 'active=1',
      orderBy: 'position',
    );

    Map<int, Goal> goalById = {};

    List<Goal> loadedGoals = [];

    for (var rawGoal in rawGoals) {
      var goal = Goal.fromMap(rawGoal);
      loadedGoals.add(goal);
      goalById[goal.id!] = goal;
    }

    var rawTasks = await db.query(
      AppDatabase.tasksTable,
      where: 'active=1 AND goal_id IN (SELECT id FROM goals WHERE active=1)',
      orderBy: 'position',
    );

    var taskIds = <int>[];
    for (var rawTask in rawTasks) {
      var task = Task.fromMap(rawTask);
      taskIds.add(task.id!);
      goalById[task.goalId!]!.tasks.add(task);
    }
    root.loadGoals(loadedGoals);

    if (taskIds.isNotEmpty) {
      var records = await db.query(
        AppDatabase.taskStatusTable,
        where: 'task_id IN (${List.filled(taskIds.length, '?').join(',')})',
        whereArgs: taskIds,
      );

      var taskStatusByTask = <int, TaskStatus>{};
      for (var record in records) {
        var taskStatus = TaskStatus.fromMap(record);
        taskStatusByTask[record['task_id'] as int] = taskStatus;
      }

      for (var goal in root.goals) {
        for (var task in goal.tasks) {
          if (taskStatusByTask.containsKey(task.id!)) {
            task.status = taskStatusByTask[task.id!]!;
          } else {
            task.status = TaskStatus();
          }
        }
      }
    }

    return root;
  }

  Future updateGoals() async {
    var batch = db.batch();
    for (var i = 0; i < root.goals.length; i++) {
      var goal = root.goals[i];
      goal.position = i;

      var record = goal.toMap();
      if (goal.id != null) {
        record['id'] = goal.id;
      }

      batch.insert(AppDatabase.goalsTable, record,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    var ids = await batch.commit();

    var idsPlaceholders = List.filled(ids.length, '?').join(',');

    await db.update(
      AppDatabase.goalsTable,
      {'active': 0},
      where: 'id NOT IN (${idsPlaceholders})',
      whereArgs: ids,
    );
  }

  Future updateTasks(Goal goal) async {
    var batch = db.batch();
    var tasks = goal.tasks;

    for (var i = 0; i < tasks.length; i++) {
      var task = tasks[i];
      task.position = i;

      var record = task.toMap();
      if (task.id != null) {
        record['id'] = task.id;
      }

      batch.insert(AppDatabase.tasksTable, record,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    var ids = await batch.commit();

    var idsPlaceholders = List.filled(ids.length, '?').join(',');

    await db.update(
      AppDatabase.tasksTable,
      {'active': 0},
      where: 'goal_id=? AND id NOT IN (${idsPlaceholders})',
      whereArgs: [goal.id, ...ids],
    );
  }

  Future updateTask(Task task) async {
    await db.update(AppDatabase.tasksTable, task.toMap(),
        where: 'id=?', whereArgs: [task.id]);
  }

  Future createTask(Task task) async {
    task.id = await db.insert(AppDatabase.tasksTable, task.toMap());
  }

  Future updateTaskStatus(TaskStatus taskStatus) async {
    await db.insert(AppDatabase.taskStatusTable, taskStatus.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future addTaskToHistory(TaskStatus taskStatus) async {
    await db.insert(AppDatabase.taskHistoryTable, taskStatus.toMap());
  }
}
