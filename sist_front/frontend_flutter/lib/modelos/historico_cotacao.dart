class HistoricoCotacao {
  final int id;
  final DateTime dataCotacao;
  double precoFechamento;
  double variacaoDia;

  HistoricoCotacao({
    required this.id,
    required this.dataCotacao,
    required this.precoFechamento,
    required this.variacaoDia,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dataCotacao': dataCotacao.toIso8601String(),
      'precoFechamento': precoFechamento,
      'variacaoDia': variacaoDia,
    };
  }

  factory HistoricoCotacao.fromMap(Map<String, dynamic> map) {
    return HistoricoCotacao(
      id: map['id']?.toInt() ?? 0,
      dataCotacao: DateTime.parse(map['dataCotacao']),
      precoFechamento: map['precoFechamento']?.toDouble() ?? 0.0,
      variacaoDia: map['variacaoDia']?.toDouble() ?? 0.0,
    );
  }

  // Métodos
  void atualizarPreco(double novoPreco) {
    precoFechamento = novoPreco;
  }

  double obterPrecoNaData(DateTime data) {
    // Retornaria o preco referente àquela data
    return precoFechamento;
  }
}
