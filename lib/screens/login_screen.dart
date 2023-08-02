
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/user_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(100.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  final String username = _usernameController.text;
                  final String password = _passwordController.text;
                  _login(context, username, password);
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context, String username, String password) {
    final userState = context.read<UserState>();

    Future<User> userInfo = performLogin(username, password);

    userInfo.then((value) => {
      if (value != null) {
        userState.login(username, value.name),
        Navigator.pushNamedAndRemoveUntil(context, '/tpv', (route) => false)
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Usuario o contraseña incorrectos'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Cierra el diálogo
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        )
      }
    });
  }
}
