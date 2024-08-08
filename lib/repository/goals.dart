import 'dart:developer';

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
    var rawGoals = await db.query('goals');
    var goals = GoalsModel();

    Map<int,Goal> goalById = {};

    for (var rawGoal in rawGoals) {
      var goal = Goal.fromMap(rawGoal);
      goals.add(goal);
      goalById[goal.id!] = goal;
    }

    var rawTasks = await db.query('tasks');
    for (var rawTask in rawTasks) {
      var task = Task.fromMap(rawTask);
      goalById[task.goalId!]!.tasks.add(task);
    }

    return goals;
  }

  Future update(Goal goal) async {
    log('now updating $goal');
    
    await db.update(AppDatabase.goalsTable, goal.toMap(), where: 'id=?', whereArgs: [goal.id]);
  }
}
