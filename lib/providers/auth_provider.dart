import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  static const String _userKey = 'registered_user';
  static const String _loginKey = 'is_logged_in';

  UserModel? _user;
  bool _isLoggedIn = false;
  bool _isLoading = true;

  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  AuthProvider() {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();

    final userData = prefs.getString(_userKey);
    _isLoggedIn = prefs.getBool(_loginKey) ?? false;

    if (userData != null) {
      final Map<String, dynamic> json =
          jsonDecode(userData) as Map<String, dynamic>;

      _user = UserModel.fromJson(json);
    }

    // Invalid or incomplete session ko logged out rakho.
    if (_user == null) {
      _isLoggedIn = false;
      await prefs.setBool(_loginKey, false);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final user = UserModel(
        name: name.trim(),
        email: email.trim().toLowerCase(),
        password: password,
      );

      await prefs.setString(_userKey, jsonEncode(user.toJson()));

      await prefs.setBool(_loginKey, false);

      _user = user;
      _isLoggedIn = false;

      notifyListeners();

      return null;
    } catch (e) {
      return 'Registration failed. Please try again.';
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);

      if (userData == null) {
        return 'No account found. Please sign up first.';
      }

      final Map<String, dynamic> json =
          jsonDecode(userData) as Map<String, dynamic>;

      final savedUser = UserModel.fromJson(json);

      if (savedUser.email != email.trim().toLowerCase() ||
          savedUser.password != password) {
        return 'Invalid email or password.';
      }

      await prefs.setBool(_loginKey, true);

      _user = savedUser;
      _isLoggedIn = true;

      notifyListeners();

      return null;
    } catch (e) {
      return 'Login failed. Please try again.';
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_loginKey, false);

    _isLoggedIn = false;

    notifyListeners();
  }
}
