import 'transacao.dart';

class Receita extends Transacao {
  final String origem;

  Receita({
    required super.id,
    required super.valor,
    required super.data,
    required super.descricao,
    required super.categoria,
    required super.saldoAnterior,
    required this.origem,
  });

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'origem': origem,
      'tipoTransacao': 'receita', // útil para serialização JSON
    });
    return map;
  }

  factory Receita.fromMap(Map<String, dynamic> map) {
    return Receita(
      id: map['id']?.toInt() ?? 0,
      valor: map['valor']?.toDouble() ?? 0.0,
      data: DateTime.parse(map['data']),
      descricao: map['descricao'] ?? '',
      categoria: map['categoria'] ?? '',
      saldoAnterior: map['saldoAnterior']?.toDouble() ?? 0.0,
      origem: map['origem'] ?? '',
    );
  }

  // Método de negócio definido no diagrama
  void confirmarRecebimento() {
    // Lógica para confirmar o recebimento
  }
}
