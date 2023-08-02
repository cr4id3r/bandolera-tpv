import 'package:flutter/material.dart';

import '../base_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      // Utilizando BaseLayout
      child: Scaffold(
        body: Center(
          child: Image.network('https://picsum.photos/200')
        ),
      ),
    );
  }
}
