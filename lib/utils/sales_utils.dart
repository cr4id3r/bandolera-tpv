import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'constants.dart';

Future<void> performCheckout(selectedProducts, paymentType) async {
  final products = selectedProducts.map((product) => product.toJson()).toList();
  final HashMap<String, dynamic> post_data = HashMap();

  post_data['products'] = products;
  post_data['payment_method'] = paymentType;

  final response = await http.post(
    Uri.parse('$TPV_SERVER_URL/sales/checkout'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(post_data),
  );
  if (response.statusCode == 200) {
    print('Checkout performed');
  } else {
    throw Exception('Failed to perform checkout');
  }
}
