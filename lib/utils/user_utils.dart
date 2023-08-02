import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'constants.dart';

class UserState extends ChangeNotifier {
  String? _userId;
  String? _userCategory;
  String? _userLabel = '';

  String? get userId => _userId;
  String? get userLabel => _userLabel;

  bool get isLoggedIn => _userId != null;
  bool get isAdministrator => _userCategory == 'admin';

  void login(String userId, String userLabel) {
    _userId = userId;
    _userLabel = userLabel;
    notifyListeners();
  }

  void logout() {
    _userId = null;
    notifyListeners();
  }
}


// Create a model for Users
class User {
  final String id;
  final String name;
  final String category;

  User({required this.id, required this.name, required this.category});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
    };
  }
}

Future<User> performLogin(String username, String password) async {
  final response = await post(
    Uri.parse('$TPV_SERVER_URL/login'),
    body: jsonEncode({'username': username, 'password': password}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final user = User.fromJson(data);
    return user;
  } else {
    throw Exception('Failed to login');
  }
}