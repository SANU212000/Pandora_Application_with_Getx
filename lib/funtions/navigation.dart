import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/screens/loginpage.dart';
import 'package:todo_list/screens/screen1.dart';
import 'package:todo_list/screens/intro.dart';
import 'package:todo_list/funtions/controller.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themechanger = Get.put(ThemeChanger());

    return Obx(() => GetMaterialApp(
          title: 'Todo App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themechanger.themeMode.value,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          getPages: [
            GetPage(
              name: '/',
              page: () => const IntroScreen(),
            ),
            GetPage(
              name: '/userScreen',
              page: () => const Login(),
            ),
            GetPage(
              name: '/home',
              page: () => TodoScreen(email: 'user'),
            ),
            GetPage(
              name: '/TodoScreen',
              page: () => TodoScreen(email: 'user'),
              binding: BindingsBuilder(() {
                Get.put(TodoController());
              }),
            ),
          ],
        ));
  }
}


// class TodoApp extends StatelessWidget {
//   const TodoApp({super.key});

// Future<String> determineInitialRoute() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final accessToken = prefs.getString('accessToken',);

//   if (accessToken != null && accessToken.isNotEmpty) {
//     print('Access token retrieved: $accessToken');
//     return '/home';
//   }

//   print('No access token found.');
//   return '/userScreen';
// }
// Future<String> determineInitialRoute() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final refreshToken = prefs.getString('refreshToken');

//   if (refreshToken != null && refreshToken.isNotEmpty) {
//     print('Refresh token retrieved: $refreshToken');
//     return '/home';
//   }

//   print('No refresh token found.');
//   return '/userScreen';
// }

// @override
// Widget build(BuildContext context) {
//   final themechanger = Get.find<ThemeChanger>();

//   return FutureBuilder<String>(
//     future: determineInitialRoute(),
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       final initialRoute = snapshot.data ?? '/';

//       return Obx(() => GetMaterialApp(
//             title: 'Todo App',
//             theme: ThemeData.light(),
//             darkTheme: ThemeData.dark(),
//             themeMode: themechanger.themeMode.value,
//             debugShowCheckedModeBanner: false,
//             initialRoute: initialRoute,
//             getPages: [
//               GetPage(
//                 name: '/',
//                 page: () => const IntroScreen(),
//               ),
//               GetPage(
//                 name: '/userScreen',
//                 page: () => const Login(),
//               ),
//               GetPage(
//                 name: '/home',
//                 page: () => TodoScreen(),
//               ),
//               GetPage(
//                 name: '/TodoScreen',
//                 page: () => TodoScreen(),
//                 binding: BindingsBuilder(() {
//                   Get.put(TodoController());
//                 }),
//               ),
//             ],
//           ));
//     },
//   );
// }

