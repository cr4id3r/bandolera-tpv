import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/user_utils.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UsersScreen> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    getAllUsers().then((value) {
      setState(() {
        users = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Seleccionar usuario'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(100.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6, // You can adjust the number of users per row
                  ),
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        _showPasswordDialog(context, users[index]);
                      },
                      child: UserCard(
                        user: users[index],
                      ),
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Crear nuevo usuario'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Image(
                image: AssetImage('assets/icon/user_icon.png'),
                fit: BoxFit.cover,
                height: 100, // Adjust the image height as needed
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(user.name),
        ],
      ),
    );
  }
}

Future<void> _showPasswordDialog(BuildContext context, User user) async {
  String? enteredPassword;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Ingresa la contraseña para ${user.name}'),
        content: TextField(
          obscureText: true,
          onChanged: (value) {
            enteredPassword = value;
          },
          decoration: InputDecoration(labelText: 'Contraseña'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final userLogin = await performLogin(user.username, enteredPassword!);
              if (userLogin != null) {
                final userState = context.read<UserState>();
                userState.loginUser(userLogin);
                Navigator.pushNamed(context, '/home');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Contraseña incorrecta'),
                  ),
                );
              }
            },
            child: Text('Iniciar sesión'),
          ),
        ],
      );
    },
  );
}
