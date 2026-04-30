from sqlalchemy import Column, Integer, String, Float, ForeignKey, DateTime
from database import Base
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
    saldo = Column(Float, default=0.0)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"))

class Transacao(Base):
    __tablename__ = "transacoes"

    id = Column(Integer, primary_key=True, index=True)
    descricao = Column(String(200))
    valor = Column(Float)
    tipo = Column(String(50)) # ex: 'receita' ou 'despesa'
    data = Column(DateTime, default=datetime.datetime.utcnow)
    conta_id = Column(Integer, ForeignKey("contas.id"))
