import 'package:flutter/material.dart';
import 'package:teaceita/view/pages/home/homepage.dart';

class VisitantePage extends StatelessWidget {
  const VisitantePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitante'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildFixedHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildSubtitle(),
                    const SizedBox(height: 20),
                    _buildInputField('Email'),
                    const SizedBox(height: 20),
                    _buildInputField('Senha', obscureText: true),
                    const SizedBox(height: 20),
                    _buildInputField('Nome'),
                    const SizedBox(height: 20),
                    _buildInputField('Sobrenome'),
                    const SizedBox(height: 20),
                    _buildGenderDropdown(),
                    const SizedBox(height: 20),
                    _buildInputField('Data de Nascimento'),
                    const SizedBox(height: 20),
                    _buildInputField('CPF'),
                    const SizedBox(height: 20),
                    _buildSubmitButton(context), // Passando o contexto
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFixedHeader() {
    return Column(
      children: [
        _buildLogo(),
        const SizedBox(height: 10),
        _buildTitle(),
      ],
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
              style: _headerStyle(45, FontWeight.bold).copyWith(color: Colors.black),
            ),
            TextSpan(
              text: 'ceita',
              style: _headerStyle(45, FontWeight.normal).copyWith(color: Colors.black),
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
        Text(
          'Por favor, insira suas credenciais',
          style: _headerStyle(25, FontWeight.normal).copyWith(color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildInputField(String hintText, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(fontSize: 13, color: Colors.black),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Color.fromRGBO(74, 173, 101, 100), width: 3),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Color.fromRGBO(74, 173, 101, 100), width: 3),
        ),
        filled: true,
        fillColor: const Color.fromRGBO(237, 248, 255, 1),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Color.fromRGBO(74, 173, 101, 100), width: 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Color.fromRGBO(74, 173, 101, 100), width: 3),
        ),
        filled: true,
        fillColor: Color.fromRGBO(237, 248, 255, 1),
      ),
      items: const [
        DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
        DropdownMenuItem(value: 'Feminino', child: Text('Feminino')),
        DropdownMenuItem(value: 'Outro', child: Text('Outro')),
        DropdownMenuItem(value: 'Prefiro não optar', child: Text('Prefiro não optar')),
      ],
      onChanged: (value) {
        // Lógica de tratamento da seleção do gênero
      },
      hint: const Text(
        'Gênero',
        style: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()), // Altere HomePage para o nome da sua página inicial
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: const Color.fromRGBO(74, 173, 101, 100),
        ),
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }

  TextStyle _headerStyle(double size, FontWeight fontWeight) {
    return TextStyle(
      fontSize: size,
      fontWeight: fontWeight,
      color: Colors.black,
    );
  }
}
