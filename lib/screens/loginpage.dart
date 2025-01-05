import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/funtions/constants.dart';
import 'package:todo_list/screens/addnewusers.dart';
import 'package:todo_list/screens/screen1.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
    print("Tokens saved: AccessToken=$accessToken, RefreshToken=$refreshToken");
  }

  Future<Map<String, dynamic>> fetchUserData(
      String email, String password) async {
    const String apiUrl = 'https://sampleapi.stackmod.info/api/v1/auth/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Login successful: $data");

        if (data['accessToken'] != null && data['refreshToken'] != null) {
          await saveTokens(data['accessToken'], data['refreshToken']);
          return {
            'status': 'success',
            'message': 'Login successful',
            'email': email,
          };
        } else {
          return {
            'status': 'error',
            'message': 'No tokens received, please try again',
          };
        }
      } else {
        final errorData = json.decode(response.body);
        return {
          'status': 'error',
          'message': errorData['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Network error: $e'};
    }
  }

  // Future<Map<String, dynamic>> fetchUserDetails(String accessToken) async {
  //   const String userApiUrl =
  //       'https://sampleapi.stackmod.info/api/v1/auth/user';

  //   try {
  //     final response = await http.get(
  //       Uri.parse(userApiUrl),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $accessToken',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final userData = json.decode(response.body);
  //       print("User data retrieved: $userData");
  //       return {'status': 'success', 'data': userData};
  //     } else {
  //       final errorData = json.decode(response.body);
  //       return {
  //         'status': 'error',
  //         'message': errorData['message'] ?? 'Failed to fetch user data',
  //       };
  //     }
  //   } catch (e) {
  //     return {'status': 'error', 'message': 'Network error: $e'};
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final obscureText = true.obs;
    final isLoading = false.obs;

    InputDecoration buildInputDecoration(String label) {
      return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock, size: 100, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to Pandora',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: buildInputDecoration('Email'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                              if (!emailRegex.hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Obx(() {
                            return TextFormField(
                              controller: passwordController,
                              decoration:
                                  buildInputDecoration('Password').copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscureText.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    obscureText.value = !obscureText.value;
                                  },
                                ),
                              ),
                              obscureText: obscureText.value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            );
                          }),
                          const SizedBox(height: 20),
                          Obx(() {
                            return isLoading.value
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        isLoading.value = true;
                                        final response = await fetchUserData(
                                          emailController.text,
                                          passwordController.text,
                                        );
                                        isLoading.value = false;

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(response['message'] ??
                                                'Login Failed'),
                                          ),
                                        );

                                        if (response['status'] == 'success') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TodoScreen(
                                                email: response['email'],
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: const Text('Sign In'),
                                  );
                          }),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddNewUser(),
                                ),
                              );
                            },
                            child: const Text(
                              'New User? Register here',
                              style: TextStyle(color: kPrimaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
