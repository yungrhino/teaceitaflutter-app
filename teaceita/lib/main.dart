import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teaceita/providers/empresa_provider.dart';
import 'package:teaceita/providers/psicologo_provider.dart';
import 'package:teaceita/providers/user_provider.dart';
import 'package:teaceita/view/routes/routes.dart';
import 'package:teaceita/services/auth_services.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => EmpresaProvider()),
        ChangeNotifierProvider(create: (_) => PsicologoProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Inicializa os dados do usuário
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Provider.of<UserProvider>(context).user.token.isEmpty
          ? Routes.login
          : Routes.home,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
