import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:8000";

  Future<Map<String, dynamic>> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha, 'nome': ''}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Erro ao fazer login');
    }
  }

  Future<Map<String, dynamic>> cadastrar(String nome, String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nome': nome, 'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Erro ao cadastrar');
    }
  }

  Future<List<dynamic>> listarContas(int usuarioId) async {
    final response = await http.get(Uri.parse('$baseUrl/contas/$usuarioId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Erro ao carregar contas');
  }

  Future<Map<String, dynamic>> criarConta({
    required int usuarioId,
    required String nome,
    required double saldoInicial,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/contas/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario_id': usuarioId,
        'nome': nome,
        'saldo': saldoInicial,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao criar conta');
    }
  }

  Future<Map<String, dynamic>> adicionarTransacao({
    required int contaId,
    required double valor,
    required String descricao,
    required String categoria,
    required String tipo, // 'receita' ou 'despesa'
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transacoes/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'conta_id': contaId,
        'valor': valor,
        'descricao': descricao,
        'tipo': tipo,
        'categoria': categoria,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao registrar transação');
    }
  }
}
