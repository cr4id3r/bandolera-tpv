import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../utils/analytics_utils.dart';

class SalesByDays extends StatefulWidget {
  const SalesByDays({Key? key}) : super(key: key);

  @override
  _SalesByDaysState createState() => _SalesByDaysState();
}

class _SalesByDaysState extends State<SalesByDays> {
  Map<String, int> data = {};

  @override
  void initState() {
    super.initState();
    getSalesByDay().then((value) {
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
                // Mapear los valores de X a los nombres de los días de la semana
                final int day = value.toInt();
                switch (day) {
                  case 0:
                    return 'Lun';
                  case 1:
                    return 'Mar';
                  case 2:
                    return 'Mié';
                  case 3:
                    return 'Jue';
                  case 4:
                    return 'Vie';
                  case 5:
                    return 'Sáb';
                  case 6:
                    return 'Dom';
                  default:
                    return '';
                }
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
