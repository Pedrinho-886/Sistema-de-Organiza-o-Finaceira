from db import get_connection

class ParcelamentoDAO:
    def listar(self):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM parcelamento")
        dados = cursor.fetchall()
        conn.close()
        return dados

    def inserir(self, descricao, valor_total, parcelas, id_usuario):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO parcelamento (descricao, valor_total, parcelas, id_usuario) VALUES (%s,%s,%s,%s)",
                       (descricao, valor_total, parcelas, id_usuario))
        conn.commit()
        conn.close()

    def deletar(self, id):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM parcelamento WHERE id_parcelamento=%s", (id,))
        conn.commit()
        conn.close()