import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/funtions/controller.dart';
import 'package:todo_list/funtions/userSM.dart';
import 'package:todo_list/screens/screen1.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserNameController userNameController = Get.put(UserNameController());

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              final themeProvider = Get.find<ThemeChanger>();
              if (themeProvider.themeMode.value == ThemeMode.light) {
                themeProvider.setTheme(ThemeOption.dark);
              } else {
                themeProvider.setTheme(ThemeOption.light);
              }
            },
            icon: const Icon(Icons.brightness_6),
          )
        ],
        backgroundColor: Colors.blue,
      ),
      body: Obx(
        () {
          if (userNameController.username.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(40.0),
            child: ListView.builder(
              itemCount: userNameController.username.length,
              itemBuilder: (context, index) {
                final selectedUsername = userNameController.username[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    title: Text(
                      selectedUsername,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Get.lazyPut(() => TodoController());
                      final todoController = Get.find<TodoController>();
                      todoController.setUsername(selectedUsername);
                      Get.to(() => TodoScreen());
                      print("$selectedUsername is tapped");
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            String newUsername = await showEditUsernameDialog(
                                context, selectedUsername);
                            if (newUsername.isNotEmpty) {
                              await userNameController.updateUsername(
                                  selectedUsername, newUsername);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await userNameController
                                .deleteUsername(selectedUsername);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddUsernameDialog(context, userNameController),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

void showAddUsernameDialog(
    BuildContext context, UserNameController usernameController) {
  final TextEditingController userNameController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add New Username'),
        content: TextField(
          controller: userNameController,
          decoration: const InputDecoration(hintText: 'Enter username'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              String username = userNameController.text;
              if (username.isNotEmpty) {
                await usernameController.addUsername(username);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}

Future<String> showEditUsernameDialog(
    BuildContext context, String oldUsername) async {
  final TextEditingController usernameController =
      TextEditingController(text: oldUsername);

  String newUsername = oldUsername;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Username'),
        content: TextField(
          controller: usernameController,
          decoration: const InputDecoration(hintText: 'Enter new username'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              newUsername = usernameController.text;
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
  return newUsername;
}
