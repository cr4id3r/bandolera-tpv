import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/user_utils.dart';

class HeaderComponent extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);

    return AppBar(
      title: Row(
        children: [
          Text('TPV Escuela Judy'),
        ],
      ),
      actions: [
        if (userState.isLoggedIn) ...[
          Align(
            alignment: Alignment.center,
            child: Text(
              userState.userLabel ?? '',
              style: TextStyle(fontSize: 16),
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Realizar lógica de cierre de sesión
              userState.logout();
            },
          )
        ],
        if (!userState.isLoggedIn) ...[
          Align(
            alignment: Alignment.center,
            child: Text(
              'Login',
              style: TextStyle(fontSize: 16),
            ),
          ),
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              // Navegar a la pantalla de inicio de sesión
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ],
    );
  }
}
