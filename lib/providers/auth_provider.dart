import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  bool isLogedIn = false;
  bool isLoading = false;

  start() async {
    isLoading = true;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      isLogedIn = true;
    } else {
      isLogedIn = false;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', 'ABCD');
    return true;
  }

  // Future<bool>
  register(Map<String, String> jsonBody) async {
    
    final response = await http.post(
        Uri.parse(
          "https://api.ha-k.ly/api/v1/client/auth/register",
        ),
        headers: {
          "Accept": 'application/json',
          "Content-Type": 'application/json'
        },
        body: json.encode(jsonBody));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return [true, 'Account Created Successfully login now.'];
    } else {
      return [false, json.decode(response.body)['message']];
    }
  }

  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
    return true;
  }
}
