import 'package:teaceita/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:teaceita/models/psicologo.dart';
import 'package:teaceita/utils/utils.dart';
import 'package:http/http.dart' as http;

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
}
