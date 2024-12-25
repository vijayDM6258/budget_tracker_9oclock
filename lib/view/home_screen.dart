import 'package:budget_tracker/controller/home_controller.dart';
import 'package:budget_tracker/utils/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        children: [
          Obx(() {
            return ListView.builder(
              itemCount: controller.incomeList.length,
              itemBuilder: (context, index) {
                Map<String, Object?> incomeItem = controller.incomeList[index];
                return ListTile(
                  title: Text("${incomeItem["name"]}"),
                  subtitle: Text("${incomeItem["category_name"]}"),
                  trailing: Text("${incomeItem["amount"]}"),
                );
              },
            );
          }),
          Obx(() {
            return ListView.builder(
              itemCount: controller.expenseList.length,
              itemBuilder: (context, index) {
                Map<String, Object?> incomeItem = controller.expenseList[index];
                return ListTile(
                  title: Text("${incomeItem["name"]}"),
                  subtitle: Text("${incomeItem["category_name"]} , ${incomeItem["isExpense"]}"),
                  trailing: Text("${incomeItem["amount"]}"),
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
            onPressed: () {
              Get.toNamed("AddIX");
            },
            child: Icon(Icons.category),
          ),
        ],
      ),
    );
  }

  void showMyDialog(BuildContext context) {
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
            SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: DbHelper.dbHelper.getCategoryFromDb(),
              builder: (context, snapshot) {
                return DropdownMenu(
                  dropdownMenuEntries: (snapshot.data ?? []).map(
                    (e) {
                      return DropdownMenuEntry(value: e, label: "${e["name"]}");
                    },
                  ).toList(),
                  onSelected: (value) {
                    controller.selectedCategory.value = "${value?["name"]}";
                    print("value $value");
                  },
                );
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
              await controller.addIncome();
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
              'Add',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: .75),
            ), // Button ka text
          ),
        ],
      ),
    );
  }
}
