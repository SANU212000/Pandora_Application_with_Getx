import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/funtions/controller.dart';
import 'package:todo_list/funtions/todo_list.dart';
import 'dart:math';

class TodoScreen extends StatelessWidget {
  final TodoController controller = Get.put(TodoController());
  final TextEditingController _textController = TextEditingController();

  TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.white, // Set the background color for the body
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
                  color: Color.fromRGBO(210, 4, 45, 1), // Full opacity
                  wordSpacing: 2.0,
                  letterSpacing: 0.5,
                  height: 0.8,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter a task',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: () async {
                      if (_textController.text.isNotEmpty) {
                        await controller.addTodo(_textController.text);
                        _textController.clear();
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.todos.isEmpty) {
                  return const Center(
                    child: Text(
                      'No tasks available. Add some!',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  child: ListView.builder(
                    itemCount: controller.todos.length,
                    itemBuilder: (context, index) {
                      final todo = controller.todos[index];
                      final double offset =
                          10.0 * index; // Adjust for stacking effect
                      return Transform.translate(
                        offset: Offset(0, offset),
                        child: Dismissible(
                          key: Key(todo.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 10),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
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
                                        Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
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
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                          child: buildStackedTaskTile(todo, context),
                        ),
                      );
                    },
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  // Widget buildStackedTaskTile(Todo todo, BuildContext context) {
  //   final List<Color> colorList = [
  //     Colors.red,
  //     Colors.green,
  //     Colors.blue,
  //     Colors.purple,
  //     Colors.yellow,
  //   ];

  //   final randomColor = colorList[Random().nextInt(colorList.length)];

  //   return Container(
  //     height: 100,
  //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //     decoration: BoxDecoration(
  //       color: randomColor,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: const [
  //         BoxShadow(
  //           color: Colors.black26,
  //           blurRadius: 6,
  //           offset: Offset(-10, 10),
  //         ),
  //       ],
  //     ),
  //     child: ListTile(
  //       contentPadding:
  //           const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  //       title: Text(
  //         todo.title,
  //         style: TextStyle(
  //           fontSize: 20,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.black87,
  //           decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
  //         ),
  //       ),
  //       trailing: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Checkbox(
  //             value: todo.isCompleted,
  //             onChanged: (value) async {
  //               await controller.toggleTodoStatus(todo.id);
  //             },
  //           ),
  //           IconButton(
  //             icon: const Icon(Icons.edit, color: Colors.black54),
  //             onPressed: () {
  //               showUpdateDialog(context, todo.id, todo.title);
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget buildStackedTaskTile(Todo todo, BuildContext context) {
    // List of predefined colors
    final List<Color> colorList = [
      const Color.fromARGB(255, 254, 19, 2),
      const Color.fromARGB(255, 7, 62, 9),
      const Color.fromARGB(255, 2, 60, 108),
      const Color.fromARGB(255, 72, 4, 84),
      const Color.fromARGB(255, 3, 126, 85),
    ];

    // Randomly select a color from the list
    final randomColor = colorList[Random().nextInt(colorList.length)];

    return Container(
      height: 100, // Height to keep it compact
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: randomColor, // Apply random color
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(
              0,
              -10,
            ), // Small shadow for elevation effect
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        title: Text(
          todo.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Text color inside the card
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: todo.isCompleted
            ? Icon(
                Icons.check_circle,
                color: Colors.white,
              )
            : null, // Only show check icon if the task is completed
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
                  await controller.updateTodo(id,
                      newTitle: updateController.text);
                  Navigator.of(context).pop();
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
