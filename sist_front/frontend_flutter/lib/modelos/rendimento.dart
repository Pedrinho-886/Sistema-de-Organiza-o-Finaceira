import 'investimento.dart';

class Rendimento {
  final int id;
  final double valor;
  final DateTime data;
  final String tipoRendimento;

  Rendimento({
    required this.id,
    required this.valor,
    required this.data,
    required this.tipoRendimento,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'valor': valor,
      'data': data.toIso8601String(),
      'tipoRendimento': tipoRendimento,
    };
  }

  factory Rendimento.fromMap(Map<String, dynamic> map) {
    return Rendimento(
      id: map['id']?.toInt() ?? 0,
      valor: map['valor']?.toDouble() ?? 0.0,
      data: DateTime.parse(map['data']),
      tipoRendimento: map['tipoRendimento'] ?? '',
    );
  }

  // Métodos descritos no UML
  void registrarRendimento() {
    // Lógica para salvar e calcular
  }

  void vincularAoAtivo(Investimento ativo) {
    // Lógica que amarra o redimento ao ativo (ex: Dividendos de MGLU3)
  }
}
