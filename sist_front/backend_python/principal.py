from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from banco_de_dados import engine, get_db
import modelos, esquemas
from passlib.context import CryptContext
from typing import List

# Configuração de segurança para senhas
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

modelos.Base.metadata.create_all(bind=engine)

app = FastAPI(title="Sistema Financeiro API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- Rotas de Usuário ---

@app.post("/usuarios/", response_model=esquemas.UsuarioResponse)
def criar_usuario(usuario: esquemas.UsuarioCreate, db: Session = Depends(get_db)):
    db_usuario = db.query(modelos.Usuario).filter(modelos.Usuario.email == usuario.email).first()
    if db_usuario:
        raise HTTPException(status_code=400, detail="Email já cadastrado")
    
    hashed_password = pwd_context.hash(usuario.senha)
    
    novo_usuario = modelos.Usuario(
        nome=usuario.nome, 
        email=usuario.email, 
        senha_hash=hashed_password
    )
    db.add(novo_usuario)
    db.commit()
    db.refresh(novo_usuario)
    return novo_usuario

@app.post("/login")
def login(usuario: esquemas.UsuarioCreate, db: Session = Depends(get_db)):
    db_usuario = db.query(modelos.Usuario).filter(modelos.Usuario.email == usuario.email).first()
    
    if not db_usuario or not pwd_context.verify(usuario.senha, db_usuario.senha_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email ou senha incorretos"
        )
    
    return {"message": "Login realizado com sucesso", "usuario_id": db_usuario.id, "nome": db_usuario.nome}

@app.get("/")
def read_root():
    return {"status": "Arquitetura Online", "database": "Conectado"}

# --- Rotas de Contas ---
@app.get("/contas/{usuario_id}", response_model=List[esquemas.ContaResponse])
def listar_contas(usuario_id: int, db: Session = Depends(get_db)):
    return db.query(modelos.Conta).filter(modelos.Conta.usuario_id == usuario_id).all()

@app.post("/contas/", response_model=esquemas.ContaResponse)
def criar_conta(conta: esquemas.ContaCreate, db: Session = Depends(get_db)):
    nova_conta = modelos.Conta(**conta.model_dump())
    db.add(nova_conta)
    db.commit()
    db.refresh(nova_conta)
    return nova_conta

@app.delete("/contas/{conta_id}")
def excluir_conta(conta_id: int, db: Session = Depends(get_db)):
    db_conta = db.query(modelos.Conta).filter(modelos.Conta.id == conta_id).first()
    if not db_conta:
        raise HTTPException(status_code=404, detail="Conta não encontrada")
    
    # Ao excluir a conta, as transações vinculadas serão excluídas via CASCADE no Banco de Dados
    db.delete(db_conta)
    db.commit()
    return {"message": "Conta excluída com sucesso"}

@app.put("/contas/{conta_id}", response_model=esquemas.ContaResponse)
def atualizar_conta(conta_id: int, conta_update: esquemas.ContaBase, db: Session = Depends(get_db)):
    db_conta = db.query(modelos.Conta).filter(modelos.Conta.id == conta_id).first()
    if not db_conta:
        raise HTTPException(status_code=404, detail="Conta não encontrada")
    
    db_conta.nome = conta_update.nome
    db_conta.saldo = conta_update.saldo
    
    db.commit()
    db.refresh(db_conta)
    return db_conta

# --- Rotas de Transações ---
@app.get("/transacoes/{conta_id}", response_model=List[esquemas.TransacaoResponse])
def listar_transacoes(conta_id: int, db: Session = Depends(get_db)):
    return db.query(modelos.Transacao).filter(modelos.Transacao.conta_id == conta_id).all()

@app.post("/transacoes/", response_model=esquemas.TransacaoResponse)
def criar_transacao(transacao: esquemas.TransacaoCreate, db: Session = Depends(get_db)):
    db_conta = db.query(modelos.Conta).filter(modelos.Conta.id == transacao.conta_id).first()
    if not db_conta:
        raise HTTPException(status_code=404, detail="Conta não encontrada")
    
    nova_transacao = modelos.Transacao(**transacao.model_dump())
    
    if transacao.tipo.lower() == "receita":
        db_conta.saldo += transacao.valor
    else:
        db_conta.saldo -= transacao.valor
        
    db.add(nova_transacao)
    db.commit()
    db.refresh(nova_transacao)
    return nova_transacao

@app.delete("/transacoes/{transacao_id}")
def excluir_transacao(transacao_id: int, db: Session = Depends(get_db)):
    db_transacao = db.query(modelos.Transacao).filter(modelos.Transacao.id == transacao_id).first()
    if not db_transacao:
        raise HTTPException(status_code=404, detail="Transação não encontrada")
    
    # Reverter o saldo na conta
    db_conta = db.query(modelos.Conta).filter(modelos.Conta.id == db_transacao.conta_id).first()
    if db_conta:
        if db_transacao.tipo.lower() == "receita":
            db_conta.saldo -= db_transacao.valor
        else:
            db_conta.saldo += db_transacao.valor
            
    db.delete(db_transacao)
    db.commit()
    return {"message": "Transação excluída com sucesso"}

@app.put("/transacoes/{transacao_id}", response_model=esquemas.TransacaoResponse)
def atualizar_transacao(transacao_id: int, transacao_update: esquemas.TransacaoCreate, db: Session = Depends(get_db)):
    db_transacao = db.query(modelos.Transacao).filter(modelos.Transacao.id == transacao_id).first()
    if not db_transacao:
        raise HTTPException(status_code=404, detail="Transação não encontrada")
    
    # 1. Reverter saldo antigo
    conta_antiga = db.query(modelos.Conta).filter(modelos.Conta.id == db_transacao.conta_id).first()
    if conta_antiga:
        if db_transacao.tipo.lower() == "receita":
            conta_antiga.saldo -= db_transacao.valor
        else:
            conta_antiga.saldo += db_transacao.valor
            
    # 2. Aplicar novo saldo
    conta_nova = db.query(modelos.Conta).filter(modelos.Conta.id == transacao_update.conta_id).first()
    if not conta_nova:
        raise HTTPException(status_code=404, detail="Conta destino não encontrada")
        
    if transacao_update.tipo.lower() == "receita":
        conta_nova.saldo += transacao_update.valor
    else:
        conta_nova.saldo -= transacao_update.valor
        
    # 3. Atualizar dados
    for key, value in transacao_update.model_dump().items():
        setattr(db_transacao, key, value)
        
    db.commit()
    db.refresh(db_transacao)
    return db_transacao

# --- Rotas de Reservas ---
@app.get("/reservas/{usuario_id}", response_model=List[esquemas.ReservaResponse])
def listar_reservas(usuario_id: int, db: Session = Depends(get_db)):
    return db.query(modelos.Reserva).filter(modelos.Reserva.usuario_id == usuario_id).all()

@app.post("/reservas/", response_model=esquemas.ReservaResponse)
def criar_reserva(reserva: esquemas.ReservaCreate, db: Session = Depends(get_db)):
    nova_reserva = modelos.Reserva(**reserva.model_dump())
    db.add(nova_reserva)
    db.commit()
    db.refresh(nova_reserva)
    return nova_reserva

@app.put("/reservas/{reserva_id}", response_model=esquemas.ReservaResponse)
def atualizar_reserva(reserva_id: int, reserva_update: esquemas.ReservaBase, db: Session = Depends(get_db)):
    db_reserva = db.query(modelos.Reserva).filter(modelos.Reserva.id == reserva_id).first()
    if not db_reserva:
        raise HTTPException(status_code=404, detail="Reserva não encontrada")
    
    db_reserva.nome_meta = reserva_update.nome_meta
    db_reserva.valor_meta = reserva_update.valor_meta
    db_reserva.valor_acumulado = reserva_update.valor_acumulado
    
    db.commit()
    db.refresh(db_reserva)
    return db_reserva

@app.delete("/reservas/{reserva_id}")
def excluir_reserva(reserva_id: int, db: Session = Depends(get_db)):
    db_reserva = db.query(modelos.Reserva).filter(modelos.Reserva.id == reserva_id).first()
    if not db_reserva:
        raise HTTPException(status_code=404, detail="Reserva não encontrada")
    
    db.delete(db_reserva)
    db.commit()
    return {"message": "Reserva excluída com sucesso"}
