from db import get_connection

class TransacaoDAO:
    def listar(self):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM transacao")
        dados = cursor.fetchall()
        conn.close()
        return dados

    def inserir(self, descricao, valor, tipo, id_conta):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO transacao (descricao, valor, tipo, id_conta) VALUES (%s,%s,%s,%s)",
                       (descricao, valor, tipo, id_conta))
        conn.commit()
        conn.close()

    def atualizar(self, id, descricao, valor):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("UPDATE transacao SET descricao=%s, valor=%s WHERE id_transacao=%s",
                       (descricao, valor, id))
        conn.commit()
        conn.close()

    def deletar(self, id):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM transacao WHERE id_transacao=%s", (id,))
        conn.commit()
        conn.close()