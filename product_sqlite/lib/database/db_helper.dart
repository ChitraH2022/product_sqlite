import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

class DBHelper {
  static Database? _database;
  static const String DB_NAME = 'mydatabase.db';
  static const String TABLE_NAME = 'products';
  static const int DB_VERSION = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), DB_NAME);
    return await openDatabase(
      path,
      version: DB_VERSION,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $TABLE_NAME (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT,
      price REAL
    )
    ''');
  }

  Future<int> insert(Map<String, dynamic> data) async {
    Database db = await database;
    return await db.insert(TABLE_NAME, data);
  }


  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await database;
    return await db.query(TABLE_NAME);
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    Database db = await database;
    return await db.update(TABLE_NAME, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete(TABLE_NAME, where: 'id = ?', whereArgs: [id]);
  }
}
