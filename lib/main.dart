import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/funtions/controller.dart';
// import 'package:todo_list/funtions/databasehelper.dart';
import 'package:todo_list/funtions/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeChanger = Get.put(ThemeChanger());
  await themeChanger.loadtheme();

  runApp(const TodoApp());
}
