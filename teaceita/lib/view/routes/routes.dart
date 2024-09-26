import 'package:flutter/material.dart';
import 'package:teaceita/view/pages/cadastro/cadastropage.dart';
import 'package:teaceita/view/pages/home/homepage.dart';
import 'package:teaceita/view/pages/login/loginpage.dart';
import 'package:teaceita/view/pages/perfil/perfilPage.dart';

class Routes {
  static const String login = '/';
  static const String home = '/home';
  static const String cadastro = '/cadastro';
  static const String perfil = '/perfil';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case perfil:
        return MaterialPageRoute(builder: (_) => Perfilpage());
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
