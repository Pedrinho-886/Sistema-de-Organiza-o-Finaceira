class Usuario {
  final int id;
  final String nome;
  final String email;
  final String senha;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id']?.toInt() ?? 0,
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
    );
  }

  // Métodos de negócio definidos no diagrama
  void cadastrar() {
    // Lógica de cadastro
  }

  bool realizarLogin() {
    // Lógica de login
    return true;
  }
}
