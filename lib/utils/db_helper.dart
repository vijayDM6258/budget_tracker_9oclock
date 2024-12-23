import 'package:sqflite/sqflite.dart';

class DbHelper {
  late Database db;

  Future<void> initDb() async {
    String dbPath = await getDatabasesPath();
    db = await openDatabase(
      "rnw.db",
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE category (name	TEXT, isExpense	TEXT,id	INTEGER UNIQUE)');
        await db.execute(
            'CREATE TABLE "IncomeExpense" ("ID"	INTEGER UNIQUE,"name"	TEXT,"date"	TEXT,"amount"	REAL,"category_name"	TEXT,"isExpense"	TEXT,PRIMARY KEY("ID" AUTOINCREMENT))');
      },
    );
  }

  Future<void> addToDb() async {
    await db.insert("", {});
  }

  Future<void> getFromDb() async {}

  Future<void> delete() async {}

  Future<void> update() async {}
}
