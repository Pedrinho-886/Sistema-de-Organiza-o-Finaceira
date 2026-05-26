class Reserva {
  final int id;
  final String nomeMeta;
  final double valorMeta;
  double valorAcumulado;

  Reserva({
    required this.id,
    required this.nomeMeta,
    required this.valorMeta,
    required this.valorAcumulado,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomeMeta': nomeMeta,
      'valorMeta': valorMeta,
      'valorAcumulado': valorAcumulado,
    };
  }

  factory Reserva.fromMap(Map<String, dynamic> map) {
    return Reserva(
      id: map['id']?.toInt() ?? 0,
      nomeMeta: map['nomeMeta'] ?? '',
      valorMeta: map['valorMeta']?.toDouble() ?? 0.0,
      valorAcumulado: map['valorAcumulado']?.toDouble() ?? 0.0,
    );
  }

  // Métodos de negócio
  void registrarAporte(double valor) {
    valorAcumulado += valor;
  }

  double calcularProgresso() {
    if (valorMeta == 0) return 0;
    return (valorAcumulado / valorMeta) * 100; // retornado em porcentagem
  }

  void resgatarValor(double valor) {
    if (valorAcumulado >= valor) {
      valorAcumulado -= valor;
    }
  }
}
