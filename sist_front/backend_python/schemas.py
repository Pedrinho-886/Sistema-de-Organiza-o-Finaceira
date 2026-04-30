from pydantic import BaseModel
from typing import Optional
from datetime import datetime

# Schemas de Usuário
class UsuarioBase(BaseModel):
    nome: str
    email: str

class UsuarioCreate(UsuarioBase):
    senha: str

class UsuarioResponse(UsuarioBase):
    id: int
    
    class Config:
        orm_mode = True

# Schemas de Conta
class ContaBase(BaseModel):
    nome: str
    saldo: float

class ContaCreate(ContaBase):
    usuario_id: int

class ContaResponse(ContaBase):
    id: int
    usuario_id: int
    
    class Config:
        orm_mode = True

# Schemas de Transação
class TransacaoBase(BaseModel):
    descricao: str
    valor: float
    tipo: str

class TransacaoCreate(TransacaoBase):
    conta_id: int

class TransacaoResponse(TransacaoBase):
    id: int
    conta_id: int
    data: datetime
    
    class Config:
        orm_mode = True
