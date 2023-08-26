import 'dart:convert'; // Agrega esta importación para poder usar jsonDecode
import 'package:http/http.dart' as http; // Debes usar 'http' como alias en lugar de 'http'
import 'constants.dart';

Future<List<Map<String, dynamic>>> getTopProducts() async {
  final response = await http.get(Uri.parse('$TPV_SERVER_URL/analytics/top_products'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body); // Decodifica el cuerpo de la respuesta, no la respuesta completa
    final topProducts = List<Map<String, dynamic>>.from(data);
    return topProducts;
  } else {
    throw Exception('Failed to load top products');
  }
}


Future<Map<String, int>> getSalesByDay() async {
  final response = await http.get(Uri.parse('$TPV_SERVER_URL/analytics/sales_by_weekly_day'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final salesByDay = Map<String, int>.from(data);
    return salesByDay;
  } else {
    throw Exception('Failed to load sales by day');
  }
}

Future<Map<String, int>> getSalesByHours() async {
  final response = await http.get(Uri.parse('$TPV_SERVER_URL/analytics/sales_by_hour'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final salesByDay = Map<String, int>.from(data);
    return salesByDay;
  } else {
    throw Exception('Failed to load sales by day');
  }
}