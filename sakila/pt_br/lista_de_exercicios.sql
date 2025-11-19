-- 1. Inserir Registros (INSERT)
-- 1.1 Insira um novo ator com o nome 'CARLOS' e sobrenome 'GOMES'.
INSERT INTO atores (primeiro_nome, ultimo_nome) VALUES ('CARLOS', 'GOMES');

-- 1.2 Insira uma nova categoria chamada 'Brasileiro'.
INSERT INTO categorias (nome) VALUES ('Brasileiro');

-- 1.3 Insira um novo idioma chamado 'Português'.
INSERT INTO idiomas (nome) VALUES ('Português');

-- 1.4 Insira um novo pais chamado 'Brasil'.
INSERT INTO paises (pais) VALUES ('Brasil');

-- 1.5 Usando o id_pais criado para 'Brasil', insira uma cidade chamada 'Rio de Janeiro'.
INSERT INTO cidades (cidade, pais_id) VALUES ('Rio de Janeiro', 110);

-- 1.6 Usando o id_cidade criado para 'Rio de Janeiro', insira um endereco 
-- (logradouro 'Rua Copacabana, 10', bairro 'Copacabana', cep '22000111', telefone '2199998888').
INSERT INTO enderecos (logradouro, bairro, cidade_id, codigo_postal, telefone) 
			VALUES ('Rua Copacabana, 10', 'Copacabana', 601, '22000111', '2199998888');
            
-- 1.7 Usando o id_endereco anterior e loja_id 1, insira um novo cliente 
-- (Ex: 'JOANA', 'SILVA', 'joana@email.com', criado_em = NOW()).
INSERT INTO clientes (loja_id, primeiro_nome, ultimo_nome, email, endereco_id, criado_em) 
			VALUES (1, 'JOANA', 'SILVA', 'joana@email.com', 606, NOW());
            
-- 1.8 Insira um novo filme 
-- ('TÍTULO NOVO', 'Descrição...', 2025, idioma_id 1, duracao_aluguel 5, taxa_aluguel 3.99, custo_reposicao 19.99).
INSERT INTO filmes (titulo, descricao, ano_lancamento, idioma_id, duracao_aluguel, taxa_aluguel, custo_reposicao)
			VALUES ('TITULO NOVO', 'Descrição...', 2025, 1, 5, 3.99, 19.99);
            
-- 1.9 Associe o ator 'CARLOS GOMES' ao 'TÍTULO NOVO' na tabela filmes_atores.
INSERT INTO filmes_atores (ator_id, filme_id) 
			VALUES (201, 1001);            
            
-- 1.10 Associe o 'TÍTULO NOVO' à categoria 'Brasileiro' na tabela filmes_categorias.
INSERT INTO filmes_categorias (filme_id, categoria_id)
			VALUES (1001, 17);
            
            
            