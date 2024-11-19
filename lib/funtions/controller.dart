import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'todo_list.dart';

class TodoController extends GetxController {
  var todos = <Todo>[].obs;

  void addTodo(String title) {
    final newTodo = Todo(id: const Uuid().v4(), title: title);
    todos.add(newTodo);
  }

  void removeTodo(String id) {
    todos.removeWhere((todo) => todo.id == id);
  }

  void toggleTodoStatus(String id) {
    final index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      todos[index].isCompleted = !todos[index].isCompleted;
      todos.refresh();
    }
  }

  void updateTodo(String id, {String? newTitle, bool? newStatus}) {
    final index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      if (newTitle != null) {
        todos[index].title = newTitle;
      }
      if (newStatus != null) {
        todos[index].isCompleted = newStatus;
      }
      todos.refresh();
    }
  }
}
