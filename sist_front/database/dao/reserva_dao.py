from db import get_connection

class ReservaDAO:
    def listar(self):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM reserva")
        dados = cursor.fetchall()
        conn.close()
        return dados

    def inserir(self, nome, valor, id_usuario):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO reserva (nome, valor, id_usuario) VALUES (%s,%s,%s)",
                       (nome, valor, id_usuario))
        conn.commit()
        conn.close()

    def deletar(self, id):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM reserva WHERE id_reserva=%s", (id,))
        conn.commit()
        conn.close()