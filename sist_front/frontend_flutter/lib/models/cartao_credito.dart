class CartaoCredito {
  final int id;
  final String bandeira;
  final double limiteTotal;
  double limiteDisponivel;
  final int diaFechamento;

  CartaoCredito({
    required this.id,
    required this.bandeira,
    required this.limiteTotal,
    required this.limiteDisponivel,
    required this.diaFechamento,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bandeira': bandeira,
      'limiteTotal': limiteTotal,
      'limiteDisponivel': limiteDisponivel,
      'diaFechamento': diaFechamento,
    };
  }

  factory CartaoCredito.fromMap(Map<String, dynamic> map) {
    return CartaoCredito(
      id: map['id']?.toInt() ?? 0,
      bandeira: map['bandeira'] ?? '',
      limiteTotal: map['limiteTotal']?.toDouble() ?? 0.0,
      limiteDisponivel: map['limiteDisponivel']?.toDouble() ?? 0.0,
      diaFechamento: map['diaFechamento']?.toInt() ?? 1,
    );
  }

  // Métodos de negócio
  void registrarGastoNoCartao(double valor) {
    if (limiteDisponivel >= valor) {
      limiteDisponivel -= valor;
    } else {
      throw Exception('Limite Indisponível');
    }
  }

  void pagarFatura() {
    // Lógica de pagamento (restaurar limite)
    limiteDisponivel = limiteTotal;
  }
}
