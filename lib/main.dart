import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo_list/funtions/controller.dart';
import 'package:todo_list/funtions/databasehelper.dart';
import 'package:todo_list/screens/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper.instance;
  final usernames = await dbHelper.getUsernames();
  // final hasUsername = usernames.isNotEmpty;
  final themeChanger = Get.put(ThemeChanger());
  await themeChanger.loadtheme();

  runApp(TodoApp(
    initialRoute: '/' '/userScreen',
  ));
}
