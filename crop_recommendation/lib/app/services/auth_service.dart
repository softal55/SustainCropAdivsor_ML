import 'dart:convert';
import 'package:crop_recommendation/app/models/user.dart';
import 'package:crop_recommendation/app/services/base_url.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static String loginUrl = '${BaseUrl.authUrl}/login';
  static String registerUrl = '${BaseUrl.authUrl}/register';
  // static const String verifyOtpUrl = '${BaseUrl.authUrl}/verify-otp'; // <-- DELETED
  final GetStorage _storage = GetStorage();

  Future<bool> login({required String email, required String password}) async {
    try {
      final url = Uri.parse(loginUrl);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        String token = data['access_token'];
        debugPrint(token);
        await _storage.write('token', token);
        return true;
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Login failed';
        debugPrint(error);
        return false;
      }
    } catch (e) {
      debugPrint('Login failed: $e');
      return false;
    }
  }

  Future<bool> register({required User user}) async {
    try {
      final url = Uri.parse(registerUrl);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toMap()),
      );

      // --- MODIFIED BLOCK ---
      // We now expect 201 and an access token, just like login.
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        String token = data['access_token'];
        await _storage.write('token', token);
        debugPrint('Registration successful, token saved.');
        return true;
      } else {
        final error =
            jsonDecode(response.body)['message'] ?? 'Registration failed';
        debugPrint(error);
        return false;
      }
      // --- END MODIFIED BLOCK ---
    } catch (e) {
      debugPrint('Registration failed: $e');
      return false;
    }
  }

  // --- DELETED ---
  // The entire verifyOtp method has been removed.
  // --- END DELETED ---

  Future<void> logout() async {
    await _storage.remove('token');
  }
}
