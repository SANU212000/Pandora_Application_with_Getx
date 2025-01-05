import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/screens/loginpage.dart';
import 'package:todo_list/screens/screen1.dart';
import 'package:todo_list/funtions/constants.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  Future<String> determineInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    if (refreshToken != null && refreshToken.isNotEmpty) {
      print('Refresh token retrieved: $refreshToken');
      return '/home';
    }

    print('No refresh token found.');
    return '/userScreen';
  }

  Future<void> navigateAfterDelay(BuildContext context) async {
    final initialRoute = await determineInitialRoute();
    await Future.delayed(const Duration(seconds: 4));

    if (initialRoute == '/home') {
      Get.offAll(() => TodoScreen(email: ''));
    } else {
      Get.offAll(() => const Login());
    }
  }

  @override
  Widget build(BuildContext context) {
    navigateAfterDelay(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.5, end: 2.0),
              duration: const Duration(seconds: 3),
              curve: Curves.bounceOut,
              builder: (context, scaleValue, child) {
                return Transform.scale(
                  scale: scaleValue,
                  child: const Text(
                    "Pandora",
                    style: TextStyle(
                      fontFamily: "intro",
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 5),
            // Fade Animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 2),
              builder: (context, opacityValue, child) {
                return Opacity(
                  opacity: opacityValue,
                  child: const Text(
                    "stability for your time",
                    style: TextStyle(
                      fontFamily: "intro",
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: kPrimaryColor,
    );
  }
}
