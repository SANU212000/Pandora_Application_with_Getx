import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/screens/screen1.dart';
import 'userscreen.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  Future<List<String>> loadUsernames() async {
    final prefs = await SharedPreferences.getInstance();
    final usernames = prefs.getStringList('usernames') ?? [];
    print('Loaded usernames: $usernames');
    return usernames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usernames'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<String>>(
        future: loadUsernames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading usernames.'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No usernames available.'));
          }

          final usernames = snapshot.data!;

          return ListView.builder(
            itemCount: usernames.length,
            itemBuilder: (context, index) {
              final selectedUsername = usernames[index];
              return ListTile(
                title: Text(selectedUsername),
                onTap: () {
                  Get.to(() => TodoScreen(), arguments: selectedUsername);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserNameScreen()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
