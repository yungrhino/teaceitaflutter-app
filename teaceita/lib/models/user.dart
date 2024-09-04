class User {
  final String id;
  final String name;
  final String email;
  final String datanascimento;
  final String sobrenome;
  final String cpf;
  final String password;
  final String token;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.datanascimento,
      required this.sobrenome,
      required this.cpf,
      required this.password,
      required this.token});
}
