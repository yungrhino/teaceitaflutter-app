import 'package:flutter/material.dart';
import 'package:teaceita/models/user.dart';
import 'package:teaceita/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:teaceita/utils/constants.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String nome,
    required String sobrenome,
    required String datanascimento,
    required String cpf,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
          id: '',
          nome: nome,
          email: email,
          datanascimento: datanascimento,
          sobrenome: sobrenome,
          cpf: cpf,
          password: password,
          token: '');

      http.Response res = await http.post(
          Uri.parse('${Constants.uri}/api/signUp'),
          body: user.toJson(),
          headers: <String, String>{
            'content-type': 'application/json; charset=UTF-8',
          });

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
                context, 'Account creanted! Loin with the same credentials!');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
