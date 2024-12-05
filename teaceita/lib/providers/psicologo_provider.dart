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
    tipo: '',
  );

  Psicologo get psicologo => _psicologo;

  void setPsicologo(String psicologo) {
    _psicologo = Psicologo.fromJson(psicologo);
    print("Tipo de usuário no setPsicologo: ${_psicologo.tipo}");
    notifyListeners();
  }

  void setPsicologoFormModel(Psicologo psicologo) {
    _psicologo = psicologo;
    notifyListeners();
  }
}
