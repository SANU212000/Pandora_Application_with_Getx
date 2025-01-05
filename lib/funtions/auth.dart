import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String apiUrl =
      'https://sampleapi.stackmod.info/api/v1/auth/login';

  Future<Map<String, dynamic>> fetchUserData(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['accessToken'] != null && data['refreshToken'] != null) {
          // Save tokens locally using SharedPreferences
          await _saveTokens(data['accessToken'], data['refreshToken']);

          return {
            'status': 'success',
            'message': 'Login successful',
            'email': email
          };
        } else {
          return {
            'status': 'error',
            'message': 'No tokens received, please try again'
          };
        }
      } else {
        final errorData = json.decode(response.body);
        return {
          'status': 'error',
          'message': errorData['message'] ?? 'Login failed'
        };
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Network error: $e'};
    }
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
    print("Tokens saved successfully");
  }

  Future<void> refreshToken() async {
    const String refreshUrl =
        'https://sampleapi.stackmod.info/api/v1/auth/refresh';

    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');

      if (refreshToken == null) {
        throw Exception("No refresh token found");
      }

      final response = await http.post(
        Uri.parse(refreshUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['accessToken'] != null && data['refreshToken'] != null) {
          await _saveTokens(data['accessToken'], data['refreshToken']);
          print("Tokens refreshed successfully");
        } else {
          throw Exception("Invalid token response");
        }
      } else {
        throw Exception("Failed to refresh token");
      }
    } catch (e) {
      print("Error refreshing token: $e");
    }
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    print("Tokens cleared");
  }
}
