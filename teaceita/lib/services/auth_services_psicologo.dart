import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teaceita/providers/psicologo_provider.dart';
import 'package:teaceita/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:teaceita/models/psicologo.dart';
import 'package:teaceita/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:teaceita/view/pages/home/homepage.dart';
import 'package:teaceita/view/pages/login/loginpage.dart';

class AuthPsicologo {
  Future<bool> signPsicologo({
    required BuildContext context,
    required String nome,
    required String email,
    required String password,
    required String crp,
    required String endereco,
  }) async {
    try {
      Psicologo psicologo = Psicologo(
          id: '',
          nome: '',
          password: '',
          endereco: '',
          especialidade: '',
          crp: '',
          token: '');

      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/cadastroPsicologo'),
        body: psicologo.toJson(),
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8',
        },
      );

      bool isSuccess = false;

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
                context, 'Mensagem de verificação enviada para o E-mail!');
            isSuccess = true;
          });
      return isSuccess;
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

  void signInPsicologo({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      var psicologoProvider =
          Provider.of<PsicologoProvider>(context, listen: false);
      final navigator = Navigator.of(context);
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          psicologoProvider.setPsicologo(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void getUserData(
    BuildContext context,
  ) async {
    try {
      var psicologoProvider =
          Provider.of<PsicologoProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('${Constants.uri}/tokenEmpresaValido'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('${Constants.uri}/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        psicologoProvider.setPsicologo(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('x-auth-token', '');
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (route) => false,
    );
  }
}
