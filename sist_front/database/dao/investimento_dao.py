from db import get_connection

class InvestimentoDAO:
    def listar(self):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM investimento")
        dados = cursor.fetchall()
        conn.close()
        return dados

    def inserir(self, nome, valor, id_usuario):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO investimento (nome, valor, id_usuario) VALUES (%s,%s,%s)",
                       (nome, valor, id_usuario))
        conn.commit()
        conn.close()