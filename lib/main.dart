import 'package:budget_tracker/utils/db_helper.dart';
import 'package:budget_tracker/view/add_ix.dart';
import 'package:budget_tracker/view/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.dbHelper.initDb();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/",
      getPages: [
        GetPage(
          name: "/",
          page: () => HomeScreen(),
        ),
        GetPage(
          name: "/AddIX",
          page: () => AddIX(),
        )
      ],
    );
  }
}
