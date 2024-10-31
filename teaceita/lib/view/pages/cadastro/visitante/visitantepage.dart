import 'package:flutter/material.dart';
import 'package:teaceita/services/auth_services.dart';

class Visitantepage extends StatefulWidget {
  const Visitantepage({super.key});

  @override
  State<Visitantepage> createState() => _VisitantepageState();
}

class _VisitantepageState extends State<Visitantepage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController sobrenomeController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final AuthService authService = AuthService();
  void signupUser() {
    authService.signUpUser(
        context: context,
        email: emailController.text,
        password: passwordController.text,
        nome: nomeController.text,
        sobrenome: sobrenomeController.text,
        cpf: cpfController.text,
        datanascimento: dataController.text);
  }

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
                    _buildInputField(
                      'Email',
                      controller: emailController,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField('Senha',
                        obscureText: true, controller: passwordController),
                    const SizedBox(height: 20),
                    _buildInputField('Nome', controller: nomeController),
                    const SizedBox(height: 20),
                    _buildInputField('Sobrenome',
                        controller: sobrenomeController),
                    const SizedBox(height: 20),
                    _buildInputField('Data de Nascimento',
                        controller: dataController),
                    const SizedBox(height: 20),
                    _buildInputField('CPF', controller: cpfController),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: signupUser,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.blue),
                        textStyle: WidgetStateProperty.all(
                          const TextStyle(color: Colors.white),
                        ),
                        minimumSize: WidgetStateProperty.all(
                          Size(MediaQuery.of(context).size.width / 2.5, 50),
                        ),
                      ),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    // Passando o contextos
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
              style: _headerStyle(45, FontWeight.bold)
                  .copyWith(color: Colors.black),
            ),
            TextSpan(
              text: 'ceita',
              style: _headerStyle(45, FontWeight.normal)
                  .copyWith(color: Colors.black),
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
          style:
              _headerStyle(25, FontWeight.normal).copyWith(color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildInputField(String hintText,
      {bool obscureText = false, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 13, color: Colors.black),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide:
              BorderSide(color: Color.fromRGBO(74, 173, 101, 100), width: 3),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide:
              BorderSide(color: Color.fromRGBO(74, 173, 101, 100), width: 3),
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
          borderSide:
              BorderSide(color: Color.fromRGBO(74, 173, 101, 100), width: 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide:
              BorderSide(color: Color.fromRGBO(74, 173, 101, 100), width: 3),
        ),
        filled: true,
        fillColor: Color.fromRGBO(237, 248, 255, 1),
      ),
      items: const [
        DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
        DropdownMenuItem(value: 'Feminino', child: Text('Feminino')),
        DropdownMenuItem(value: 'Outro', child: Text('Outro')),
        DropdownMenuItem(
            value: 'Prefiro não optar', child: Text('Prefiro não optar')),
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

  TextStyle _headerStyle(double size, FontWeight fontWeight) {
    return TextStyle(
      fontSize: size,
      fontWeight: fontWeight,
      color: Colors.black,
    );
  }
}
