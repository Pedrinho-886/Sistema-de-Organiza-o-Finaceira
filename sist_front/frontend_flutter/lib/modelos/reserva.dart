class Reserva {
  final int id;
  final String nomeMeta;
  final double valorMeta;
  double valorAcumulado;
  final int usuarioId;

  Reserva({
    required this.id,
    required this.nomeMeta,
    required this.valorMeta,
    required this.valorAcumulado,
    required this.usuarioId,
  });

  // Função auxiliar robusta para conversão de tipos
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome_meta': nomeMeta,
      'valor_meta': valorMeta,
      'valor_acumulado': valorAcumulado,
      'usuario_id': usuarioId,
    };
  }

  factory Reserva.fromMap(Map<String, dynamic> map) {
    return Reserva(
      id: _toInt(map['id']),
      nomeMeta: map['nome_meta']?.toString() ?? '',
      valorMeta: _toDouble(map['valor_meta']),
      valorAcumulado: _toDouble(map['valor_acumulado']),
      usuarioId: _toInt(map['usuario_id']),
    );
  }

  double calcularProgresso() {
    if (valorMeta <= 0) return 0.0;
    double progresso = (valorAcumulado / valorMeta);
    if (progresso > 1.0) return 1.0;
    if (progresso < 0.0) return 0.0;
    return progresso;
  }
}
