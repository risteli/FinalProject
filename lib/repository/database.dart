import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'fixture.dart';

class AppDatabaseMigrations {
  void v1up(Database db) async {
    var batch = db.batch();

    batch.execute('''
      CREATE TABLE ${AppDatabase.goalsTable}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        active INTEGER NOT NULL DEFAULT 1, 
        name TEXT,
        type TEXT,
        deadline INTEGER,
        position INTEGER NOT NULL DEFAULT 0
       )
      ''');

    batch.execute('''
      CREATE TABLE ${AppDatabase.tasksTable}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,         
        active INTEGER NOT NULL DEFAULT 1, 
        name TEXT,
        repeatable INTEGER NOT NULL DEFAULT 0,
        position INTEGER NOT NULL DEFAULT 0,
        goal_id INTEGER NOT NULL REFERENCES ${AppDatabase.goalsTable}
       )
      ''');

    batch.execute('''
      CREATE TABLE ${AppDatabase.taskStatusTable}(
        task_id INTEGER PRIMARY KEY REFERENCES ${AppDatabase.tasksTable},
        status TEXT,
        started_at INTEGER,
        last_run_at INTEGER,
        duration INTEGER,         
        timebox INTEGER,
        cooldown INTEGER,
        notes TEXT
       )
      ''');

    batch.execute('''
      CREATE TABLE ${AppDatabase.taskHistoryTable}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task_id INTEGER REFERENCES ${AppDatabase.tasksTable},
        status TEXT,
        started_at INTEGER,
        last_run_at INTEGER,
        duration INTEGER,         
        timebox INTEGER,
        cooldown INTEGER,
        notes TEXT
       )
      ''');

    batch.execute('''
      CREATE TABLE ${AppDatabase.configTable}(
        key TEXT NOT NULL PRIMARY KEY,
        value TEXT
       )
      ''');

    batch.execute('''
      INSERT INTO ${AppDatabase.configTable}(key, value)
      VALUES
        ('default_timebox', 25),
        ('default_cooldown', 5);
      ''');

    await batch.commit(noResult: true);
  }

  void addFixture(Database db) async {
    await db.delete(AppDatabase.goalsTable);

    var batch = db.batch();
    for (var i = 0; i < goalsFixture.goals.length; i++) {
      var goal = goalsFixture.goals[i];
      goal.position = i;
      batch.insert(AppDatabase.goalsTable, goal.toMap());
    }
    var ids = await batch.commit();

    for (var i = 0; i < goalsFixture.goals.length; i++) {
      goalsFixture.goals[i].id = ids[i] as int;
    }

    for (var i = 0; i < goalsFixture.goals.length; i++) {
      var goal = goalsFixture.goals[i];

      batch = db.batch();
      for (var j = 0; j < goal.tasks.length; j++) {
        goal.tasks[j].goalId = goal.id;
        goal.tasks[j].position = j;
        batch.insert(AppDatabase.tasksTable, goal.tasks[j].toMap());
      }
      ids = await batch.commit();

      batch = db.batch();
      for (var j = 0; j < goal.tasks.length; j++) {
        goal.tasks[j].id = ids[j] as int;
        batch.insert(AppDatabase.taskStatusTable, goal.tasks[j].status.toMap(goal.tasks[j].id!));
      }
      await batch.commit();
    }
  }
}

class AppDatabaseInit {
  static const databaseName = 'taskchisel.db';

  AppDatabaseInit._privateConstructor();

  late final Database _database;

  static Future<AppDatabase> init({bool resetDatabase = false}) async {
    String dbName = join(await getDatabasesPath(), databaseName);

    if (resetDatabase) {
      await databaseExists(dbName)
          .then((exists) => exists ? deleteDatabase(dbName) : null);
    }

    final database = await openDatabase(
      dbName,
      onCreate: (db, version) => _migrate(db, version),
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
      version: 1,
    );

    await database
        .getVersion()
        .then((version) => log('db ready version=${version}'));

    return AppDatabase(database);
  }

  static void _migrate(db, version) async {
    var _migrations = AppDatabaseMigrations();

    log('migrate to $version');
    _migrations.v1up(db);

    log('loading dev fixtures');
    _migrations.addFixture(db);

    log('migrations completed');
  }
}

class AppDatabase {
  static const goalsTable = 'goals';
  static const tasksTable = 'tasks';
  static const taskStatusTable = 'task_status';
  static const taskHistoryTable = 'task_history';
  static const configTable = 'config';

  static AppDatabase? _instance;

  AppDatabase._privateConstructor(this._database);

  final Database _database;

  factory AppDatabase(Database database) {
    _instance ??= AppDatabase._privateConstructor(database);

    return _instance!;
  }

  static AppDatabase get instance => _instance!;

  Database get database => _database;
}
