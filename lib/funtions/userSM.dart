import 'package:get/get.dart';
import 'package:todo_list/funtions/databasehelper.dart';

class UserNameController extends GetxController {
  var username = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUsernames();
  }

  Future<void> loadUsernames() async {
    final dbHelper = DatabaseHelper.instance;
    username.value = await dbHelper.getUsernames();
    if (username.isEmpty) {
      username.value = ['guest'];
    }
    print('loaded usernam $username');
  }

  Future<void> addUsername(String username) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.insertUsername(username);
    await loadUsernames();
    print('add new username: $username');
  }

  Future<void> deleteUsername(String username) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.deleteUsername(username);
    await loadUsernames();
    print("username is deleted:$username");
  }

  Future<void> updateUsername(String oldUsername, String newUsername) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.updateUsername(oldUsername, newUsername);
    final index = username.indexOf(oldUsername);
    if (index != -1) {
      username[index] = newUsername;
    }
  }
}
