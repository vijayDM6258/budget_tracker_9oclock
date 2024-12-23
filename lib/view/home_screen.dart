import 'package:budget_tracker/controller/home_controller.dart';
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
        children: [],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.trending_down), label: "Income"),
          NavigationDestination(icon: Icon(Icons.trending_up), label: "Expense"),
        ],
        selectedIndex: 0,
        onDestinationSelected: (value) {
          print("select $value");
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("AddIX");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
