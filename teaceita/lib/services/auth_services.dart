import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teaceita/models/user.dart';
import 'package:teaceita/providers/user_provider.dart';
import 'package:teaceita/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:teaceita/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teaceita/view/pages/home/homepage.dart';

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
                context, 'Account created! Login with the same credentials!');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/signin'),
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
          userProvider.setUser(res.body);
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
}
