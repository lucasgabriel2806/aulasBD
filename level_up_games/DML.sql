INSERT INTO generos (nome) VALUES ('Ação');
INSERT INTO generos (nome) VALUES ('RPG'), ('Mundo Aberto');
             
INSERT INTO clientes (id_cliente, nome, email, telefone, logradouro, numero, complemento, bairro, cidade, estado, cpf, rg) 
VALUES (NULL, 'Lucas Gabriel de Paula Pinto', 'lucas.gabriellgpp@gmail.com', '+55 (14) 9 9177-6338', 
		'Rua X', '123', 'Casa', 'Bairro X', 'Cidade X', 'Estado X', '123-456-789-09', '12.345.678-9');
             
SELECT * FROM clientes;

SHOW TABLES;