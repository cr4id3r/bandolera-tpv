import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

import '../utils/user_utils.dart';

class HeaderComponent extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Text('Bandida TPV (Powered by Acabeza.es)'),
          const Spacer(),
          Consumer<UserState>(
            builder: (context, userState, _) {
              if (userState.loggedInUser != null) {
                return Text("Usuario: ${userState.loggedInUser!.name}");
              } else {
                return const Text('No user logged in');
              }
            },
          ),
        ],
      ),
      actions: [
        Consumer<UserState>(
          builder: (context, userState, _) {
            if (userState.loggedInUser != null) {
              return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  userState.logoutUser();
                  // Go to home and remove all routes
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                },
              );
            } else {
              return const SizedBox.shrink(); // No mostrar el ícono si no hay usuario registrado
            }
          },
        ),
      ],
    );
  }
}

