
import 'package:sqflite/sqflite.dart';
import '../model/nodo_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance; //cash database instance

  final String tableNoDoItem = "nodoTbl";
  final String columnId = "id";
  final String columnNoDoItemName = "itemName";
  final String coloumnDateCreated = "dateCreated";
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "notodo_db.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $tableNoDoItem"
        "($columnId INTEGER PRIMARY KEY, "
        "$columnNoDoItemName TEXT,"
        "$coloumnDateCreated TEXT)");
  }

  Future<int> saveNoDoItem(NoDoItem NoDoItem) async {
    var dbClient = await db;

    int res = await dbClient.insert("$tableNoDoItem", NoDoItem.toMap());
    return res;
  }

  Future<List> getAllNoDoItems() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableNoDoItem");
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("Select Count(*) from $tableNoDoItem"));
  }

  Future<NoDoItem> getNoDoItem(int id) async {
    var dbClient = await db;
    var result =
    await dbClient.rawQuery("SELECT * FROM $tableNoDoItem where $columnId=$id ");
    if (result.length == 0) {
      return null;
    } else {
      return new NoDoItem.fromMap(result.first);
    }
  }

  Future<int> deleteNoDoItem(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableNoDoItem, where: "$columnId=?", whereArgs: [id]);
  }

  Future<int> updateNoDoItem(NoDoItem NoDoItem) async {
    var dbClient = await db;
    return await dbClient.update(tableNoDoItem, NoDoItem.toMap(),
        where: "$columnId=?", whereArgs: [NoDoItem.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
