-- CRUD com SQL
USE level_up_games;

-- C -> Create = INSERT -> Insere dados em uma tabela
INSERT INTO tabela (campo1, campo2, campo3)
	VALUES (valor1, 'valor2', 'YYYY-mm-dd');
    
INSERT INTO generos (nome) VALUES ('Fic');

INSERT INTO generos (nome) VALUES ('RPG'), ('Mundo Aberto');

INSERT INTO clientes (id_clientes, nome, nome_social, doc_federal, doc_estadual, 
						email, telefone, data_nascimento, cep, logradouro, numero,
                        complemento, bairro, cidade, estado, criado_em, alterado_em, 
                        deletado_em)
	VALUES(NULL, 'Ronan Adriel Zenatti', NULL, '355.936.478-79', '41.324.990-6',
			'ronan@ronan.com', '(14) 9 8157-5657', '1988-02-25', '17.270-032', 
            'Rua dos Lavradores', '302', 'Casa', 'Centro', 'Boracéia', 'SP', 
            NOW(), NOW(), NULL);

-- R -> Read = SELECT -> Visualiza os dados presentes na tabela.
-- Mostra todos os campos e todos os dados de uma tabela

DESCRIBE clientes;

SELECT * FROM clientes;

SELECT * FROM generos;

SELECT nome, `data`, deletado_em FROM generos;

SELECT `clientes`.`id_clientes`,
    `clientes`.`nome`,
    `clientes`.`nome_social`,
    `clientes`.`doc_federal`,
    `clientes`.`doc_estadual`,
    `clientes`.`email`,
    `clientes`.`telefone`,
    `clientes`.`data_nascimento`,
    `clientes`.`cep`,
    `clientes`.`logradouro`,
    `clientes`.`numero`,
    `clientes`.`complemento`,
    `clientes`.`bairro`,
    `clientes`.`cidade`,
    `clientes`.`estado`,
    `clientes`.`criado_em`,
    `clientes`.`alterado_em`,
    `clientes`.`deletado_em`
FROM `level_up_games`.`clientes`;

-- LIMPA A TABELA E ZERA OS CONTADORES DE AUTO INCREMENTO
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE clientes;
SET FOREIGN_KEY_CHECKS = 1;

-- U -> Update = UPDATE -> Altera os dados presentes na tabela.
UPDATE generos SET
nome = 'Ficção'
WHERE id_genero = 6;

UPDATE clientes SET
nome = "Deodoro da Fonsaca",
nome_social = "Senhor Presidente",
cidade = "Brasilia",
estado = 'DF'
WHERE id_clientes = 2;

-- D -> Delete = DELETE ou UPDATE -> Deleta ou marca como deletado os dados presentes na tabela.

-- DELETE FÍSICO : Remove completamente os dados da tabela:
SELECT * FROM clientes WHERE id_cliente = 10;
DELETE FROM clientes WHERE id_cliente = 10;

-- DELEÇÃO LÓGICA: Utiliza um campo para avisar que o registro foi "DELETADO"
-- Essa abordagem apesar de ser a mais indicada, OBRIGA a utilizar where em todos os SELECTs
SELECT * FROM clientes WHERE deletado_em IS NULL;
UPDATE clientes SET deletado_em = NOW() WHERE id_cliente = 11;
SELECT * FROM clientes WHERE deletado_em IS NOT NULL;













