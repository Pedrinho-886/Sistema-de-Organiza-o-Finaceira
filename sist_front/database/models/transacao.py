class Transacao:
    def __init__(self, id_transacao, valor, data, categoria, tipo, id_conta, id_cartao):
        self.id_transacao = id_transacao
        self.valor = valor
        self.data = data
        self.categoria = categoria
        self.tipo = tipo
        self.id_conta = id_conta
        self.id_cartao = id_cartao