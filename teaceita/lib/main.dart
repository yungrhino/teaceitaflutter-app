import 'package:flutter/material.dart';
import 'package:teaceita/view/pages/cadastro/cadastropage.dart';
import 'package:teaceita/view/pages/home/homepage.dart';
import 'package:teaceita/view/pages/login/loginpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginPage(),
        '/home': (_) => const HomePage(),
        '/cadastro': (_) => const Cadastropage()
      },
    );
  }
}
