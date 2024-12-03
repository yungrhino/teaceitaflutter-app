import 'package:teaceita/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:teaceita/models/empresa.dart';
import 'package:teaceita/utils/utils.dart';
import 'package:http/http.dart' as http;

class AuthEmpresa {
  Future<bool> signEmpresa({
    required BuildContext context,
    required String nome,
    required String email,
    required String password,
    required String cnpj,
    required String endereco,
  }) async {
    try {
      Empresa empresa = Empresa(
          id: '',
          nome: nome,
          email: email,
          cnpj: cnpj,
          endereco: endereco,
          password: password,
          token: '');

      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/cadastroEmpresa'),
        body: empresa.toJson(),
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
