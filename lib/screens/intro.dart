import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/screens/ListofUser.dart';
import 'package:todo_list/screens/screen1.dart';
import 'package:todo_list/screens/constants.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _fadeAnimationSecondary;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimationSecondary = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );

    _controller.forward();

    _checkUsernameAndNavigate();
  }

  Future<void> _checkUsernameAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final hasUsername = prefs.containsKey('username');

    Future.delayed(const Duration(seconds: 4), () {
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                hasUsername ? TodoScreen() : const UserListScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: const Text(
                      "Pandora",
                      style: TextStyle(
                        fontFamily: "intro",
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Opacity(
                  opacity: _fadeAnimationSecondary.value,
                  child: const Text(
                    "stability for your time",
                    style: TextStyle(
                      fontFamily: "intro",
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      backgroundColor: kPrimaryColor,
    );
  }
}
