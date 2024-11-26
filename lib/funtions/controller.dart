import 'dart:math';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'todo_list.dart';

class TodoController extends GetxController {
  var todos = <Todo>[].obs;
  final String apiUrl =
      'https://crudcrud.com/api/2cd233f706894574b1761c0f1d005cd2/todos';

  @override
  void onInit() {
    super.onInit();
    fetchTodosFromApi();
  }

  Future<void> fetchTodosFromApi() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> todoJson = json.decode(response.body);
        todos.value = todoJson.map((json) => Todo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load todos');
      }
    } catch (e) {
      print('Error fetching todos: $e');
    }
  }

  Future<void> addTodo(String title) async {
    final List<Color> colorList = [
      const Color.fromARGB(255, 254, 19, 2),
      const Color.fromARGB(255, 7, 62, 9),
      const Color.fromARGB(255, 2, 60, 108),
      const Color.fromARGB(255, 72, 4, 84),
      const Color.fromARGB(255, 3, 126, 85),
    ];

    final Color cardColor = colorList[Random().nextInt(colorList.length)];
    final newTodo = Todo(
        id: const Uuid().v4(),
        title: title,
        isCompleted: false,
        color: cardColor);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
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
    }
  }

  Future<void> removeTodo(String id) async {
    try {
      todos.removeWhere((todo) => todo.id == id);
      await deleteTodoFromApi(id);
    } catch (e) {
      print('Error deleting todo: $e');
    }
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
      }
    }
  }

  Future<void> updateTodoToApi(Todo todo) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${todo.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(todo.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update todo');
      }
    } catch (e) {
      print('Error updating todo: $e');
    }
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
      todos.refresh(); // Notify listeners of the update
      await updateTodoToApi(todos[index]); // Call API to save changes
    }
  }

  Future<void> deleteTodoFromApi(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$id'),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete todo');
      }
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }
}
