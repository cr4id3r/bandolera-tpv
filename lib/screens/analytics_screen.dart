import 'package:flutter/material.dart';
import '../base_layout.dart';
import 'analytics/sales_by_days.dart';
import 'analytics/sales_by_hours.dart';
import 'analytics/sales_by_product.dart';

class AnalyticScreen extends StatefulWidget {
  @override
  _AnalayticsScreenState createState() => _AnalayticsScreenState();
}

class _AnalayticsScreenState extends State<AnalyticScreen> {
  final List<Map<String, dynamic>> data = [];
  String target_analytics = 'demo';

  @override
  void initState() {
    super.initState();
  }

  void setNewTargetAnalytics(String target) {
    setState(() {
      target_analytics = target;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analitica'),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Container(
                alignment: Alignment.center,
                constraints: const BoxConstraints(maxWidth: 800),
                child: TopAnalyticsMenu(setNewTargetAnalytics: setNewTargetAnalytics)),
            const SizedBox(height: 50),
            // Diferentes graficas segun target_analytics
            if (target_analytics == 'top_products')
              const SalesByProduct()
            else if (target_analytics == 'sales_by_hour')
              const SalesByHours()
            else if (target_analytics == 'sales_by_day')
              const SalesByDays()
            else
              const Text('demo')
          ],
        ),
      ),
    );
  }
}


class TopAnalyticsMenu extends StatelessWidget {
  final Function setNewTargetAnalytics; // Declaración del callback

  const TopAnalyticsMenu({Key? key, required this.setNewTargetAnalytics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setNewTargetAnalytics('top_products');
            },
            child: const Text('Productos mas vendidos'),
          ),
        ),
        const SizedBox(width: 10), // Espacio entre los botones
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setNewTargetAnalytics('sales_by_hour');
            },
            child: const Text('Ventas por horas'),
          ),
        ),
        const SizedBox(width: 10), // Espacio entre los botones
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setNewTargetAnalytics('sales_by_day');
            },
            child: const Text('Ventas por dias'),
          ),
        ),
      ],
    );
  }
}

