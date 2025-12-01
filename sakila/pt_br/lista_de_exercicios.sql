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
            
-- 2. Atualizar Registros (UPDATE)
-- 2.1 Atualize o ultimo_nome da ator 'PENELOPE GUINESS' (id 1) para 'PENEZELOPE CRUZ'.
UPDATE atores
SET primeiro_nome = 'PENEZELOPE', ultimo_nome = 'CRUZ'
WHERE id_ator = 1;

-- 2.2 Atualize o email da cliente 'MARY SMITH' (id 1) para 'mary.smith.new@email.com'.
UPDATE clientes
SET email = 'mary.smith.new@email.com'
WHERE id_cliente = 1;

-- 2.3 Aumente a taxa_aluguel em $1,00 para todos os filmes com classificacao 'R'.
UPDATE filmes
SET taxa_aluguel = 1.00
WHERE classificacao = 'R'
AND id_filme > 0; -- safe update mode
-- SET SQL_SAFE_UPDATES = 0;
-- SET SQL_SAFE_UPDATES = 1;

-- 2.4 Mude o endereco_id do cliente 'JARED ELY' (id 15) para 20.
UPDATE clientes
SET endereco_id = 20
WHERE primeiro_nome = 'JARED' AND ultimo_nome = 'ELY';

-- 2.5 Atualize a classificacao do filme 'ACE GOLDFINGER' (id 2) para 'PG-13'.
UPDATE filmes
SET classificacao = 'PG-13'
WHERE id_filme = 2;

-- 2.6 Atualize o telefone do endereco com id_endereco 10 para '11987654321'.
UPDATE enderecos 
SET telefone = 11987654321
WHERE id_endereco = 10;

-- 2.7 Marque o cliente 'WILLIAM BROWN' (id 16) como ativo = 0.
UPDATE clientes 
SET ativo = 0
WHERE id_cliente = 16;

-- 2.8 Atualize o funcionario_gerente_id da loja 1 para o funcionario_id 2.
-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

-- 2.9 Para o aluguel com id_aluguel 100, registre a data_devolucao como a data e hora atuais (use NOW()).
UPDATE alugueis
SET data_devolucao = NOW()
WHERE id_aluguel = 100;

-- 2.10 Diminua o custo_reposicao em 10% para todos os filmes lançados (ano_lancamento) antes de 2005.
UPDATE filmes 
SET custo_reposicao = custo_reposicao - (custo_reposicao * 0.10)
WHERE ano_lancamento < 2005 AND id_filme > 0;