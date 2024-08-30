import 'package:flutter/material.dart';
import 'package:teaceita/view/pages/home/homepage.dart';

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
            ExpansionTile(
              title: const Text('Selecione uma Opção...'),
              children: [
                ListTile(
                    title: const Text('Visitante'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    }),
                const ListTile(title: Text('Psicólogo')),
                const ListTile(title: Text('Empresa')),
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
