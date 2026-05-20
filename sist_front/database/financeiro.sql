-- =========================
-- LIMPAR E CRIAR BANCO
-- =========================
DROP DATABASE IF EXISTS financeiro;
CREATE DATABASE financeiro;
USE financeiro;

-- =========================
-- TABELA USUARIO
-- =========================
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- TABELA CATEGORIA
-- =========================
CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo ENUM('receita', 'despesa') NOT NULL
);

-- =========================
-- TABELA CONTA
-- =========================
CREATE TABLE conta (
    id_conta INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    saldo DECIMAL(10,2) DEFAULT 0,
    id_usuario INT NOT NULL,

    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE CASCADE
);

-- =========================
-- TABELA TRANSACAO
-- =========================
CREATE TABLE transacao (
    id_transacao INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(200),
    valor DECIMAL(10,2) NOT NULL,
    tipo ENUM('receita', 'despesa') NOT NULL,
    data DATE NOT NULL,

    id_usuario INT NOT NULL,
    id_categoria INT,
    id_conta INT,

    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE,

    FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria)
        ON DELETE SET NULL,

    FOREIGN KEY (id_conta)
        REFERENCES conta(id_conta)
        ON DELETE SET NULL
);

-- =========================
-- TABELA META
-- =========================
CREATE TABLE meta (
    id_meta INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    valor_meta DECIMAL(10,2),
    valor_atual DECIMAL(10,2) DEFAULT 0,
    data_limite DATE,

    id_usuario INT NOT NULL,

    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE CASCADE
);

-- =========================
-- ÍNDICES (PERFORMANCE)
-- =========================
CREATE INDEX idx_transacao_usuario ON transacao(id_usuario);
CREATE INDEX idx_transacao_categoria ON transacao(id_categoria);
CREATE INDEX idx_transacao_conta ON transacao(id_conta);

-- =========================
-- DADOS DE TESTE
-- =========================
INSERT INTO usuario (nome, email, senha) VALUES
('Ana', 'ana@email.com', '123'),
('Joao', 'joao@email.com', '123');

INSERT INTO categoria (nome, tipo) VALUES
('Salario', 'receita'),
('Alimentacao', 'despesa'),
('Transporte', 'despesa');

INSERT INTO conta (nome, saldo, id_usuario) VALUES
('Carteira', 500.00, 1),
('Banco', 2000.00, 1);

INSERT INTO transacao (descricao, valor, tipo, data, id_usuario, id_categoria, id_conta) VALUES
('Mercado', 150.00, 'despesa', '2026-04-20', 1, 2, 1),
('Salario', 3000.00, 'receita', '2026-04-01', 1, 1, 2);

INSERT INTO meta (nome, valor_meta, valor_atual, data_limite, id_usuario) VALUES
('Celular', 2000, 500, '2026-12-31', 1);