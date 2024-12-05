// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String id;
  final String nome;
  final String email;
  final String datanascimento;
  final String sobrenome;
  final String cpf;
  final String password;
  final String token;
  final String tipo;

  User({
    required this.id,
    required this.nome,
    required this.email,
    required this.datanascimento,
    required this.sobrenome,
    required this.cpf,
    required this.password,
    required this.token,
    required this.tipo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': nome,
      'email': email,
      'datanascimento': datanascimento,
      'sobrenome': sobrenome,
      'cpf': cpf,
      'password': password,
      'token': token,
      'tipo': tipo,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      nome: map['name'] ?? '',
      email: map['email'] ?? '',
      datanascimento: map['datanascimento'] ?? '',
      sobrenome: map['sobrenome'] ?? '',
      cpf: map['cpf'] ?? '',
      password: map['password'] ?? '',
      token: map['token'] ?? '',
      tipo: map['tipo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
