-- Criação do Banco de Dados

DROP DATABASE IF EXISTS loja_aula_02_10;

CREATE DATABASE IF NOT EXISTS loja_aula_02_10 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE loja_aula_02_10;

CREATE TABLE Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    telefone VARCHAR(13) -- +55 (14) 99999-9999
);

CREATE TABLE Produtos(
	id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT DEFAULT 0
);

CREATE TABLE Vendas(
	id_venda INT AUTO_INCREMENT PRIMARY KEY,
	id_produto INT NOT NULL,
    id_cliente INT NOT NULL,
    quantidade INT NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

CREATE TABLE Vendas_Produtos (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (quantidade * preco_unitario) STORED,
    FOREIGN KEY (id_venda) REFERENCES Vendas(id_venda),
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

-- Modificações Estruturais
	
RENAME TABLE Clientes TO Usuarios;

ALTER TABLE Usuarios CHANGE COLUMN id_cliente id_usuario INT AUTO_INCREMENT;

ALTER TABLE Vendas DROP FOREIGN KEY vendas_ibfk_1;

ALTER TABLE Vendas
CHANGE COLUMN id_cliente id_usuario INT NOT NULL,
ADD CONSTRAINT fk_vendas_usuarios
FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario);

-- Adição e Modificação de Campos

ALTER TABLE usuarios ADD COLUMN ativo TINYINT DEFAULT 1;
ALTER TABLE produtos ADD COLUMN ativo TINYINT DEFAULT 1;
ALTER TABLE vendas ADD COLUMN ativo TINYINT DEFAULT 1;
ALTER TABLE vendas_produtos ADD COLUMN ativo TINYINT DEFAULT 1;

ALTER TABLE usuarios MODIFY COLUMN ativo CHAR(1) DEFAULT 'S';
ALTER TABLE produtos MODIFY COLUMN ativo CHAR(1) DEFAULT 'S';
ALTER TABLE vendas MODIFY COLUMN ativo CHAR(1) DEFAULT 'S';
ALTER TABLE vendas_produtos MODIFY COLUMN ativo CHAR(1) DEFAULT 'S';

-- Gerenciamento de Acesso

CREATE USER IF NOT EXISTS 'lucas'@'localhost' IDENTIFIED BY 'fatec123';

GRANT SELECT, INSERT, UPDATE, DELETE ON loja_aula_02_10.* TO 'lucas'@'localhost';

FLUSH PRIVILEGES;
