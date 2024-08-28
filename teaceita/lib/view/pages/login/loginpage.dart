import 'package:flutter/material.dart';
import 'package:teaceita/view/components/inputtext.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter, // Ajusta o alinhamento do container
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0), // Adiciona padding horizontal geral
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 400,
                  height: 200,
                  child: Image.asset('assets/images/teaceita.png'),
                ),
              ),
              const SizedBox(height: 20), // Espaçamento entre a imagem e o texto
              Text(
                'Acesse',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              const SizedBox(height: 10), // Espaçamento entre o título e o texto abaixo
              RichText(
                text: TextSpan(
                  text: 'Com número de telefone ou nome de usuário e senha para entrar',
                  style: TextStyle(
                    color: Colors.black, // Ajusta a cor do texto
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20), // Espaçamento entre o texto e o primeiro campo de entrada
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Username:',
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.w500),
                    ),
                    Inputtext(
                      suffixIcon: Icon(Icons.send_rounded),
                      visibility: true,
                      text: 'Digite seu E-mail',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Senha:',
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.w500),
                    ),
                    Inputtext(
                      suffixIcon: Icon(Icons.lock_rounded),
                      visibility: true,
                      text: 'Digite sua Senha',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
