import mysql.connector

def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",  # coloque sua senha se tiver
        database="financeiro"
    )