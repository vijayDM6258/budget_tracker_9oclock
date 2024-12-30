import 'package:budget_tracker/model/IncomeExpenseModel.dart';
import 'package:budget_tracker/utils/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';

class HomeController extends GetxController {
  RxList data = [].obs;
  RxBool isIncome = false.obs;
  RxDouble totalIncome = 0.0.obs;
  RxDouble totalExpense = 0.0.obs;
  RxList<Map<String, Object?>> incomeList = <Map<String, Object?>>[].obs;
  RxList<Map<String, Object?>> expenseList = <Map<String, Object?>>[].obs;

  PageController pageController = PageController();

  RxInt bottomNavIndex = 0.obs;
  RxMap<String, Object?> selectedCategory = <String, Object?>{}.obs;

  TextEditingController txtAmount = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtDate = TextEditingController();
  DateTime? selectDate;

  @override
  void onInit() {
    super.onInit();
    getIncomeData();
    getExpenseData();
  }

  Future<void> getIncomeData() async {
    List<Map<String, Object?>> ixl = await DbHelper.dbHelper.getIncomeExpenseFromDb("Income");
    incomeList.value = ixl;
  }

  Future<void> getIncomeDataWithSearch(String search) async {
    if (search.isEmpty) {
      getIncomeData();
    } else {
      List<Map<String, Object?>> ixl = await DbHelper.dbHelper.getIncomeSearchData(search);
      incomeList.value = ixl;
    }
  }

  Future<void> getExpenseData() async {
    List<Map<String, Object?>> ixl = await DbHelper.dbHelper.getIncomeExpenseFromDb("Expense");
    expenseList.value = ixl;
  }

  Future<void> addIncome() async {
    await DbHelper.dbHelper.addIncomeExpenseWithModel(IncomeExpenseModel(
      isExpense: bottomNavIndex == 0 ? "Income" : "Expense",
      name: txtName.text,
      amount: double.tryParse(txtAmount.text) ?? 0,
      categoryName: "${selectedCategory.value["name"]}",
      date: selectDate?.toString() ?? "",
    ));

    getIncomeData();
    getExpenseData();
    print("Added");
  }

  Future<void> editIncome(int editId) async {
    await DbHelper.dbHelper.updateIncomeExpense(
        IncomeExpenseModel(
          isExpense: bottomNavIndex == 0 ? "Income" : "Expense",
          name: txtName.text,
          amount: double.tryParse(txtAmount.text) ?? 0,
          categoryName: "${selectedCategory.value["name"]}",
          date: selectDate?.toString() ?? "",
        ),
        editId);

    getIncomeData();
    getExpenseData();
    print("Added");
  }

  Future<void> deleteItem(int id) async {
    await DbHelper.dbHelper.deleteIncomeExpense(id);
    getIncomeData();
    getExpenseData();
  }
}
