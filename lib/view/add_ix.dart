import 'package:budget_tracker/controller/AddIXController.dart';
import 'package:budget_tracker/utils/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddIX extends StatelessWidget {
  AddIXController controller = Get.put(AddIXController());

  AddIX({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          FutureBuilder<List<Map<String, Object?>>>(
              future: DbHelper.dbHelper.getCategoryFromDb(),
              builder: (context, snap) {
                return DropdownMenu(
                  dropdownMenuEntries: List.generate(snap.data?.length ?? 0, (index) {
                    var map = snap.data![index];
                    return DropdownMenuEntry(
                      value: index,
                      label: "${map["name"]}",
                      leadingIcon: Image.asset(
                        "${map["img"]}",
                        height: 20,
                        width: 20,
                      ),
                    );
                  }),
                  onSelected: (value) {
                    print("value ${value}");
                  },
                );
              }),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.categoryName,
                ),
              ),
              Obx(() {
                return Checkbox(
                  value: controller.isExpense.value == "Expense",
                  onChanged: (value) {
                    controller.isExpense.value = (value ?? false) ? "Expense" : "Income";
                  },
                );
              }),
              Text("Is Expense"),
            ],
          ),
          Wrap(
            children: controller.imgList
                .map((e) => Obx(() {
                      return InkWell(
                        onTap: () {
                          controller.selectedCat.value = e;
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Image.asset(
                            e,
                            color: controller.selectedCat.value == e ? Colors.white : Colors.black,
                          ),
                          color: controller.selectedCat.value == e ? Colors.black54 : Colors.black45,
                          margin: EdgeInsets.all(5),
                          height: 50,
                          width: 50,
                        ),
                      );
                    }))
                .toList(),
          ),
          TextButton(
              onPressed: () {
                controller.addCategory();
              },
              child: Text("Add Category"))
        ],
      ),
    );
  }
}
