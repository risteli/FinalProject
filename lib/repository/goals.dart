import 'dart:developer';

import 'package:final_project/app.dart';
import 'package:final_project/database.dart';
import 'package:sqflite/sqflite.dart';

import '../models/collections.dart';
import '../models/models.dart';

class GoalsRepo {
  GoalsRepo._privateConstructor(this.db);

  Database db;

  static GoalsRepo? _instance;

  factory GoalsRepo(AppDatabase appdb) {
    _instance ??= GoalsRepo._privateConstructor(appdb.database);
    return _instance!;
  }

  Future<GoalsModel> readAll() async {
    var rawGoals = await db.query('goals', orderBy: 'position');
    var goals = GoalsModel();

    Map<int, Goal> goalById = {};

    for (var rawGoal in rawGoals) {
      var goal = Goal.fromMap(rawGoal);
      goals.add(goal);
      goalById[goal.id!] = goal;
    }

    var rawTasks = await db.query('tasks', orderBy: 'position');
    for (var rawTask in rawTasks) {
      var task = Task.fromMap(rawTask);
      goalById[task.goalId!]!.tasks.add(task);
    }

    return goals;
  }

  Future update(Goal goal) async {
    log('now updating $goal ${goal.toMap()}');

    await db.update(AppDatabase.goalsTable, goal.toMap(),
        where: 'id=?', whereArgs: [goal.id]);
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

    await db.delete(AppDatabase.tasksTable,
        where: 'goal_id=? AND id NOT IN (${idsPlaceholders})',
        whereArgs: [goal.id, ...ids]);
  }

  Future updateTask(Task task) async {
    log('now inserting or updating $task ${task.toMap()}');
    await db.update(AppDatabase.tasksTable, task.toMap(),
        where: 'id=?', whereArgs: [task.id]);
  }
}
