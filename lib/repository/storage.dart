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

    Map<String,String> configMap = {};
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
        where: 'task_id IN (?)',
        whereArgs: [List.filled(taskIds.length, '?').join(',')],
      );

      var taskStatusByTask = <int, TaskStatus>{};
      for (var record in records) {
        var taskStatus = TaskStatus.fromMap(record);
        taskStatusByTask[taskStatus.taskId] = taskStatus;
      }

      for (var goal in root.goals) {
        for (var task in goal.tasks) {
          if (taskStatusByTask.containsKey(task.id!)) {
            task.status = taskStatusByTask[task.id!];
          } else {
            task.status = TaskStatus(taskId: task.id!);
          }
        }
      }
    }

    return root;
  }

  Future updateGoals() async {
    log('now updating');

    var batch = db.batch();
    for (var i = 0; i < root.goals.length; i++) {
      var goal = root.goals[i];
      goal.position = i;

      var record = goal.toMap();
      if (goal.id != null) {
        record['id'] = goal.id;
      }

      log('now inserting or updating $goal ${goal.toMap()}');
      batch.insert(AppDatabase.goalsTable, record,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    var ids = await batch.commit();

    if (true) // TODO REMOVE THIS
      for (var i = 0; i < root.goals.length; i++) {
        log('id of $i is ${ids[i]} and was ${root.goals[i].id}');
      }

    var idsPlaceholders = List.filled(ids.length, '?').join(',');

    await db.update(
      AppDatabase.goalsTable,
      {'active': 0},
      where: 'id NOT IN (${idsPlaceholders})',
      whereArgs: ids,
    );
  }

  Future updateTasks(Goal goal) async {
    log('now updating $goal ${goal.toMap()}');

    var batch = db.batch();
    var tasks = goal.tasks;

    for (var i = 0; i < tasks.length; i++) {
      var task = tasks[i];
      task.position = i;

      var record = task.toMap();
      if (task.id != null) {
        record['id'] = task.id;
      }

      log('now inserting or updating $task ${task.toMap()}');
      batch.insert(AppDatabase.tasksTable, record,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    var ids = await batch.commit();
    if (false) // TODO REMOVE THIS
      for (var i = 0; i < tasks.length; i++) {
        log('id of $i is ${ids[i]} and was ${tasks[i].id}');
      }

    var idsPlaceholders = List.filled(ids.length, '?').join(',');

    await db.update(
      AppDatabase.tasksTable,
      {'active': 0},
      where: 'goal_id=? AND id NOT IN (${idsPlaceholders})',
      whereArgs: [goal.id, ...ids],
    );
  }

  Future updateTask(Task task) async {
    log('now updating $task ${task.toMap()}');
    await db.update(AppDatabase.tasksTable, task.toMap(),
        where: 'id=?', whereArgs: [task.id]);
  }

  Future createTask(Task task) async {
    log('now creating $task ${task.toMap()}');
    task.id = await db.insert(AppDatabase.tasksTable, task.toMap());
    log('created $task');
  }

  Future updateTaskStatus(TaskStatus taskStatus) async {
    log('now updating $taskStatus ${taskStatus.toMap()}');
    await db.update(AppDatabase.taskStatusTable, taskStatus.toMap(),
        where: 'task_id=?', whereArgs: [taskStatus.taskId]);
  }
}
