from db import get_connection

class CotacaoDAO:
    def listar(self):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM cotacao")
        dados = cursor.fetchall()
        conn.close()
        return dados