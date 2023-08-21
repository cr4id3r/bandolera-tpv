import 'package:flutter/material.dart';

import '../base_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseLayout(
      // Utilizando BaseLayout
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bandida TPV',
                style: TextStyle(
                  fontSize: 50, // Tamaño de fuente más grande (puedes ajustarlo según tus preferencias)
                  fontWeight: FontWeight.bold, // Opcional: para hacerlo más negrita
                ),
              ),
              Text('Powered by Acabeza.es',
                style: TextStyle(
                  fontSize: 25
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
