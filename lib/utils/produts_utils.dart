import 'dart:convert';
import 'package:bandolera_tpv/utils/categories_utils.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

List<Product> availableProducts = [];

Future<List<Product>> fetchAvailableProducts(Function setStateCallback, {bool onlyEnabled=false}) async {
  final response = await http.get(Uri.parse('$TPV_SERVER_URL/products/'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final products = List<Product>.from(data.map((product) => Product.fromJson(product)));
    if (onlyEnabled) {
      products.removeWhere((product) => product.enabled == false);
    }
    setStateCallback(products);
    return products;
  } else {
    throw Exception('Failed to fetch available products');
  }
}

// Create a new product
Future<void> createProduct(String name, double price, List<Category>? categories) async {
  print(categories);
  final newProduct = Product(name: name, price: price, categories: categories);
  final response = await http.post(
    Uri.parse('$TPV_SERVER_URL/products/add'),
    body: jsonEncode(newProduct.toJson()),
    headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode == 201) {
    print('Product created');
  } else {
    throw Exception('Failed to create product');
  }
}

Future<void> disableProduct(int product_id) async {
  final response = await http.post(
    Uri.parse('$TPV_SERVER_URL/products/disable'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'id': product_id}),
  );
  if (response.statusCode == 200) {
    print('Product disabled');
  } else {
    throw Exception('Failed to disable product');
  }
}


class Product {
  final String name;
  final double price;
  final List<Category>? categories;
  final int? id;
  final bool? enabled;

  Product({required this.name, required this.price, this.categories, this.id, this.enabled});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      enabled: json['enabled'] ?? true,
      categories: json['categories'] != null
          ? List<Category>.from(
              json['categories']
                  .map((categoryJson) => Category.fromJson(categoryJson)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'name': name,
      'price': price,
      'categories': categories ?? '',
    };
  }
}
