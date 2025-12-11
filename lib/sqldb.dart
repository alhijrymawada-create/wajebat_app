import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  initialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'mazdb.db');

    Database mydb = await openDatabase(
      path,
      onCreate: _onCreate,
      version: 6,
      onUpgrade: _onUpgrade,
    );
    return mydb;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS department2 (
        DeptID INTEGER,
        DeptName TEXT
      )
    ''');

    List<Map<String, dynamic>> department2 = [
      {'DeptID': 1, 'DeptName': 'تقنية المعلومات'},
      {'DeptID': 2, 'DeptName': 'أمن المعلومات'},
      {'DeptID': 3, 'DeptName': 'علوم الحاسوب'},
    ];

    for (var dept in department2) {
      await db.insert('department2', dept);
    }

    print("Upgrade done.");
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE std_info2 (
        StdID INTEGER,
        DeptID INTEGER,
        StdName TEXT,
        level INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE department (
        DeptID INTEGER PRIMARY KEY,
        DeptName TEXT
      )
    ''');

    List<Map<String, dynamic>> departments = [
      {'DeptID': 1, 'DeptName': 'تقنية المعلومات'},
      {'DeptID': 2, 'DeptName': 'أمن المعلومات'},
      {'DeptID': 3, 'DeptName': 'علوم الحاسوب'},
    ];

    for (var dept in departments) {
      await db.insert('department', dept);
    }

    print("Database created");
  }

  readData(String sql) async {
    Database? mydb = await db;
    return await mydb!.rawQuery(sql);
  }

  insertData(String sql) async {
    Database? mydb = await db;
    return await mydb!.rawInsert(sql);
  }

  updateData(String sql) async {
    Database? mydb = await db;
    return await mydb!.rawUpdate(sql);
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    return await mydb!.rawDelete(sql);
  }
}
