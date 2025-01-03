import 'package:budget_tracker/controller/home_controller.dart';
import 'package:budget_tracker/model/IncomeExpenseModel.dart';
import 'package:budget_tracker/model/income_expense.dart';
import 'package:budget_tracker/utils/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("2000"),
      ),
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (value) {
          controller.bottomNavIndex.value = value;
        },
        children: [
          Obx(() {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Search"),
                    onChanged: (value) {
                      controller.getIncomeDataWithSearch(value);
                      print("object $value");
                    },
                  ),
                ),
                if (controller.incomeList.isEmpty) Text("No Data Found"),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.incomeList.length,
                    itemBuilder: (context, index) {
                      int id = int.tryParse("${controller.incomeList[index]["ID"]}") ?? 0;
                      IncomeExpenseModel ix = IncomeExpenseModel.fromJson(controller.incomeList[index]);

                      return ListTile(
                        title: Text(ix.name ?? ""),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("${ix.amount}"),
                            Text(ix.categoryName ?? ""),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showMyDialog(context, name: ix.name, amt: ix.amount, cat: ix.categoryName, date: ix.date, id: id);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                controller.deleteItem(id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
          Obx(() {
            return ListView.builder(
              itemCount: controller.expenseList.length,
              itemBuilder: (context, index) {
                Map<String, Object?> incomeItem = controller.expenseList[index];
                int id = int.tryParse("${controller.expenseList[index]["ID"]}") ?? 0;
                return ListTile(
                  title: Text("${incomeItem["name"]}"),
                  subtitle: Text("${incomeItem["category_name"]} , ${incomeItem["isExpense"]}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          controller.deleteItem(id);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
      bottomNavigationBar: Obx(() {
        return NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.trending_down), label: "Income"),
            NavigationDestination(icon: Icon(Icons.trending_up), label: "Expense"),
          ],
          selectedIndex: controller.bottomNavIndex.value,
          onDestinationSelected: (value) {
            controller.bottomNavIndex.value = value;
            controller.pageController.animateToPage(value, duration: Duration(milliseconds: 300), curve: Curves.linear);
            print("select $value");
          },
        );
      }),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            return FloatingActionButton.extended(
              onPressed: () {
                showMyDialog(context);
              },
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(controller.bottomNavIndex == 0 ? Icons.trending_down : Icons.trending_up), Text(controller.bottomNavIndex == 0 ? "Add Income" : "Add Expense")],
              ),
            );
          }),
          FloatingActionButton(
            heroTag: "add",
            onPressed: () {
              Get.toNamed("AddIX");
            },
            child: Icon(Icons.category),
          ),
        ],
      ),
    );
  }

  void showMyDialog(BuildContext context, {String? name, String? date, num? amt, String? cat, int? id}) {
    controller.txtName.text = name ?? "";
    controller.txtAmount.text = "${amt ?? ""}";
    controller.txtDate.text = date ?? "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.txtName,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Name',
                focusColor: Colors.green,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: controller.txtAmount,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Amount',
                focusColor: Colors.green,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: controller.txtDate,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Select Date',
                focusColor: Colors.green,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              readOnly: true,
              onTap: () async {
                controller.selectDate = await showDatePicker(context: context, firstDate: DateTime(2005), lastDate: DateTime.now());
                if (controller.selectDate != null) {
                  TimeOfDay? timeOfDate = await showTimePicker(context: context, initialTime: TimeOfDay.now());

                  if (timeOfDate != null) {
                    controller.selectDate = controller.selectDate?.add(Duration(hours: timeOfDate.hour, minutes: timeOfDate.minute));
                  }
                  String formatedDate = DateFormat.yMd().add_jm().format(controller.selectDate!);
                  controller.txtDate.text = formatedDate;
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: DbHelper.dbHelper.getCategoryFromDb(),
              builder: (context, snapshot) {
                print("FutureBuilder");
                if (snapshot.data?.isNotEmpty ?? false) {
                  List<Map<String, Object?>>? selectImg = snapshot.data?.where((element) => element["name"] == cat).toList();
                  if (selectImg?.isNotEmpty ?? false) {
                    controller.selectedCategory.value = selectImg!.first;
                    print("selectImg $selectImg");
                  }
                }

                return Obx(() {
                  return DropdownMenu(
                    dropdownMenuEntries: (snapshot.data ?? []).map(
                      (e) {
                        return DropdownMenuEntry(
                            value: e,
                            label: "${e["name"]}",
                            leadingIcon: Image.asset(
                              "${e["img"]}",
                              width: 15,
                              height: 15,
                            ));
                      },
                    ).toList(),
                    // initialSelection: snapshot.data?[3],
                    controller: TextEditingController(text: cat ?? ""),
                    expandedInsets: EdgeInsets.all(10),
                    leadingIcon: Image.asset(
                      "${controller.selectedCategory.value["img"]}",
                      width: 15,
                      height: 15,
                    ),
                    onSelected: (value) {
                      controller.selectedCategory.value = value ?? {};
                      print("value $value");
                    },
                  );
                });
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              minimumSize: const Size(100, 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: .75),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (name != null) {
                await controller.editIncome(id!);
              } else {
                await controller.addIncome();
              }

              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              minimumSize: const Size(100, 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              name != null ? 'Edit' : "Add",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: .75),
            ), // Button ka text
          ),
        ],
      ),
    );
  }
}
