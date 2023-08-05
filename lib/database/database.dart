import 'package:flutter_foyer_demo/models/device_settings_model.dart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDatabase();
    return _database;
  }

  Future<bool> isDatabaseInitialized() async {
    final database = await _initDatabase();
    return database != null;
  }

  Future<int> insertProfile(PlaceProfile profile) async {
    final db = await database;
    return await db!.insert('profiles', profile.toMap());
  }

  Future<List<PlaceProfile>> retrieveProfiles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('profiles');

    return List.generate(maps.length, (i) {
      return PlaceProfile.fromMap(maps[i]);
    });
  }

  Future<void> deleteProfile(int id) async {
    final db = await database;
    await db!.delete('profiles', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isProfileDuplicate(PlaceProfile profile) async {
    final db = await database;

    List<Map<String, dynamic>> result = await db!.query(
      'profiles',
      where: 'latitude = ? AND longitude = ?',
      whereArgs: [profile.latitude, profile.longitude],
    );

    return result.isNotEmpty;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'profiles.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE profiles(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      placeName TEXT,
      latitude REAL,
      longitude REAL,
      favoriteActivities TEXT
    )
  ''');
  }

  Future<bool> isProfileDuplicateByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    final db = await database;
    final profiles = await db!.query(
      'profiles',
      where: 'latitude = ? AND longitude = ?',
      whereArgs: [latitude, longitude],
    );

    return profiles.isNotEmpty;
  }
}
