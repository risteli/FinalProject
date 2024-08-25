import 'dart:developer';

import 'package:final_project/repository/database.dart';
import 'package:sqflite/sqflite.dart';

import '../models/roots.dart';
import '../models/models.dart';

class GoalsRepo {
  GoalsRepo._privateConstructor() {
    db = AppDatabase.instance.database;
    goals = GoalsModel();
  }

  static GoalsRepo? _instance;

  late final Database db;
  late final GoalsModel goals;

  factory GoalsRepo() {
    _instance ??= GoalsRepo._privateConstructor();
    return _instance!;
  }

  static GoalsRepo get instance => _instance!;

  Future<GoalsModel> load() async {
    log('goalsrepo load called');

    var rawGoals = await db.query(
      'goals',
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
      'tasks',
      where: 'active=1 AND goal_id IN (SELECT id FROM goals WHERE active=1)',
      orderBy: 'position',
    );

    for (var rawTask in rawTasks) {
      var task = Task.fromMap(rawTask);
      goalById[task.goalId!]!.tasks.add(task);
    }
    goals.load(loadedGoals);

    return goals;
  }

  Future create(Goal goal) async {
    if (goals.items.isNotEmpty) {
      goal.position = goals.items
              .reduce((v, e) => e.position > v.position ? e : v)
              .position +
          1;
    }

    log('now creating $goal ${goal.toMap()}');

    goal.id = await db.insert(AppDatabase.goalsTable, goal.toMap());

    log('created $goal');
  }

  Future update(Goal goal) async {
    log('now updating $goal ${goal.toMap()}');

    await db.update(AppDatabase.goalsTable, goal.toMap(),
        where: 'id=?', whereArgs: [goal.id]);
  }

  Future updateGoals(GoalsModel goals) async {
    log('now updating $goals');

    var batch = db.batch();
    for (var i = 0; i < goals.items.length; i++) {
      var goal = goals.items[i];
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
      for (var i = 0; i < goals.items.length; i++) {
        log('id of $i is ${ids[i]} and was ${goals.items[i].id}');
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
}
