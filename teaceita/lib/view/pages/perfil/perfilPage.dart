import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teaceita/providers/user_provider.dart';

class Perfilpage extends StatefulWidget {
  const Perfilpage({super.key});

  @override
  State<Perfilpage> createState() => _PerfilpageState();
}

class _PerfilpageState extends State<Perfilpage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        // O botão de "voltar" será automaticamente adicionado à AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${user.nome} ${user.sobrenome}'),
            Text(user.email),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Volta para a tela anterior (Home)
              },
              child: const Text('Voltar para Home'),
            ),
          ],
        ),
      ),
    );
  }
}
