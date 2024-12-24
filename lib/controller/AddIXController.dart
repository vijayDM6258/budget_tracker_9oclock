import 'package:budget_tracker/utils/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class AddIXController extends GetxController {
  TextEditingController categoryName = TextEditingController();
  RxString isExpense = "Expense".obs;
  List<String> imgList = [
    "icons/airplane.png",
    "icons/bag.png",
    "icons/cutlery.png",
    "icons/film.png",
    "icons/hobbies.png",
    "icons/money.png",
  ];
  RxString selectedCat = "icons/airplane.png".obs;

  @override
  void onInit() {
    DbHelper.dbHelper.getCategoryFromDb();
    super.onInit();
  }

  void addCategory() async {
    String catName = categoryName.text;
    String expense = isExpense.value;
    String catImg = selectedCat.value;
    await DbHelper.dbHelper.addCategoryToDb(catName, expense, catImg);
    print("addCategory Success");
  }
}
