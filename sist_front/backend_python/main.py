from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from database import engine, get_db
import models, schemas
from passlib.context import CryptContext

# Configuração de segurança para senhas
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="Sistema Financeiro API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- Rotas de Usuário ---

@app.post("/usuarios/", response_model=schemas.UsuarioResponse)
def criar_usuario(usuario: schemas.UsuarioCreate, db: Session = Depends(get_db)):
    # Verificar se o email já existe
    db_usuario = db.query(models.Usuario).filter(models.Usuario.email == usuario.email).first()
    if db_usuario:
        raise HTTPException(status_code=400, detail="Email já cadastrado")
    
    # Criar hash da senha
    hashed_password = pwd_context.hash(usuario.senha)
    
    # Salvar no banco
    novo_usuario = models.Usuario(
        nome=usuario.nome, 
        email=usuario.email, 
        senha_hash=hashed_password
    )
    db.add(novo_usuario)
    db.commit()
    db.refresh(novo_usuario)
    return novo_usuario

@app.post("/login")
def login(usuario: schemas.UsuarioCreate, db: Session = Depends(get_db)):
    # Buscar usuário por email
    db_usuario = db.query(models.Usuario).filter(models.Usuario.email == usuario.email).first()
    
    if not db_usuario or not pwd_context.verify(usuario.senha, db_usuario.senha_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email ou senha incorretos"
        )
    
    return {"message": "Login realizado com sucesso", "usuario_id": db_usuario.id, "nome": db_usuario.nome}

@app.get("/")
def read_root():
    return {"status": "Arquitetura Online", "database": "Conectado"}
