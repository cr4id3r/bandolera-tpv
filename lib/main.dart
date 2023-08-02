import 'package:bandolera_tpv/screens/cash_screen.dart';
import 'package:bandolera_tpv/screens/categories_screen.dart';
import 'package:bandolera_tpv/screens/home_screen.dart';
import 'package:bandolera_tpv/screens/login_screen.dart';
import 'package:bandolera_tpv/screens/products_screen.dart';
import 'package:bandolera_tpv/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/tpv_screen.dart';

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
              primarySwatch: Colors.blue,
            ),
            home: HomeScreen(),
            routes: {
              '/tpv': (context) => TPVScreen(),
              '/products': (context) => ProductsScreen(),
              '/cash': (context) => CashScreen(),
              '/categories': (context) => CategoriesScreen(),
              '/login': (context) => LoginScreen(),
              // Agrega más rutas si es necesario
            },
          );
        },
      ),
    );
  }
}

