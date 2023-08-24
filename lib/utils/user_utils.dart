import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'constants.dart';


// Create a model for Users
class User {
  final String id;
  final String username;
  final String name;
  final String category;
  final String imageUrl = 'https://picsum.photos/200';

  User({required this.id, required this.username, required this.name, required this.category});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
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
    Uri.parse('$TPV_SERVER_URL/users/login'),
    body: jsonEncode({'username': username, 'password': password}),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final user = User.fromJson(data);
    return user;
  } else {
    throw Exception('Failed to login');
  }
}

Future<List<User>> getAllUsers() async {
  final response = await get(Uri.parse('$TPV_SERVER_URL/users/get_all'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final users = data.map<User>((json) => User.fromJson(json)).toList();
    return users;
  } else {
    throw Exception('Failed to load users');
  }
}


Future<bool> createUser(String name, String username, String password, String category) async {
  final response = await post(
    Uri.parse('$TPV_SERVER_URL/users/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'name': name,
      'username': username,
      'password': password,
      'category': category,
    })
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Failed to create user');
  }
}

class UserState extends ChangeNotifier {
  User? _loggedInUser;

  User? get loggedInUser => _loggedInUser;

  void loginUser(User user) {
    _loggedInUser = user;
    notifyListeners();
  }

  void logoutUser() {
    _loggedInUser = null;
    notifyListeners();
  }
}