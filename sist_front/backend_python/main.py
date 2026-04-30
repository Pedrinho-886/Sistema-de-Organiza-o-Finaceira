from fastapi import FastAPI

app = FastAPI(title="Sistema Financeiro API", version="1.0.0")

@app.get("/")
def read_root():
    return {"message": "Bem-vindo à API do Sistema Financeiro!"}
