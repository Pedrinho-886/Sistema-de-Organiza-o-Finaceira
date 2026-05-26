# C:/Sistema-de-Organiza-o-Finaceira/sist_front/backend_python/esquemas.py
from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import datetime
from decimal import Decimal

# Schemas de Usuário
class UsuarioBase(BaseModel):
    nome: str
    email: str

class UsuarioCreate(UsuarioBase):
    senha: str

class UsuarioResponse(UsuarioBase):
    id: int
    model_config = ConfigDict(from_attributes=True)

# Schemas de Conta
class ContaBase(BaseModel):
    nome: str
    saldo: Decimal

class ContaCreate(ContaBase):
    usuario_id: int

class ContaResponse(ContaBase):
    id: int
    usuario_id: int
    model_config = ConfigDict(from_attributes=True)

# Schemas de Transação
class TransacaoBase(BaseModel):
    descricao: str
    valor: Decimal
    tipo: str
    categoria: str

class TransacaoCreate(TransacaoBase):
    conta_id: int

class TransacaoResponse(TransacaoBase):
    id: int
    conta_id: int
    data: datetime
    model_config = ConfigDict(from_attributes=True)

# Schemas de Reserva
class ReservaBase(BaseModel):
    nome_meta: str
    valor_meta: Decimal
    valor_acumulado: Decimal

class ReservaCreate(ReservaBase):
    usuario_id: int

class ReservaResponse(ReservaBase):
    id: int
    usuario_id: int
    model_config = ConfigDict(from_attributes=True)

# Schemas de Investimento
class InvestimentoBase(BaseModel):
    codigo_ativo: str
    tipo_ativo: str
    quantidade: Decimal
    instituicao: str

class InvestimentoCreate(InvestimentoBase):
    usuario_id: int

class InvestimentoResponse(InvestimentoBase):
    id: int
    usuario_id: int
    model_config = ConfigDict(from_attributes=True)

# Schemas de Cartão de Crédito
class CartaoCreditoBase(BaseModel):
    bandeira: str
    limite_total: Decimal
    limite_disponivel: Decimal
    dia_fechamento: int

class CartaoCreditoCreate(CartaoCreditoBase):
    usuario_id: int

class CartaoCreditoResponse(CartaoCreditoBase):
    id: int
    usuario_id: int
    model_config = ConfigDict(from_attributes=True)
