// Create a stateful widget for the RegisterScreen
import 'package:flutter/material.dart';

import '../../utils/user_utils.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

// Create a state for the RegisterScreen
class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Crear nuevo usuario'),
      ),
      // Create a form
      body: Center(
          // Center the form vertically
          child: Container(
            width: screenWidth * 0.5,
            height: screenHeight * 0.5,
            child: RegisterFormWidget(formKey: _formKey, nameController: nameController, usernameController: usernameController, passwordController: passwordController),
          )),
    ));
  }
}

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.nameController,
    required this.usernameController,
    required this.passwordController,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController nameController;

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  String selectedCategory = 'user';

  @override
  Widget build(BuildContext context) {
    return Form(
    key: widget._formKey,
    child: Column(
      children: [
        // Create a text field for the username
        TextFormField(
          controller: widget.nameController,
          decoration: const InputDecoration(
            labelText: 'Nombre de usuario',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, introduce un nombre de usuario';
            }
            return null;
          },
        ),
        TextFormField(
          controller: widget.usernameController,
          decoration: const InputDecoration(
            labelText: 'Identificador de usuario',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, introduce un nombre de usuario';
            }
            return null;
          },
        ),
        // Create a text field for the password
        TextFormField(
          controller: widget.passwordController,
          decoration: const InputDecoration(
            labelText: 'Contraseña',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, introduce una contraseña';
            }
            return null;
          },
        ),

        // Create a category dropdown
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Categoría',
          ),
          items: <String>['admin', 'user'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, selecciona una categoría';
            }
            return null;
          }, onChanged: (String? value) {
            setState(() {
              selectedCategory = value!;
            });

        },
        ),
        const SizedBox(height: 30),
        // Create a button to submit the form
        ElevatedButton(
          onPressed: () {
            // Validate the form
            if (widget._formKey.currentState!.validate()) {
              createUser(widget.nameController.text, widget.usernameController.text, widget.passwordController.text, selectedCategory);
              // If the form is valid, display a snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Procesando datos')),
              );
            }
          },
          child: const Text('Enviar'),
        ),
      ],
    ),
        );
  }
}
