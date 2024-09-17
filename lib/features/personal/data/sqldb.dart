import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initializeDb();
      return _db;
    } else {
      return _db;
    }
  }

  initializeDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'marwan.db');
    Database myDb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return myDb;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async{
    //await db.execute("ALTER TABLE notes ADD COLUMN color TEXT");
    debugPrint("=================== On Upgrade");
  }


  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE "notes" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "gender" TEXT NOT NULL,
    "date" TEXT NOT NULL
  )
  ''');
    debugPrint("=================== Create database and table");
  }

  readData(String sql) async {
    Database? myDb = await db;
    List<Map> response = await myDb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? myDb = await db;
    int response = await myDb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? myDb = await db;
    int response = await myDb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? myDb = await db;
    int response = await myDb!.rawDelete(sql);
    return response;
  }


  destroyDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'marwan.db');
    await deleteDatabase(path);
  }



  read(String table) async {
    Database? myDb = await db;
    List<Map> response = await myDb!.query(table);
    return response;
  }

  insert(String table, Map<String, Object?> values) async {
    Database? myDb = await db;
    int response = await myDb!.insert(table,values);
    return response;
  }

  update(String table, Map<String, Object?> values , String? myWhere) async {
    Database? myDb = await db;
    int response = await myDb!.update(table, values, where: myWhere);
    return response;
  }

  delete(String table, String? myWhere) async {
    Database? myDb = await db;
    int response = await myDb!.delete(table , where: myWhere);
    return response;
  }

}
