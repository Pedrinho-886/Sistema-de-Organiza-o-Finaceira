import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Se estiver usando Chrome: http://127.0.0.1:8000
  // Se estiver usando Emulador Android: http://10.0.2.2:8000
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
}
