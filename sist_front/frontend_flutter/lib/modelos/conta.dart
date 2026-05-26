import 'transacao.dart';

class Conta {
  final int id;
  final String instituicao;
  final String tipo;
  double saldoAtual;

  Conta({
    required this.id,
    required this.instituicao,
    required this.tipo,
    required this.saldoAtual,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'instituicao': instituicao,
      'tipo': tipo,
      'saldoAtual': saldoAtual,
    };
  }

  factory Conta.fromMap(Map<String, dynamic> map) {
    return Conta(
      id: map['id']?.toInt() ?? 0,
      instituicao: map['instituicao'] ?? '',
      tipo: map['tipo'] ?? '',
      saldoAtual: map['saldoAtual']?.toDouble() ?? 0.0,
    );
  }

  // Métodos de negócio definidos no diagrama
  void atualizarSaldo(double valor) {
    saldoAtual += valor;
  }

  List<Transacao> consultarExtrato() {
    // Lógica para buscar as transações da conta
    return [];
  }
}
