import 'package:flutter/material.dart';
import 'package:teaceita/models/psicologo.dart';

class PsicologoProvider extends ChangeNotifier {
  Psicologo _psicologo = Psicologo(
    id: '',
    nome: '',
    password: '',
    endereco: '',
    especialidade: '',
    crp: '',
    token: '',
  );

  Psicologo get psicologo => _psicologo;

  void setUser(String psicologo) {
    _psicologo = Psicologo.fromJson(psicologo);
    notifyListeners();
  }

  void setUserFormModel(Psicologo psicologo) {
    _psicologo = psicologo;
    notifyListeners();
  }
}
