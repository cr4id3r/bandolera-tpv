import 'dart:convert';

import 'package:http/http.dart' as http;

import 'constants.dart';

class Category {
  final int? id;
  final String name;

  Category({
    this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id ?? '',
    };
  }
}

Future<List<Category>> getAvailableCategories(Function setStateCallback) async {
  final response = await http.get(Uri.parse('$TPV_SERVER_URL/categories/'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final categories = List<Category>.from(data.map((category) => Category.fromJson(category)));
    setStateCallback(categories);
    return categories;
  } else {
    throw Exception('Failed to fetch available categories');
  }
}

// Create a function to save a new category
Future<void> saveCategory(String categoryName) async {
  final newCategory = Category(name: categoryName);
  final response = await http.post(
    Uri.parse('$TPV_SERVER_URL/categories/add'),
    body: jsonEncode(newCategory.toJson()),
    headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode == 201) {
    print('Product created');
  } else {
    throw Exception('Failed to create product');
  }
}
