class Investimento {
  final int id;
  final String codigoAtivo;
  final String tipoAtivo;
  double quantidade;
  final String instituicao;

  Investimento({
    required this.id,
    required this.codigoAtivo,
    required this.tipoAtivo,
    required this.quantidade,
    required this.instituicao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codigoAtivo': codigoAtivo,
      'tipoAtivo': tipoAtivo,
      'quantidade': quantidade,
      'instituicao': instituicao,
    };
  }

  factory Investimento.fromMap(Map<String, dynamic> map) {
    return Investimento(
      id: map['id']?.toInt() ?? 0,
      codigoAtivo: map['codigoAtivo'] ?? '',
      tipoAtivo: map['tipoAtivo'] ?? '',
      quantidade: map['quantidade']?.toDouble() ?? 0.0,
      instituicao: map['instituicao'] ?? '',
    );
  }

  // Métodos de negócio
  double calcularPatrimonioAtual() {
    double precoAtual = buscarPrecoAtualizado();
    return quantidade * precoAtual;
  }

  double buscarPrecoAtualizado() {
    // Lógica para ir buscar no provedor ou HistoricoCotacao
    return 0.0;
  }
}
