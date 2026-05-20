from flask import Flask, request, jsonify

from dao.usuario_dao import UsuarioDAO
from dao.conta_dao import ContaDAO
from dao.cartao_dao import CartaoDAO
from dao.transacao_dao import TransacaoDAO

app = Flask(__name__)

# ---------- USUARIO ----------
@app.route("/usuarios", methods=["GET"])
def listar_usuarios():
    return jsonify(UsuarioDAO().listar())

@app.route("/usuarios", methods=["POST"])
def criar_usuario():
    data = request.json
    UsuarioDAO().inserir(data["nome"], data["email"], data["senha"])
    return {"msg": "ok"}

# ---------- CONTA ----------
@app.route("/contas", methods=["GET"])
def listar_contas():
    return jsonify(ContaDAO().listar())

@app.route("/contas", methods=["POST"])
def criar_conta():
    data = request.json
    ContaDAO().inserir(data["nome"], data["saldo"], data["id_usuario"])
    return {"msg": "ok"}

# ---------- CARTAO ----------
@app.route("/cartoes", methods=["GET"])
def listar_cartoes():
    return jsonify(CartaoDAO().listar())

@app.route("/cartoes", methods=["POST"])
def criar_cartao():
    data = request.json
    CartaoDAO().inserir(data["nome"], data["limite"], data["id_usuario"])
    return {"msg": "ok"}

# ---------- TRANSACAO ----------
@app.route("/transacoes", methods=["GET"])
def listar_transacoes():
    return jsonify(TransacaoDAO().listar())

@app.route("/transacoes", methods=["POST"])
def criar_transacao():
    data = request.json
    TransacaoDAO().inserir(data["descricao"], data["valor"], data["tipo"], data["id_conta"])
    return {"msg": "ok"}

if __name__ == "__main__":
    app.run(debug=True)