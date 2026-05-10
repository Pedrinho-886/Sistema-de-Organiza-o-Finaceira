from db import get_connection

class UsuarioDAO:

    def listar(self):
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM usuario")
        dados = cursor.fetchall()
        conn.close()
        return dados

    def inserir(self, nome, email, senha):
        conn = get_connection()
        cursor = conn.cursor()
        sql = "INSERT INTO usuario (nome, email, senha) VALUES (%s, %s, %s)"
        cursor.execute(sql, (nome, email, senha))
        conn.commit()
        conn.close()

    def atualizar(self, id, nome, email, senha):
        conn = get_connection()
        cursor = conn.cursor()
        sql = "UPDATE usuario SET nome=%s, email=%s, senha=%s WHERE id_usuario=%s"
        cursor.execute(sql, (nome, email, senha, id))
        conn.commit()
        conn.close()

    def deletar(self, id):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM usuario WHERE id_usuario=%s", (id,))
        conn.commit()
        conn.close()