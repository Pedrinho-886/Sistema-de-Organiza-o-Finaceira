from sqlalchemy import Column, Integer, String, Numeric, ForeignKey, DateTime
from banco_de_dados import Base
import datetime

class Usuario(Base):
    __tablename__ = "usuarios"

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String(100))
    email = Column(String(100), unique=True, index=True)
    senha_hash = Column(String(200))

class Conta(Base):
    __tablename__ = "contas"

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String(100))
    saldo = Column(Numeric(10, 2), default=0.0)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"))

class Transacao(Base):
    __tablename__ = "transacoes"

    id = Column(Integer, primary_key=True, index=True)
    descricao = Column(String(200))
    valor = Column(Numeric(10, 2))
    tipo = Column(String(50)) # ex: 'receita' ou 'despesa'
    categoria = Column(String(100)) # ex: 'Salário', 'Investimento', 'Presente'
    data = Column(DateTime, default=datetime.datetime.utcnow)
    conta_id = Column(Integer, ForeignKey("contas.id"))

class Reserva(Base):
    __tablename__ = "reservas"

    id = Column(Integer, primary_key=True, index=True)
    nome_meta = Column(String(100))
    valor_meta = Column(Numeric(10, 2))
    valor_acumulado = Column(Numeric(10, 2), default=0.0)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"))

class Investimento(Base):
    __tablename__ = "investimentos"

    id = Column(Integer, primary_key=True, index=True)
    codigo_ativo = Column(String(20))
    tipo_ativo = Column(String(50))
    quantidade = Column(Numeric(10, 4))
    instituicao = Column(String(100))
    usuario_id = Column(Integer, ForeignKey("usuarios.id"))

class CartaoCredito(Base):
    __tablename__ = "cartoes_credito"

    id = Column(Integer, primary_key=True, index=True)
    bandeira = Column(String(50))
    limite_total = Column(Numeric(10, 2))
    limite_disponivel = Column(Numeric(10, 2))
    dia_fechamento = Column(Integer)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"))
