import 'package:flutter/material.dart';
import '../utils/cash_utils.dart';

class CashScreen extends StatefulWidget {
  const CashScreen({Key? key}) : super(key: key);

  @override
  _CashScreenState createState() => _CashScreenState();
}

class _CashScreenState extends State<CashScreen> {
  late Future<Map<String, dynamic>> totalCashByDays;
  List<bool> _isPanelExpandedList = [];

  @override
  void initState() {
    super.initState();
    totalCashByDays = calculateTotalCash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arqueo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Realizar Arqueo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              buildCashData(),
            ],
          )
        ),
      ),
    );
  }

  FutureBuilder<Map<String, dynamic>> buildCashData() {
    return FutureBuilder<Map<String, dynamic>>(
            future: totalCashByDays,
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Mientras se carga el arqueo de efectivo, se muestra un indicador de carga
                return Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                // En caso de error al obtener el arqueo de efectivo, se muestra un mensaje de error
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final cashByDays = snapshot.data!;
                final cashByDaysList = cashByDays.entries.toList();

                // Inicializa la lista de paneles expandidos
                if (_isPanelExpandedList.isEmpty) {
                  _isPanelExpandedList =
                      List.generate(cashByDaysList.length, (index) => false);
                }

                return SafeArea(
                    child: Column(
                        children: [
                          DaysSalesGenerator(cashByDaysList)
                        ]
                    )
                );

              } else {
                // Si no hay datos, se muestra un mensaje de que no hay resultados
                return const Text('No hay resultados.');
              }
            },
          );
  }

  ExpansionPanelList DaysSalesGenerator(
      List<MapEntry<String, dynamic>> cashByDaysList) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        bool newIsExpanded = !_isPanelExpandedList[index];

        setState(() {
          // Crea una copia del estado actual y modifícala
          _isPanelExpandedList[index] = newIsExpanded;
        });
      },
      children: cashByDaysList.asMap().entries.map<ExpansionPanel>((entry) {
        final index = entry.key;
        final day = entry.value.key;
        final cashData = entry.value.value;
        final cash = cashData['cash'];
        final cashInMoney = cashData['cash_in_money'];
        final cashInCreditCard = cashData['cash_in_credit_card'];
        final products = cashData['products'];

        return ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text('Día: $day'),
              subtitle: Text(
                  'Total: $cash    Total Efectivo: $cashInMoney    Total Tarjeta: $cashInCreditCard'),
            );
          },
          body: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: (products as Map<String, dynamic>)
                          .entries
                          .map<Widget>((productEntry) {
                        final productName = productEntry.key;
                        final productData = productEntry.value;
                        final productMoney = productData['money'];
                        final productQuantity = productData['quantity'];

                        return ListTile(
                          title: Text('Producto: $productName'),
                          subtitle: Text(
                              'Dinero: $productMoney, Cantidad: $productQuantity'),
                        );
                      }).toList(),
                    ),
                  )),
            ],
          ),
          isExpanded: _isPanelExpandedList[index],
        );
      }).toList(),
    );
  }
}
