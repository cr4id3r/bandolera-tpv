import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  final Map<String, String> menuOptions = {
    'Inicio': '/',
    'TPV': '/tpv',
    'Productos': '/products',
    'Categorias': '/categories',
    'Arqueos': '/cash',
  };

  final Map<String, String> menuOptionsAdmin = {
    'Inicio': '/',
    'TPV': '/tpv',
    'Productos': '/products',
    'Categorias': '/categories',
    'Arqueos': '/cash',
  };

  List<Widget> buildMenuOptions(BuildContext context) {
    return [
      DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Text(
          'Bandolera TPV (Powered by Acabeza.es)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        )
      ),
      for (var entry in menuOptions.entries)
        ListTile(
          title: Text(entry.key),
          onTap: () {
            // Lógica para manejar la selección del menú
            Navigator.pushNamed(context, entry.value);
          },
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: buildMenuOptions(context),
        ),
      ),
    );
  }
}
