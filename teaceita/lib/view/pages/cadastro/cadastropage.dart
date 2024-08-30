import 'package:flutter/material.dart';

class Cadastropage extends StatefulWidget {
  const Cadastropage({super.key});

  @override
  State<Cadastropage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<Cadastropage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const ExpansionTile(
              title: Text('Selecione uma Opção...'),
              children: [
                ListTile(title: Text('Visitante')),
                ListTile(title: Text('Psicólogo')),
                ListTile(title: Text('Empresa')),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cadastro'))
          ],
        ),
      ),
    );
  }
}
