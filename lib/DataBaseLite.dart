import 'dart:io';
import 'package:flutterapp/Expense.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseLite{
  Database _databse;

  Future<Database> get database async {
    if (_databse == null){
      _databse =  await initialize();
    }
    return _databse;
  }

  DataBaseLite() {}

  initialize() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    var path = join(documentsDir.path, "db.db");
    return openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE Expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, name TEXT, price REAL, month INTEGER, year INTEGER)");
      }
    );
  }

  Future<List<Expense>> getExpenses(int month, int year) async {
    Database db = await database;
    List<Map> query = await db.rawQuery("SELECT * FROM Expenses WHERE month = $month AND year = $year ORDER BY date DESC");
    var result = List<Expense>();
    query.forEach((r) => result.add(Expense(r["id"], DateTime.parse(r["date"]), r["name"], r["price"])));
    return result;
  }

  Future<void> addExpenseDB(String name, double price, DateTime dateTime) async {
    Database db = await database;
    var dateAsString = dateTime.toString();
    int month = dateTime.month;
    int year = dateTime.year;
    await db.rawInsert("INSERT INTO Expenses (name, date, price, month, year) VALUES (\"$name\", \"$dateAsString\", $price, $month, $year)");
  }

  Future<void> removeAtDB(int id) async {
    Database db = await database;
    await db.rawDelete("DELETE FROM Expenses WHERE id = $id");
  }

  Future<void> editExpenseDB(String name, double price, DateTime dateTime, int id) async {
    Database db = await database;
    var dateAsString = dateTime.toString();
    int month = dateTime.month;
    int year = dateTime.year;
    await db.rawUpdate("UPDATE Expenses SET name = \"$name\", price = $price, date = \"$dateAsString\", month = $month, year = $year WHERE id = $id");
  }


}