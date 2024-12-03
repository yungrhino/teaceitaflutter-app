import 'package:flutter/material.dart';
import 'package:teaceita/models/empresa.dart';

class EmpresaProvider extends ChangeNotifier {
  Empresa _empresa = Empresa(
    id: '',
    nome: '',
    email: '',
    cnpj: '',
    endereco: '',
    password: '',
    token: '',
  );

  Empresa get empresa => _empresa;

  void setEmpresa(String empresa) {
    _empresa = Empresa.fromJson(empresa);
    notifyListeners();
  }

  void setEmpresaFromModel(Empresa empresa) {
    _empresa = empresa;
    notifyListeners();
  }
}
