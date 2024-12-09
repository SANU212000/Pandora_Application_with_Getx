import 'package:flutter/material.dart';
import 'package:todo_list/screens/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final hasUsername = prefs.containsKey('username');

  runApp(TodoApp(
    initialRoute: hasUsername ? '/home' : '/userScreen',
  ));
}
