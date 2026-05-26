class Transacao {
  final int id;
  final double valor;
  final DateTime data;
  final String descricao;
  final String categoria;
  final double saldoAnterior;

  Transacao({
    required this.id,
    required this.valor,
    required this.data,
    required this.descricao,
    required this.categoria,
    required this.saldoAnterior,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'valor': valor,
      'data': data.toIso8601String(),
      'descricao': descricao,
      'categoria': categoria,
      'saldoAnterior': saldoAnterior,
    };
  }

  factory Transacao.fromMap(Map<String, dynamic> map) {
    return Transacao(
      id: map['id']?.toInt() ?? 0,
      valor: map['valor']?.toDouble() ?? 0.0,
      data: DateTime.parse(map['data']),
      descricao: map['descricao'] ?? '',
      categoria: map['categoria'] ?? '',
      saldoAnterior: map['saldoAnterior']?.toDouble() ?? 0.0,
    );
  }

  // Método de negócio definido no diagrama
  bool validarDados() {
    return valor > 0 && descricao.isNotEmpty;
  }
}
