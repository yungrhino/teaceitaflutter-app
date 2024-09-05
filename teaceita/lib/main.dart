import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teaceita/providers/user_provider.dart';
import 'package:teaceita/view/routes/routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      initialRoute: Routes.login,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
