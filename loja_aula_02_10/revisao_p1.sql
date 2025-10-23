-- Apaga o BD para garantir que a estrutura será a da versão final do SQL.
DROP DATABASE IF EXISTS loja_revisao;

-- Cria o BD com o charset correto.
CREATE DATABASE IF NOT EXISTS loja_revisao CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- EXTREMAMENTE IMPORTANTE! Tem que avisar qual BD vai utilizar daqui em diante no SQL.
USE loja_revisao;

-- Tabela clientes
-- Só para de dar erro depois de finalizar o script com pelo menos 1 campo
CREATE TABLE IF NOT EXISTS clientes(
	id_cliente BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    -- além de obrigatório, o e-mail deve ser ÚNICO
    email VARCHAR(255) NOT NULL UNIQUE,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(30),
    -- demais campos do cliente...
    -- registros de log
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    -- SOMENTE o MySQL possui o ON UPDATE
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    -- EM campos de DATA/HORA é importante confiar que ele aceita NULL
    deletado_em DATETIME NULL
);

CREATE TABLE IF NOT EXISTS produtos(
	id_produto BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255),
    descricao TEXT,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    estoque DECIMAL(10, 3) DEFAULT 0,
    codigo_barras VARCHAR(50) UNIQUE,
    -- registros de log
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    -- SOMENTE o MySQL possui o ON UPDATE
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    -- EM campos de DATA/HORA é importante confiar que ele aceita NULL
    deletado_em DATETIME NULL
);

CREATE TABLE IF NOT EXISTS vendas(
	id_venda BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT UNSIGNED NOT NULL,
    data_venda DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    forma_pagamento ENUM('dinheiro', 'crédito', 'débito', 'pix'),
    observacoes TEXT,
    desconto_total DECIMAL(10, 2) DEFAULT 0,
    total_venda DECIMAL(10, 2) NOT NULL,
    -- LOGS
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    -- SOMENTE o MySQL possui o ON UPDATE
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    -- EM campos de DATA/HORA é importante confiar que ele aceita NULL
    deletado_em DATETIME NULL,
    
    CONSTRAINT fk_vendas_clientes FOREIGN KEY (cliente_id) REFERENCES clientes (id_cliente)
    );
    
CREATE TABLE IF NOT EXISTS vendas_produtos(
	id_venda_produto BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    venda_id BIGINT UNSIGNED NOT NULL,
    produto_id BIGINT UNSIGNED NOT NULL,
    quantidade DECIMAL(10, 3) NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    desconto DECIMAL(10, 2) DEFAULT 0,
    -- LOGS
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    -- SOMENTE o MySQL possui o ON UPDATE
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    -- EM campos de DATA/HORA é importante confiar que ele aceita NULL
    deletado_em DATETIME NULL,
    
    FOREIGN KEY (produto_id) REFERENCES produtos (id_produto),
    FOREIGN KEY (venda_id) REFERENCES vendas (id_venda)
);
    
-- Modificações Estruturais
ALTER TABLE clientes RENAME TO usuarios;

-- Mudar nome de chave primária
ALTER TABLE usuarios CHANGE COLUMN id_cliente id_usuario BIGINT UNSIGNED NOT NULL AUTO_INCREMENT;

DESCRIBE loja_revisao.usuarios;

-- Mudar nome chave estrangeira
DESCRIBE loja_revisao.vendas;
-- primeiro remove a chave estrangeira
ALTER TABLE vendas DROP FOREIGN KEY fk_vendas_clientes;

-- altera a coluna
ALTER TABLE vendas CHANGE COLUMN cliente_id usuario_id BIGINT UNSIGNED NOT NULL;

ALTER TABLE vendas
	ADD CONSTRAINT fk_vendas_usuarios
    FOREIGN KEY (usuario_id) REFERENCES usuarios (id_usuario);
    
-- Adição e Modificação de campos
ALTER TABLE vendas ADD COLUMN ativo TINYINT NOT NULL DEFAULT 1;
-- adicionar os demais campos nas tabelas

-- Alterando os tipos dos campos
ALTER TABLE vendas MODIFY COLUMN ativo CHAR(1) NOT NULL DEFAULT 'S';
-- ALterar os demais campos nas tabelas 

-- Gerenciamento de Acesso
-- criando usuário
CREATE USER IF NOT EXISTS 'Matheus'@'%' IDENTIFIED BY 'Senha_Super_Segura';
-- concedendo acesso 
GRANT SELECT, INSERT, UPDATE, DELETE ON loja_revisao.* TO 'Ronan'@'%';

-- aplica os privilégios
FLUSH PRIVILEGES;