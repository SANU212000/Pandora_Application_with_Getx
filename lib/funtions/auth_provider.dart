import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  String? _user;
  bool _isOtpVerified = false;

  String? get user => _user;
  bool get isOtpVerified => _isOtpVerified;

  bool get isLoggedIn => _user != null;

  final String _loginUrl = 'https://sampleapi.stackmod.info/api/v1/auth/login';

  get canResendOtp => null;

  get countdown => null;

  void signUp(String email, String password) {
    _user = email;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      print('Attempting to login with email: $email and password: $password');

      final response = await http
          .post(
        Uri.parse(_loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw 'The request timed out. Please try again.';
      });

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('token')) {
          final String token = responseData['token'];
          print('Login successful. Token: $token');
          _user = email;
          notifyListeners();
          return true;
        } else {
          print('Login failed: Token not found.');
          return false;
        }
      } else {
        print('Login failed: Unexpected error.');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  void verifyOtp(String otp) {
    if (otp == '4040') {
      _isOtpVerified = true;
      notifyListeners();
    }
  }

  void resendOtp(String email) {
    print('Resending OTP to $email');
    notifyListeners();
  }

  void logout() {
    _user = null;
    _isOtpVerified = false;
    notifyListeners();
  }
}
