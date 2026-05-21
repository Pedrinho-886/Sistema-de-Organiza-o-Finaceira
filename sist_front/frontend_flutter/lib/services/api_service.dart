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

  Future<void> excluirConta(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/contas/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erro ao excluir conta');
    }
  }

  Future<Map<String, dynamic>> atualizarConta({
    required int id,
    required String nome,
    required double saldo,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/contas/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'saldo': saldo,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao atualizar conta');
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

  Future<void> excluirTransacao(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/transacoes/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erro ao excluir transação');
    }
  }

  Future<Map<String, dynamic>> atualizarTransacao({
    required int id,
    required int contaId,
    required double valor,
    required String descricao,
    required String categoria,
    required String tipo,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/transacoes/$id'),
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
      throw Exception('Erro ao atualizar transação');
    }
  }

  Future<List<dynamic>> listarTodasTransacoes(int usuarioId) async {
    // Primeiro pegamos as contas do usuário
    final contas = await listarContas(usuarioId);
    List<dynamic> todasTransacoes = [];

    // Para cada conta, buscamos as transações
    for (var conta in contas) {
      final response = await http.get(Uri.parse('$baseUrl/transacoes/${conta['id']}'));
      if (response.statusCode == 200) {
        final transacoesConta = jsonDecode(response.body);
        // Adicionamos o nome da conta para exibir na lista
        for (var t in transacoesConta) {
          t['nome_conta'] = conta['nome'];
        }
        todasTransacoes.addAll(transacoesConta);
      }
    }

    // Ordenar por data (mais recente primeiro)
    todasTransacoes.sort((a, b) => b['data'].compareTo(a['data']));
    
    return todasTransacoes;
  }
}
