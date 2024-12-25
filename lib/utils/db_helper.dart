import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static DbHelper dbHelper = DbHelper._();

  DbHelper._();

  late Database db;
  String categoryTable = "category";
  String incomeExpenseTable = "IncomeExpense";

  Future<void> initDb() async {
    String dbPath = await getDatabasesPath();
    db = await openDatabase(
      "rnw.db",
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE $categoryTable (name	TEXT, isExpense	TEXT,img TEXT,id	INTEGER UNIQUE)');
        await db.execute(
            'CREATE TABLE $incomeExpenseTable" ("ID"	INTEGER UNIQUE,"name"	TEXT,"date"	TEXT,"amount"	REAL,"category_name"	TEXT,"isExpense"	TEXT,PRIMARY KEY("ID" AUTOINCREMENT))');
      },
    );
  }

  Future<void> addCategoryToDb(String categoryName, String isExpense, String img) async {
    await db.insert(categoryTable, {
      "name": categoryName,
      "isExpense": isExpense,
      "img": img,
    });
  }

  Future<void> addIncomeExpenseToDb(String name, double amt, String catName, String isExpense) async {
    await db.insert(
      incomeExpenseTable,
      {
        "name": name,
        "date": DateTime.now().toString(),
        "amount": amt,
        "category_name": catName,
        "isExpense": isExpense,
      },
    );
  }

  Future<List<Map<String, Object?>>> getCategoryFromDb() async {
    List<Map<String, Object?>> catList = await db.query(categoryTable);
    return catList;
  }

  Future<List<Map<String, Object?>>> getIncomeExpenseFromDb(String isExpense) async {
    List<Map<String, Object?>> ixl = await db.query(incomeExpenseTable, where: "isExpense = ?", whereArgs: [isExpense]);
    return ixl;
  }

  Future<void> delete() async {}

  Future<void> update() async {}
}
