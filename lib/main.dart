import 'package:flutter/material.dart';
import 'package:todo_list/screens/screen1.dart';
import 'package:todo_list/screens/intro.dart';
import 'package:get/get.dart';
import 'package:todo_list/funtions/controller.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Todo App',
        initialBinding: BindingsBuilder(() {
          Get.put(TodoController());
        }),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => IntroScreen(),
          '/home': (context) => TodoScreen(),
        });
  }
}
