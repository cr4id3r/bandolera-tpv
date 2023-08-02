// import 'package:bandolera_tpv/utils/user_utils.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'components/header.dart';
import 'components/menu_drawer.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;

  const BaseLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderComponent(),
      body: Column(
        children: [
          Expanded(
            child: child,
          ),
        ],
      ),
      drawer: MenuDrawer(),
    );
  }
}
