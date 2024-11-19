import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'todo_list.dart';

class TodoController extends GetxController {
  var todos = <Todo>[].obs;
  final String apiUrl =
      'https://crudcrud.com/api/851a15aae07d47d39dca58d2f4d0b416'; // Your API URL

  // Fetch todos from the API when the controller is initialized
  @override
  void onInit() {
    super.onInit();
    fetchTodosFromApi();
  }

  // Fetch todos from API
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

  // Add a new todo
  Future<void> addTodo(String title) async {
    final newTodo = Todo(id: const Uuid().v4(), title: title);
    todos.add(newTodo);
    await saveTodoToApi(newTodo); // Save only the new todo to API
  }

  // Remove a todo by ID
  Future<void> removeTodo(String id) async {
    todos.removeWhere((todo) => todo.id == id);
    await deleteTodoFromApi(id); // Call API to delete the todo
  }

  // Toggle the status of a todo (completed/incomplete)
  Future<void> toggleTodoStatus(String id) async {
    final index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      todos[index].isCompleted = !todos[index].isCompleted;
      await saveTodoToApi(todos[index]); // Save the updated todo status to API
    }
  }

  // Update a todo (title or status)
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
      await saveTodoToApi(todos[index]); // Save the updated todo to API
    }
  }

  // Save an individual todo to API
  Future<void> saveTodoToApi(Todo todo) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(todo.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to save todo');
      }
    } catch (e) {
      print('Error saving todo: $e');
    }
  }

  // Delete a todo from the API
  Future<void> deleteTodoFromApi(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete todo');
      }
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }
}
