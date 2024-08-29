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
          padding: const EdgeInsets.symmetric(
              horizontal: 20.0), // Adiciona padding horizontal geral
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 250, // Define a largura desejada
                  height: 250, // Define a altura desejada
                  child: FittedBox(
                    fit: BoxFit
                        .fill, // Garante que a imagem preencha todo o espaço do SizedBox
                    child: Image.asset('assets/images/teaceita.png'),
                  ),
                ),
              ),
              const SizedBox(
                  height: 10), // Espaçamento entre a imagem e o texto
              Align(
                alignment: Alignment.center,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'TEA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 45,
                          color: Colors.black, // Cor do texto
                        ),
                      ),
                      TextSpan(
                        text: 'ceita',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 45,
                          color: Colors.black, // Cor do texto
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                  height:
                      30), // Espaçamento entre o texto "TEAceita" e o restante do código
              Text(
                'Acesse',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              const SizedBox(
                  height: 10), // Espaçamento entre o título e o texto abaixo
              RichText(
                text: TextSpan(
                  text:
                      'Com número de telefone ou nome de usuário e senha para entrar',
                  style: TextStyle(
                    color: Colors.black, // Ajusta a cor do texto
                    fontSize: 25,
                  ),
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                  height:
                      20), // Espaçamento entre o texto e o primeiro campo de entrada
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Digite seu usuário:',
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.normal),
                    ),
                    Inputtext(
                      suffixIcon: Icon(Icons.person),
                      visibility: true,
                      text: 'Número de telefone ou nome de usuário',
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
                      'Digite sua senha:',
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.normal),
                    ),
                    Inputtext(
                      suffixIcon: Icon(Icons.remove_red_eye_rounded),
                      visibility: false,
                      text: 'Senha',
                      isPassword: true, // Define que este campo é uma senha
                    ),
                  ],
                ),
              ),
              const Text(
                'Esqueci a senha?',
                style: TextStyle(
                    color: Color.fromRGBO(74, 173, 101, 100),
                    fontWeight: FontWeight.w300),
              ),

              TextButton(onPressed: () {}, child: Text('Cadastrar')),

              Row(
                children: [
                  Expanded(
                      child: Divider(
                    color: Color.fromRGBO(74, 173, 101, 100),
                    thickness: 2,
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'Ou acesse com',
                      style: TextStyle(
                          color: Color.fromRGBO(74, 173, 101, 100),
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  Expanded(
                      child: Divider(
                    color: Color.fromRGBO(74, 173, 101, 100),
                    thickness: 2,
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
