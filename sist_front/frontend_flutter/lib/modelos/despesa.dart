import 'transacao.dart';

class Despesa extends Transacao {
  final bool isParcelada;
  final String statusPagamento;

  Despesa({
    required super.id,
    required super.valor,
    required super.data,
    required super.descricao,
    required super.categoria,
    required super.saldoAnterior,
    required this.isParcelada,
    required this.statusPagamento,
  });

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'isParcelada': isParcelada,
      'statusPagamento': statusPagamento,
      'tipoTransacao': 'despesa', // útil para serialização JSON
    });
    return map;
  }

  factory Despesa.fromMap(Map<String, dynamic> map) {
    return Despesa(
      id: map['id']?.toInt() ?? 0,
      valor: map['valor']?.toDouble() ?? 0.0,
      data: DateTime.parse(map['data']),
      descricao: map['descricao'] ?? '',
      categoria: map['categoria'] ?? '',
      saldoAnterior: map['saldoAnterior']?.toDouble() ?? 0.0,
      isParcelada: map['isParcelada'] ?? false,
      statusPagamento: map['statusPagamento'] ?? '',
    );
  }

  // Método de negócio definido no diagrama
  void aplicarParcelamento(int numParcelas) {
    if (isParcelada) {
      // lógica de parcelamento
    }
  }
}
