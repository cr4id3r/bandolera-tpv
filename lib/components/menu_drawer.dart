import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';
import '../utils/user_utils.dart';

class MenuDrawer extends StatelessWidget {
  final Map<String, String> menuOptions = {
    'Inicio': '/',
    'TPV': '/tpv',
    'Productos': '/products'
  };

  final Map<String, String> menuOptionsAdmin = {
    'Inicio': '/',
    'TPV': '/tpv',
    'Productos': '/products',
    'Categorias': '/categories',
    'Arqueos': '/cash',
    'Analitica': '/analytics',
  };

  List<Widget> buildMenuOptions(BuildContext context) {
    return [
      DrawerHeader(
        decoration: BoxDecoration(
          color: customPrimaryColor[900],
        ),
        child: Text(
          'Bandida TPV (Powered by Acabeza.es)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        )
      ),
      Consumer<UserState>(
        builder: (context, userState, _) {
          if (userState.loggedInUser?.category == 'admin') {
            return Column(
              children: [
                for (var option in menuOptionsAdmin.keys)
                  ListTile(
                    title: Text(option),
                    onTap: () {
                      Navigator.pushNamed(context, menuOptionsAdmin[option]!);
                    },
                  ),
              ],
            );
          } else {
            return Column(
              children: [
                for (var option in menuOptions.keys)
                  ListTile(
                    title: Text(option),
                    onTap: () {
                      Navigator.pushNamed(context, menuOptions[option]!);
                    },
                  ),
              ],
            );
          }
        }
      )
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
