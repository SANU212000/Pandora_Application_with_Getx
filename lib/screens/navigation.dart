import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/screens/ListofUser.dart';
import 'package:todo_list/screens/screen1.dart';
import 'package:todo_list/screens/intro.dart';
import 'package:todo_list/funtions/controller.dart';

class TodoApp extends StatelessWidget {
  final String initialRoute;

  const TodoApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo App',
      initialBinding: BindingsBuilder(() {
        Get.put(TodoController());
      }),
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: [
        GetPage(
          name: '/',
          page: () => const IntroScreen(),
        ),
        GetPage(
          name: '/userScreen',
          page: () => const UserListScreen(),
        ),
        GetPage(
          name: '/home',
          page: () => TodoScreen(), // Replace 'Guest' with default username.
        ),
        GetPage(
          name: '/TodoScreen',
          page: () => TodoScreen(),
        ),
      ],
    );
  }
}
