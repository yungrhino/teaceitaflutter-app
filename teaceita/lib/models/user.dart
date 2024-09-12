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

  User({
    required this.id,
    required this.nome,
    required this.email,
    required this.datanascimento,
    required this.sobrenome,
    required this.cpf,
    required this.password,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': nome,
      'email': email,
      'datanascimento': datanascimento,
      'sobrenome': sobrenome,
      'cpf': cpf,
      'password': password,
      'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      nome: map['name'] ?? '',
      email: map['email'] ?? '',
      datanascimento: map['datanascimento'] ?? '',
      sobrenome: map['sobrenome'] ?? '',
      cpf: map['cpf'] ?? '',
      password: map['password'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}