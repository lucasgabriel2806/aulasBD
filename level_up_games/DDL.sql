CREATE DATABASE IF NOT EXISTS level_up_games CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE level_up_games;

CREATE TABLE IF NOT EXISTS clientes(
	id_cliente BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    telefone VARCHAR(20),
    logradouro VARCHAR(255),
    numero VARCHAR(255),
    complemento VARCHAR(255),
    bairro VARCHAR(255),
    cidade VARCHAR(255), 
    estado VARCHAR(255),
    cpf VARCHAR(14) UNIQUE,
    rg VARCHAR(12) UNIQUE,
    -- Registros de log
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deletado_em DATETIME NULL
);

CREATE TABLE IF NOT EXISTS plataformas(
	id_plataforma BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL UNIQUE,
    -- Registros de log
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deletado_em DATETIME NULL
);

CREATE TABLE IF NOT EXISTS generos(
	id_genero BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL UNIQUE,
    -- Registros de log
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deletado_em DATETIME NULL
);

CREATE TABLE IF NOT EXISTS jogos(
	id_jogo BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    plataforma_id BIGINT UNSIGNED NOT NULL,
    genero_id BIGINT UNSIGNED NOT NULL,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    quantidade INT DEFAULT 0,
    codigo_barras VARCHAR(50) UNIQUE,
    -- Registros de log
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deletado_em DATETIME NULL,
    CONSTRAINT fk_jogos_plataformas FOREIGN KEY (plataforma_id) REFERENCES plataformas (id_plataforma),
    CONSTRAINT fk_jogos_generos FOREIGN KEY (genero_id) REFERENCES generos (id_genero)
);

CREATE TABLE IF NOT EXISTS vendas(
	id_venda BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT UNSIGNED NOT NULL,
    data_venda DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    forma_pagamento ENUM('Dineiro', 'Crédito', 'Débito', 'Pix'),
    observacoes TEXT,
    desconto_total DECIMAL(10, 2) DEFAULT 0,
    total_venda DECIMAL(10, 2) NOT NULL,
    -- Registros de log
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deletado_em DATETIME NULL,
    CONSTRAINT fk_vendas_clientes FOREIGN KEY (cliente_id) REFERENCES clientes (id_cliente)
);

CREATE TABLE IF NOT EXISTS vendas_jogos(
	id_venda_produto BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    venda_id BIGINT UNSIGNED NOT NULL,
    jogo_id BIGINT UNSIGNED NOT NULL,
    quantidade DECIMAL(10, 3) NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    desconto DECIMAL(10, 2) DEFAULT 0,
    -- Registro de logs
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deletado_em DATETIME NULL,
    FOREIGN KEY (venda_id) REFERENCES vendas (id_venda),
    FOREIGN KEY (jogo_id) REFERENCES jogos (id_jogo)
);