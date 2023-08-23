import 'package:flutter/cupertino.dart';
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
                        final userState = context.read<UserState>();
                        userState.loginUser(users[index]);
                        Navigator.pushNamed(context, '/home');
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
            child: Image.network(
              user.imageUrl, // Replace with the actual image URL
              fit: BoxFit.cover,
              height: 100, // Adjust the image height as needed
              width: double.infinity, // Make the image width take up the full width
            ),
          ),
          const SizedBox(height: 20),
          Text(user.name),
        ],
      ),
    );
  }
}
