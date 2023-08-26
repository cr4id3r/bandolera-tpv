import 'package:bandida_tpv/screens/analytics_screen.dart';
import 'package:bandida_tpv/screens/cash_screen.dart';
import 'package:bandida_tpv/screens/categories_screen.dart';
import 'package:bandida_tpv/screens/home_screen.dart';
import 'package:bandida_tpv/screens/products_screen.dart';
import 'package:bandida_tpv/screens/users_screen.dart';
import 'package:bandida_tpv/utils/constants.dart';
import 'package:bandida_tpv/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/tpv/tpv_screen.dart';
import 'screens/users/register_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((value) => runApp(MyApp()));
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserState(),
      child: Consumer<UserState>(
        builder: (context, userState, _) {
          return MaterialApp(
            title: 'TPV App',
            theme: ThemeData(
              primarySwatch: customPrimaryColor,
            ),
            home: UsersScreen(),
            routes: {
              '/register': (context) => RegisterScreen(),
              '/home': (context) => HomeScreen(),
              '/tpv': (context) => TPVScreen(),
              '/products': (context) => ProductsScreen(),
              '/cash': (context) => CashScreen(),
              '/categories': (context) => CategoriesScreen(),
              '/login': (context) => UsersScreen(),
              '/analytics': (context) => AnalyticScreen(),
              // Agrega más rutas si es necesario
            },
          );
        },
      ),
    );
  }
}

