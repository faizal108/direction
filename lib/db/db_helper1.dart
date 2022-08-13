import 'package:sqflite/sqflite.dart';

import '../models/task1.dart';

class DBHelper1 {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "locationsone";

  static Future<void> initDb() async {
    if(_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'locationsone.db';
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          print("creating a new one");
          return db.execute(
            "CREATE TABLE $_tableName("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "title STRING, "
                "color INTEGER, "
                "lat DOUBLE, lan DOUBLE)",
          );
        },
      );
    }
    catch(e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    print("insert function called");
    return await _db?.insert(_tableName, task!.toJson())??1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return await _db!.query(_tableName);
  }

  static delete(Task task) async{
    return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }
}