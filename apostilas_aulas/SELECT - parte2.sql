USE sakila_pt;
-- Agregação
SELECT SUM(valor), AVG(valor), MAX(valor), MIN(valor), funcionario_id FROM pagamentos
WHERE data_pagamento < '2006-02-15'
GROUP BY funcionario_id;

-- Alteração da Visualização
SELECT UPPER(CONCAT(primeiro_nome, ' ',ultimo_nome)) AS nome, email
FROM clientes;

SELECT LOWER(titulo), titulo FROM filmes;

SELECT * FROM filmes
WHERE LOWER(titulo) = LOWER('A Batalha do Golfo');
-- date('d/m/Y', strtotime($var_data));
-- DATE FORMAT - Consultar a apostila!
SELECT 
	id_pagamento AS id,
	CONCAT(clientes.primeiro_nome, ' ', clientes.ultimo_nome) AS nome_cliente,
    DATE_FORMAT(data_pagamento, '%d/%m/%Y') AS data_pagamento,
    valor,
    FORMAT(valor, 2, 'pt_BR') AS valor_pt
FROM pagamentos
INNER JOIN clientes ON pagamentos.cliente_id = clientes.id_cliente;

-- Subquery - Podemos inserir SELECTs dentros de outros SELECTs
-- para ampliar o poder de consulta em lugares que o JOIN não resolve.

-- Exibir clientes com pagamentos acima da média
SELECT
	CONCAT(c.primeiro_nome, ' ', c.ultimo_nome) AS nome_cliente,
    p.data_pagamento,
    p.valor
FROM clientes c
INNER JOIN pagamentos p ON c.id_cliente = p.cliente_id
WHERE
	p.valor > (
		-- Cria o resultado a ser utilizado para o IN
        SELECT AVG(valor)
        FROM pagamentos        
    );
    
-- SELECT no FROM - Usamos o resultado de um SELECT para fazer novos filtros.
SELECT resultado.nome_cliente, resultado.valor
FROM (
		-- Exibir clientes com pagamentos acima da média
		SELECT
			CONCAT(c.primeiro_nome, ' ', c.ultimo_nome) AS nome_cliente,
			p.data_pagamento,
			p.valor
		FROM clientes c
		INNER JOIN pagamentos p ON c.id_cliente = p.cliente_id
		WHERE
			p.valor > (
				-- Cria o resultado a ser utilizado para o IN
				SELECT AVG(valor)
				FROM pagamentos        
			) -- FIM DO SELECT INTERNO
	) AS resultado
WHERE resultado.valor < 6;

-- SELECT dentro de SELECT dentro de SELECT
SELECT
	CONCAT(c.primeiro_nome, ' ', c.ultimo_nome) AS nome_cliente
    -- p.data_pagamento,
    -- p.valor
FROM clientes c
INNER JOIN pagamentos p ON c.id_cliente = p.cliente_id
WHERE
	c.id_cliente IN (
		SELECT p.cliente_id FROM pagamentos p WHERE p.valor >(
				SELECT AVG(valor) FROM pagamentos
		)
    )
GROUP BY nome_cliente -- Prefira GROUP BY ao DISTINCT
ORDER BY nome_cliente ASC;







