import 'package:flutter/material.dart';
import 'package:teaceita/custom_textfield.dart';
import 'package:teaceita/services/auth_services.dart';
import 'package:teaceita/view/components/inputtext.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  void loginUser() {
    authService.signInUser(
      context: context,
      email: emailController.text,
      password: passwordController.text,
    );
  }

  final Color primaryColor = const Color.fromRGBO(74, 173, 101, 1);
  final Color secondaryColor = Colors.black;
  final Color whiteColor = Colors.white;
  bool _isRememberMeChecked = false;

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
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: emailController,
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: passwordController,
                hintText: 'Enter your password',
              ),
            ),
            _buildRememberPasswordCheckbox(),
            const SizedBox(height: 20),
            _buildActionButtons(),
            const SizedBox(height: 20),
            _buildDividerWithText('Ou acesse com:'),
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
        Text(
          'Com número de telefone ou nome de usuário e senha para entrar',
          style: _headerStyle(25, FontWeight.normal),
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    IconData suffixIcon, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                color: Colors.black54, fontSize: 20), // Aumentado para 20
          ),
          Inputtext(
            suffixIcon: Icon(suffixIcon),
            visibility: !isPassword,
            text: hint,
            isPassword: isPassword,
            hintStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w300), // Aumentado para 18
          ),
        ],
      ),
    );
  }

  Widget _buildRememberPasswordCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _isRememberMeChecked,
          onChanged: (bool? value) {
            setState(() {
              _isRememberMeChecked = value!;
            });
          },
          activeColor: primaryColor,
        ),
        const Text(
          'Lembrar minha senha?',
          style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 0.612),
              fontWeight: FontWeight.w300,
              fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton('Cadastrar', whiteColor, primaryColor),
        const SizedBox(width: 20),
        VerticalDivider(color: primaryColor, thickness: 2),
        const SizedBox(width: 1),
        _buildButton(
          'Acessar',
          primaryColor,
          whiteColor,
          isElevated: true,
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color backgroundColor, Color textColor,
      {bool isElevated = false}) {
    return isElevated
        ? ElevatedButton(
            onPressed: () {
              loginUser();
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              padding: WidgetStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 55.0),
              ),
            ),
            child: Text(text,
                style: const TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          )
        : TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/cadastro');
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
              side: WidgetStateProperty.all<BorderSide>(
                  BorderSide(color: primaryColor, width: 2)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              padding: WidgetStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              ),
            ),
            child: Text(text,
                style: const TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          );
  }

  Widget _buildDividerWithText(String text) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
                child: Divider(
                    color: Color.fromRGBO(0, 0, 0, 0.612), thickness: 2)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text,
                  style: const TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.612),
                      fontWeight: FontWeight.w300)),
            ),
            const Expanded(
                child: Divider(
                    color: Color.fromRGBO(0, 0, 0, 0.612), thickness: 2)),
          ],
        ),
        const SizedBox(height: 10),
        _buildGoogleLoginButton(),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildGoogleLoginButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          // Ação de login com o Google
        },
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(whiteColor),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: const BorderSide(color: Colors.black),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/google_logo.png',
                height: 24.0, width: 24.0),
            const SizedBox(width: 10),
            const Text('Login com Google',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
