import 'package:flutter/material.dart';
import 'package:teaceita/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    nome: '',
    email: '',
    datanascimento: '',
    sobrenome: '',
    cpf: '',
    password: '',
    token: '',
    tipo: '',
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    print("Tipo de usuário no setVititante: ${_user.tipo}");
    notifyListeners();
  }

  void setUserFormModel(User user) {
    _user = user;
    notifyListeners();
  }
}
