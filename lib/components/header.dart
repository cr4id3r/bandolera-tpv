import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../utils/user_utils.dart';

class HeaderComponent extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // final userState = Provider.of<UserState>(context);

    return AppBar(
      title: Row(
        children: [
          Text('Bandida TPV (Powered by Acabeza.es)'),
        ],
      )
    );
  }
}
