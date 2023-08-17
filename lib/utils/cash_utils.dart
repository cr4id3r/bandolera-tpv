import 'dart:convert';
import 'package:http/http.dart' as http;

import 'constants.dart';

Future<Map<String, dynamic>> calculateTotalCash() async {
  final response = await http.get(Uri.parse('$TPV_SERVER_URL/cash/get_actual_cash'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data as Map<String, dynamic>;
  } else {
    throw Exception('Failed to fetch available products');
  }
}
