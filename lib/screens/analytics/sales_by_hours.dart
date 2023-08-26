import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../utils/analytics_utils.dart';

class SalesByHours extends StatefulWidget {
  const SalesByHours({Key? key}) : super(key: key);

  @override
  _SalesByHoursState createState() => _SalesByHoursState();
}

class _SalesByHoursState extends State<SalesByHours> {
  Map<String, int> data = {};

  @override
  void initState() {
    super.initState();
    getSalesByHours().then((value) {
      // Check if continue mounted
      if (!mounted) {
        return;
      }

      setState(() {
        data = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 500),
      alignment: Alignment.center,
      child: data.isEmpty ?
      const Text('Cargando datos...') :
      BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: data.values.reduce(max).toDouble(),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTitles: (double value) {
                // Transform value into string
                final int hour = value.toInt();
                final String valueString = hour.toString();
                return valueString;
              },
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: data.entries.map((entry) {
            return BarChartGroupData(
              x: int.parse(entry.key), // Convertir la clave a int
              barRods: [BarChartRodData(y: entry.value.toDouble())],
            );
          }).toList(),
        ),
      ),
    );
  }
}
