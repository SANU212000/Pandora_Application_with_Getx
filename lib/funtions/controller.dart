import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'todo_list.dart';

class TodoController extends GetxController {
  var username = ''.obs;

  void setUsername(String newUsername) {
    username.value = newUsername;
  }

  final String apiUrll =
      'https://crudcrud.com/api/7f98fd4093df4618becf5a15f4a2c43f/';
  var myString = "".obs;
  final bool _isLoading = false;
  bool get isLoading => _isLoading;
  RxList<Todo> todos = <Todo>[].obs;
  var isLoadingg = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodosFromApi();
  }

  Future<void> fetchTodosFromApi() async {
    final String apiUrl = '$apiUrll$username/todos';
    try {
      isLoadingg.value = true;
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> todoJson = json.decode(response.body);
        todos.value = todoJson.map((json) => Todo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load todos');
      }
    } catch (e) {
      print('Error fetching todos: $e');
      Get.snackbar('Error', 'Failed to load todos');
    } finally {
      isLoadingg.value = false;
    }
    todos.refresh();
  }

  Future<void> addTodo(String title) async {
    final List<Color> colorList = [
      const Color.fromARGB(255, 175, 16, 5),
      const Color.fromARGB(255, 3, 67, 5),
      const Color.fromARGB(255, 10, 75, 128),
      const Color.fromARGB(255, 85, 11, 98),
      const Color.fromARGB(255, 11, 119, 83),
    ];

    final Color cardColor = colorList[Random().nextInt(colorList.length)];
    final newTodo = Todo(
        id: const Uuid().v4(),
        title: title,
        isCompleted: false,
        color: cardColor,
        username: '');

    try {
      final response = await http.post(
        Uri.parse('$apiUrll$username/todos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': newTodo.title,
          'isCompleted': newTodo.isCompleted,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        newTodo.id = responseData['_id'];
        todos.add(newTodo);
      } else {
        throw Exception(
            'Failed to save todo. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving todo: $e');
      Get.snackbar('Error', 'Failed to save todo');
    }
    todos.refresh();
  }

  Future<void> removeTodo(String id) async {
    try {
      todos.removeWhere((todo) => todo.id == id);
      await deleteTodoFromApi(id);
    } catch (e) {
      print('Error deleting todo: $e');
      Get.snackbar('Error', 'Failed to delete todo');
    }
    todos.refresh();
  }

  Future<void> toggleTodoStatus(String id) async {
    final index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final originalStatus = todos[index].isCompleted;
      todos[index].isCompleted = !originalStatus;
      todos.refresh();
      try {
        await updateTodoToApi(todos[index]);
      } catch (error) {
        todos[index].isCompleted = originalStatus;
        todos.refresh();
        print('Error updating status: $error');
        Get.snackbar('Error', 'Failed to update status');
      }
    }
    todos.refresh();
  }

  Future<void> updateTodoToApi(Todo todo) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrll$username/todos/${todo.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': todo.title,
          'isCompleted': todo.isCompleted,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update todo');
      }
    } catch (e) {
      print('Error updating todo: $e');
      Get.snackbar('Error', 'Failed to update todo');
    }
    todos.refresh();
  }

  Future<void> updateTodo(String id,
      {String? newTitle, bool? newStatus}) async {
    final index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      if (newTitle != null) {
        todos[index].title = newTitle;
      }
      if (newStatus != null) {
        todos[index].isCompleted = newStatus;
      }
      todos.refresh();
      await updateTodoToApi(todos[index]);
    }
    todos.refresh();
  }

  Future<void> deleteTodoFromApi(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrll$username/todos/$id'),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete todo');
      }
    } catch (e) {
      print('Error deleting todo: $e');
      Get.snackbar('Error', 'Failed to delete todo');
    }
  }
}

enum ThemeOption { light, dark }

class ThemeChanger extends GetxController {
  var themeMode = ThemeMode.system.obs;

  void setTheme(ThemeOption themeOption) {
    switch (themeOption) {
      case ThemeOption.light:
        themeMode.value = ThemeMode.light;
        break;
      case ThemeOption.dark:
        themeMode.value = ThemeMode.dark;
        break;
    }
    savetheme();
  }

  void savetheme() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('themedata', themeMode.value.toString());
    print('Saved theme: ${themeMode.value}');
  }

  Future<void> loadtheme() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final savedtheme = pref.getString('themedata');
    if (savedtheme != null) {
      themeMode.value = ThemeMode.values.firstWhere(
        (element) => element.toString() == savedtheme,
        orElse: () => ThemeMode.system,
      );
    }
    print('Loaded theme: ${themeMode.value}');
  }
}
