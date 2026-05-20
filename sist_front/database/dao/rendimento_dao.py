from db import get_connection

class RendimentoDAO:
    def listar(self):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM rendimento")
        dados = cursor.fetchall()
        conn.close()
        return dados