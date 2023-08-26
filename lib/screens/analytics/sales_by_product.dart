
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../utils/analytics_utils.dart';

class SalesByProduct extends StatefulWidget {
  const SalesByProduct({Key? key}) : super(key: key); // Corrección aquí

  @override
  State<SalesByProduct> createState() => _SalesByProductState();
}

class _SalesByProductState extends State<SalesByProduct> {
  final List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    getTopProducts().then((value) {
      // Check if continue mounted
      if (!mounted) {
        return;
      }

      setState(() {
        data.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 500),
      alignment: Alignment.center,
      child: PieChart(
        PieChartData(
          sections: generateChartData(data),
        ),
      ),
    );
  }
}

List<PieChartSectionData> generateChartData(List<Map<String, dynamic>> data) {
  List<PieChartSectionData> sections = [];

  if (data.isEmpty) {
    return sections;
  }

  Random random = Random();

  for (var item in data) {
    Color randomColor = Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );

    sections.add(
      PieChartSectionData(
        value: item['quantity'].toDouble(), // Cantidad
        title: '${item['name']} (${item['quantity']})', // Etiqueta
        color: randomColor,
      ),
    );
  }

  return sections;
}
