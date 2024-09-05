import 'package:flutter/material.dart';
import 'package:teaceita/models/user.dart';
import 'package:teaceita/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:teaceita/utils/constants.dart';

class AuthSevice {
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String sobrenome,
    required String cpf,
    required String datanascimento,
  }) async {
    try {
      User user = User(
          id: '',
          name: '',
          email: '',
          datanascimento: '',
          sobrenome: '',
          cpf: '',
          password: '',
          token: '');

      http.Response res = await http.post(
          Uri.parse('${Constants.uri}/api/signUp'),
          body: user.toJson(),
          headers: <String, String>{
            'content-type': 'application/json; charset=UTF-8,'
          });

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
                context, 'Account creanted! Loin with the same credentials!');
          });
    } catch (e) {}
  }
}
