import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class AppDatabaseMigrations {
  void v1up(Database db) {
    var batch = db.batch();

    batch.execute(
      '''
      CREATE TABLE goals(
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        age INTEGER
       )
      ''',
    );

    batch.commit();
  }
}

class AppDatabase {
  static AppDatabase? _instance;

  AppDatabase._privateConstructor(this._database);

  final Database _database;

  static Future<Database> _init() async {
    String dbName = join(await getDatabasesPath(), 'taskchisel.db');

    await databaseExists(dbName)
        .then((exists) => exists ? deleteDatabase(dbName) : null);

    final database = await openDatabase(
      dbName,
      onCreate: (db, version) => _migrate(db, version),
      version: 1,
    );

    await database.getVersion().then((version) => log('db ready version=${version}'));

    return database;
  }

  static Future<AppDatabase> get instance async {
    _instance ??= AppDatabase._privateConstructor(await _init());

    return _instance!;
  }

  static void _migrate(db, version) {
    var _migrations = AppDatabaseMigrations();

    log('migrate to $version');
    _migrations.v1up(db);
  }
}
