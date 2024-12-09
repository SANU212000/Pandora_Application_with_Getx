import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/funtions/controller.dart';
import 'package:todo_list/funtions/todo_list.dart';
import 'package:todo_list/screens/ListofUser.dart';
import 'package:todo_list/screens/add_task.dart';
import 'package:todo_list/screens/constants.dart';

class TodoScreen extends StatelessWidget {
  final TodoController controller = Get.put(TodoController());

  final String username = Get.arguments ?? 'Guest';
  TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome, $username',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserListScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.edit,
            color: kPrimaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Text(
                'To-Do List',
                textHeightBehavior: TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false,
                ),
                style: TextStyle(
                  fontSize: 150,
                  fontFamily: "intro",
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                  wordSpacing: 2.0,
                  letterSpacing: 0.5,
                  height: 0.8,
                ),
              ),
            ),
            Expanded(
                child: SizedBox(
                    width: 350,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 10,
                      shadowColor: kPrimaryColor,
                      surfaceTintColor: kWhiteColor,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0, bottom: 14),
                        child: Obx(() {
                          final controller = Get.find<TodoController>();
                          if (controller.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (controller.todos.isEmpty) {
                            return const Center(
                              child: Text(
                                'No tasks available. Add some!',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            );
                          }
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.easeOut,
                            child: ListView.builder(
                              itemCount: controller.todos.length,
                              itemBuilder: (context, index) {
                                final todo = controller.todos[index];
                                final double offset = -30.0 * index;
                                return Transform.translate(
                                  offset: Offset(4, offset),
                                  child: Dismissible(
                                    key: Key(todo.id),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 10),
                                      child: const Icon(Icons.delete,
                                          color: Colors.white),
                                    ),
                                    confirmDismiss: (direction) async {
                                      return await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Delete Task'),
                                          content: const Text(
                                              'Are you sure you want to delete this task?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    onDismissed: (direction) {
                                      controller.removeTodo(todo.id);
                                      Get.snackbar(
                                        'Task Deleted',
                                        '${todo.title} has been removed.',
                                        snackPosition: SnackPosition.TOP,
                                      );
                                    },
                                    child: buildStackedTaskTile(todo, context),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ),
                    ))),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskListScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                ),
                child: const Text(
                  '+',
                  style: TextStyle(fontSize: 30, color: kPrimaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStackedTaskTile(Todo todo, BuildContext context) {
    return Container(
      height: 130,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        color: todo.isCompleted ? Colors.grey : todo.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(-1, -12),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        title: Text(
          todo.title,
          style: TextStyle(
            fontFamily: "intro",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: todo.isCompleted ? Colors.black : Colors.white,
          ),
          // overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                showUpdateDialog(context, todo.id, todo.title);
              },
            ),
            Transform.scale(
              scale: 2,
              child: Checkbox(
                value: todo.isCompleted,
                onChanged: (bool? value) async {
                  if (value != null) {
                    await controller.toggleTodoStatus(todo.id);
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                activeColor: Colors.white,
                checkColor: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  void showUpdateDialog(BuildContext context, String id, String currentTitle) {
    final TextEditingController updateController =
        TextEditingController(text: currentTitle);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Task'),
          content: TextField(
            controller: updateController,
            decoration: const InputDecoration(labelText: 'Update the task'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (updateController.text.isNotEmpty) {
                  await controller.updateTodo(
                    id,
                    newTitle: updateController.text,
                  );
                  Navigator.of(context).pop();

                  Get.snackbar(
                    'Task Updated',
                    '${updateController.text} has been updated.',
                    snackPosition: SnackPosition.TOP,
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
