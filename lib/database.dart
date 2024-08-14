import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/collections.dart';
import 'models/models.dart';

var goalsFixture = GoalsModel.from(
  [
    Goal(name: 'Learn BWV772 ?', goalType: GoalType.learning, tasks: [
      Task(name: 'LH Reading', estimation: Duration(minutes: 10)),
      Task(name: 'RH Reading', estimation: Duration(minutes: 10)),
      Task(name: 'Practice C Scale', estimation: Duration(minutes: 10)),
      Task(name: 'Practice D Scale', estimation: Duration(minutes: 10)),
      Task(name: 'Practice A minor Scale', estimation: Duration(minutes: 10)),
      Task(name: 'Measures 1-4', estimation: Duration(minutes: 10)),
      Task(name: 'Measures 2-8', estimation: Duration(minutes: 10)),
    ]),
    Goal(
        name: 'Read Good Strategy Bad Strategy',
        goalType: GoalType.learning,
        tasks: [
          Task(name: 'Chapter 1', estimation: Duration(minutes: 15)),
          Task(name: 'Chapter 2', estimation: Duration(minutes: 15)),
        ]),
    Goal(name: 'Bake a traditional pie', goalType: GoalType.learning, tasks: [
      Task(name: 'Buy ingredients', estimation: Duration(minutes: 60)),
      Task(name: 'Mix all together', estimation: Duration(minutes: 15)),
      Task(name: 'Bake', estimation: Duration(minutes: 30)),
    ]),
  ],
);

class AppDatabaseMigrations {
  void v1up(Database db) async {
    var batch = db.batch();

    batch.execute(
      '''
      CREATE TABLE ${AppDatabase.goalsTable}(
        id INTEGER PRIMARY KEY, 
        name TEXT,
        type TEXT,
        tool TEXT,
        position INTEGER NOT NULL DEFAULT 0
       )
      ''',
    );

    batch.execute(
      '''
      CREATE TABLE ${AppDatabase.tasksTable}(
        id INTEGER PRIMARY KEY,         
        name TEXT,
        estimation INTEGER,
        repeatable INTEGER NOT NULL DEFAULT 0,
        position INTEGER NOT NULL DEFAULT 0,
        goal_id INTEGER NOT NULL REFERENCES goals ON DELETE cascade
       )
      ''',
    );

    await batch.commit(noResult: true);
  }

  void addFixture(Database db) async {
    await db.delete(AppDatabase.goalsTable);

    var batch = db.batch();
    for (var i = 0; i < goalsFixture.items.length; i++) {
      var goal = goalsFixture.items[i];
      goal.position = i;
      batch.insert(AppDatabase.goalsTable, goal.toMap());
    }
    var ids = await batch.commit();

    for (var i = 0; i < goalsFixture.items.length; i++) {
      goalsFixture.items[i].id = ids[i] as int;
    }

    for (var i = 0; i < goalsFixture.items.length; i++) {
      var goal = goalsFixture.items[i];

      batch = db.batch();
      for (var j = 0; j < goal.tasks.length; j++) {
        goal.tasks[j].goalId = goal.id;
        goal.tasks[j].position = j;
        batch.insert(AppDatabase.tasksTable, goal.tasks[j].toMap());
      }
      ids = await batch.commit();

      for (var j = 0; j < goal.tasks.length; j++) {
        goal.tasks[j].id = ids[j] as int;
      }
    }

    goalsFixture.items.forEach((goal) {
      log('now $goal');
    });
  }
}

class AppDatabase {
  static const goalsTable = 'goals';
  static const tasksTable = 'tasks';

  static AppDatabase? _instance;

  AppDatabase._privateConstructor(this._database);

  final Database _database;

  static Future<Database> _init() async {
    String dbName = join(await getDatabasesPath(), 'taskchisel.db');

    if (false) // enable to drop the db and rebuild it
      await databaseExists(dbName)
          .then((exists) => exists ? deleteDatabase(dbName) : null);

    final database = await openDatabase(
      dbName,
      onCreate: (db, version) => _migrate(db, version),
      version: 1,
    );

    await database
        .getVersion()
        .then((version) => log('db ready version=${version}'));

    return database;
  }

  static Future<AppDatabase> get instance async {
    _instance ??= AppDatabase._privateConstructor(await _init());

    return _instance!;
  }

  Database get database => _database;

  static void _migrate(db, version) async {
    var _migrations = AppDatabaseMigrations();

    log('migrate to $version');
    _migrations.v1up(db);

    _migrations.addFixture(db);
  }
}
