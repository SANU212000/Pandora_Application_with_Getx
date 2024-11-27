import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/funtions/controller.dart';
import 'package:todo_list/screens/constants.dart';

class TaskListScreen extends StatelessWidget {
  final TodoController controller = Get.find<TodoController>();
  final TextEditingController _textController = TextEditingController();

  TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        backgroundColor: kPrimaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
        ),
        flexibleSpace: Center(
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    offset: Offset(-0, -0),
                  ),
                ]),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: kWhiteColor),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 45.0, left: 16, right: 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
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
                const SizedBox(width: 1),
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
                  child: const Icon(
                    Icons.add,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
