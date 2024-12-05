import 'package:flutter/material.dart';
import 'package:teaceita/view/pages/cadastro/visitante/visitantepage.dart';
import 'package:teaceita/view/pages/cadastro/psicologo/psicologopage.dart';
import 'package:teaceita/view/pages/cadastro/empresa/empresapage.dart';

class Cadastropage extends StatefulWidget {
  const Cadastropage({super.key});

  @override
  State<Cadastropage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<Cadastropage> {
  String? _selectedUserType;

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
            // Coloque a imagem e o título em um Column
            Column(
              children: [
                _buildLogo(),
                const SizedBox(height: 10), // Espaço entre logo e título
                _buildTitle(), // Título abaixo do logo
              ],
            ),
            const SizedBox(height: 20),
            _buildSubtitle(),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: ExpansionTile(
                  title: const Text('Selecione uma Opção...'),
                  backgroundColor: const Color.fromRGBO(237, 248, 255, 1),
                  collapsedBackgroundColor:
                      const Color.fromRGBO(237, 248, 255, 1),
                  tilePadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  childrenPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  textColor: Colors.black,
                  iconColor: const Color.fromRGBO(200, 227, 255, 1),
                  collapsedIconColor: const Color.fromRGBO(200, 227, 255, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(
                      color: Color.fromRGBO(74, 173, 101, 100),
                      width: 3,
                    ),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(
                      color: Color.fromRGBO(74, 173, 101, 100),
                      width: 3,
                    ),
                  ),
                  children: [
                    ListTile(
                      title: const Text('Visitante'),
                      onTap: () {
                        setState(() {
                          _selectedUserType = 'Visitante';
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Visitantepage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Psicólogo'),
                      onTap: () {
                        setState(() {
                          _selectedUserType = 'Psicologo';
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Psicologopage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Empresa'),
                      onTap: () {
                        setState(() {
                          _selectedUserType = 'Empresa';
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const EmpresaPage(), // Navega para a página da empresa
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
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

  Widget _buildTitle() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'TEA',
              style: _headerStyle(45, FontWeight.bold)
                  .copyWith(color: Colors.black), // Texto preto
            ),
            TextSpan(
              text: 'ceita',
              style: _headerStyle(45, FontWeight.normal)
                  .copyWith(color: Colors.black), // Texto preto
            ),
          ],
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
