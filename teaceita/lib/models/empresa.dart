import 'dart:convert';

class Empresa {
  final String id;
  final String nome;
  final String email;
  final String cnpj;
  final String endereco;
  final String password;
  final String token;
  final String tipo;
  Empresa({
    required this.id,
    required this.nome,
    required this.email,
    required this.cnpj,
    required this.endereco,
    required this.password,
    required this.token,
    required this.tipo,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': nome,
      'email': email,
      'cnpj': cnpj,
      'endereco': endereco,
      'password': password,
      'token': token,
      'tipo': tipo,
    };
  }

  factory Empresa.fromMap(Map<String, dynamic> map) {
    return Empresa(
      id: map['_id'] ?? '',
      nome: map['name'] ?? '',
      email: map['email'] ?? '',
      cnpj: map['cnpj'] ?? '',
      endereco: map['endereco'] ?? '',
      password: map['password'] ?? '',
      token: map['token'] ?? '',
      tipo: map['tipo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Empresa.fromJson(String source) =>
      Empresa.fromMap(json.decode(source) as Map<String, dynamic>);
}
