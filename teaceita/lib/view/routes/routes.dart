import 'package:flutter/material.dart';
import 'package:teaceita/view/pages/cadastro/cadastropage.dart';
import 'package:teaceita/view/pages/home/homepage.dart';
import 'package:teaceita/view/pages/login/loginpage.dart';

class Routes {
  static const String login = '/login';
  static const String home = '/home';
  static const String cadastro = '/cadastro';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case cadastro:
        return MaterialPageRoute(builder: (_) => Cadastropage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
