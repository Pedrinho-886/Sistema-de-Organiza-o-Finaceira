from db import get_connection

class ContaDAO:
    def listar(self):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM conta")
        dados = cursor.fetchall()
        conn.close()
        return dados

    def inserir(self, nome, saldo, id_usuario):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO conta (nome, saldo, id_usuario) VALUES (%s,%s,%s)", (nome, saldo, id_usuario))
        conn.commit()
        conn.close()

    def atualizar(self, id, nome, saldo):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("UPDATE conta SET nome=%s, saldo=%s WHERE id_conta=%s", (nome, saldo, id))
        conn.commit()
        conn.close()

    def deletar(self, id):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM conta WHERE id_conta=%s", (id,))
        conn.commit()
        conn.close()