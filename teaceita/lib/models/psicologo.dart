import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Psicologo {
  final String id;
  final String nome;
  final String password;
  final String endereco;
  final String especialidade;
  final String crp;
  final String token;
  Psicologo({
    required this.id,
    required this.nome,
    required this.password,
    required this.endereco,
    required this.especialidade,
    required this.crp,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'password': password,
      'endereco': endereco,
      'especialidade': especialidade,
      'crp': crp,
      'token': token,
    };
  }

  factory Psicologo.fromMap(Map<String, dynamic> map) {
    return Psicologo(
      id: map['_id'] ?? '',
      nome: map['nome'] ?? '',
      password: map['password'] ?? '',
      endereco: map['endereco'] ?? '',
      especialidade: map['especialidade'] ?? '',
      crp: map['crp'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Psicologo.fromJson(String source) =>
      Psicologo.fromMap(json.decode(source) as Map<String, dynamic>);
}
