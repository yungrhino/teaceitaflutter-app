import 'package:flutter/material.dart';
import 'package:teaceita/view/components/inputtext.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Color primaryColor = Color.fromRGBO(74, 173, 101, 1);
  final Color secondaryColor = Colors.black;
  final Color whiteColor = Colors.white;

  TextStyle _headerStyle(double fontSize, FontWeight fontWeight) {
    return TextStyle(
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: secondaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(),
              const SizedBox(height: 10),
              _buildTitle(),
              const SizedBox(height: 30),
              _buildSubtitle(),
              const SizedBox(height: 20),
              _buildInputField('Digite seu usuário:', 'Número de telefone ou nome de usuário', Icons.person),
              _buildInputField('Digite sua senha:', 'Senha', Icons.remove_red_eye_rounded, isPassword: true),
              _buildForgotPasswordText(),
              const SizedBox(height: 20),
              _buildActionButtons(),
              const SizedBox(height: 20),
              _buildDividerWithText('Ou acesse com:'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 250,
        height: 250,
        child: FittedBox(
          fit: BoxFit.fill,
          child: Image.asset('assets/images/teaceita.png'),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(text: 'TEA', style: _headerStyle(45, FontWeight.bold)),
            TextSpan(text: 'ceita', style: _headerStyle(45, FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Acesse', style: _headerStyle(35, FontWeight.bold)),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            text: 'Com número de telefone ou nome de usuário e senha para entrar',
            style: _headerStyle(25, FontWeight.normal),
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildInputField(String label, String hint, IconData suffixIcon, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.black54)),
          Inputtext(
            suffixIcon: Icon(suffixIcon),
            visibility: !isPassword,
            text: hint,
            isPassword: isPassword,
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordText() {
    return const Text(
      'Lembrar minha senha',
      style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.612), fontWeight: FontWeight.w300),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton('Cadastrar', whiteColor, primaryColor),
        const SizedBox(width: 20),
        VerticalDivider(color: primaryColor, thickness: 2),
        const SizedBox(width: 45),
        _buildButton('Acessar', primaryColor, whiteColor, isElevated: true),
      ],
    );
  }

  Widget _buildButton(String text, Color backgroundColor, Color textColor, {bool isElevated = false}) {
    return isElevated
        ? ElevatedButton(
            onPressed: () {
              // Ação do botão de acessar
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              padding: WidgetStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(vertical: 20.0, horizontal: 55.0),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          )
        : TextButton(
            onPressed: () {
              // Ação do botão de cadastrar
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
              side: WidgetStateProperty.all<BorderSide>(
                BorderSide(color: primaryColor, width: 2),
              ),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              padding: WidgetStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          );
  }

  Widget _buildDividerWithText(String text) {
    return Row(
      children: [
        Expanded(child: Divider(color: Color.fromRGBO(0, 0, 0, 0.612), thickness: 2)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text, style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.612), fontWeight: FontWeight.w300)),
        ),
        Expanded(child: Divider(color: Color.fromRGBO(0, 0, 0, 0.612), thickness: 2)),
      ],
    );
  }
}
