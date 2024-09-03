import 'package:flutter/material.dart';
import 'package:teaceita/view/pages/cadastro/visitante/visitantepage.dart';

class Cadastropage extends StatefulWidget {
  const Cadastropage({super.key});

  @override
  State<Cadastropage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<Cadastropage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLogo(),
            const SizedBox(height: 20),
            _buildSubtitle(),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: ExpansionTile(
                  title: const Text('Selecione uma Opção...'),
                  children: [
                    ListTile(
                      title: const Text('Visitante'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const visitantepage(),
                          ),
                        );
                      },
                    ),
                    const ListTile(title: Text('Psicólogo')),
                    const ListTile(title: Text('Empresa')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: FittedBox(
          fit: BoxFit.fill,
          child: Image.asset('assets/images/teaceita.png'),
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Diga mais sobre você!', style: _headerStyle(35, FontWeight.bold)),
        const SizedBox(height: 10),
        Text(
          'Por favor, selecione a opção que você se identifica',
          style: _headerStyle(25, FontWeight.normal),
        ),
      ],
    );
  }

  TextStyle _headerStyle(double size, FontWeight fontWeight) {
    return TextStyle(
      fontSize: size,
      fontWeight: fontWeight,
    );
  }
}
