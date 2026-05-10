from db import get_connection

class CartaoDAO:
    def listar(self):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM cartao")
        dados = cursor.fetchall()
        conn.close()
        return dados

    def inserir(self, nome, limite, id_usuario):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO cartao (nome, limite, id_usuario) VALUES (%s,%s,%s)", (nome, limite, id_usuario))
        conn.commit()
        conn.close()

    def atualizar(self, id, nome, limite):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("UPDATE cartao SET nome=%s, limite=%s WHERE id_cartao=%s", (nome, limite, id))
        conn.commit()
        conn.close()

    def deletar(self, id):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM cartao WHERE id_cartao=%s", (id,))
        conn.commit()
        conn.close()