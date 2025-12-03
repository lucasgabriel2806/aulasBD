-- TRIGGERs
/*
Trigger 1: Log de Auditoria na Exclusão de Clientes
Interesse para o Sistema: Garante a rastreabilidade e auditoria ao registrar quem e quando
um cliente foi removido, crucial para requisitos legais ou de negócio.
*/

-- Estrutura de Log (necessária para este Trigger)
CREATE TABLE IF NOT EXISTS log_clientes_excluidos (
    log_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_cliente_excluido INT UNSIGNED NOT NULL,
    nome_completo VARCHAR(91) NOT NULL,
    data_exclusao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (log_id)
);

-- Trigger
DELIMITER $$
CREATE TRIGGER log_exclusao_cliente
BEFORE DELETE ON clientes
FOR EACH ROW
BEGIN
    INSERT INTO log_clientes_excluidos (id_cliente_excluido, nome_completo)
    VALUES (OLD.id_cliente, CONCAT(OLD.primeiro_nome, ' ', OLD.ultimo_nome));
END$$
DELIMITER ;

/*
Trigger 2: Impedir Exclusão de Cliente com Aluguel Pendente
Interesse para o Sistema: Reforça a integridade de dados e a regra de negócio primária: 
um cliente não pode ser excluído se ainda tiver filmes não devolvidos.
*/
DELIMITER $$
CREATE TRIGGER evita_exclusao_cliente_com_aluguel
BEFORE DELETE ON clientes
FOR EACH ROW
BEGIN
    DECLARE alugueis_pendentes INT;

    SELECT COUNT(id_aluguel) INTO alugueis_pendentes
    FROM alugueis
    WHERE cliente_id = OLD.id_cliente
    AND data_devolucao IS NULL;

    IF alugueis_pendentes > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é possível excluir o cliente. Ele possui itens não devolvidos.';
    END IF;
END$$
DELIMITER ;

-- FUNCTIONs
/*
Function 1: Receita Total de uma Loja
Interesse para o Sistema: Permite o cálculo rápido e reutilizável de uma métrica de negócio essencial (receita),
podendo ser usado em relatórios, views ou procedimentos armazenados.
*/
DELIMITER $$
CREATE FUNCTION receita_total_por_loja (p_loja_id INT)
RETURNS DECIMAL(10, 2)
READS SQL DATA
BEGIN
    DECLARE total_receita DECIMAL(10, 2);

    SELECT SUM(p.valor) INTO total_receita
    FROM pagamentos p
    INNER JOIN alugueis a ON p.aluguel_id = a.id_aluguel
    INNER JOIN inventarios i ON a.id_inventario = i.id_inventario
    WHERE i.loja_id = p_loja_id;

    RETURN IFNULL(total_receita, 0.00);
END$$
DELIMITER ;

-- Como usar?
SELECT receita_total_por_loja(1);

/*
Function 2: Contagem de Exemplares Disponíveis de um Filme
Interesse para o Sistema: Essencial para a lógica de aluguel. 
Permite verificar o estoque de um filme em uma loja específica de forma precisa, 
otimizando a experiência do usuário e as operações.
*/
DELIMITER $$
CREATE FUNCTION contar_filmes_disponiveis (p_filme_id INT, p_loja_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE contagem INT;

    SELECT COUNT(i.id_inventario) INTO contagem
    FROM inventarios i
    LEFT JOIN alugueis a ON i.id_inventario = a.id_inventario
        AND a.data_devolucao IS NULL -- Considera apenas aluguéis ativos
    WHERE i.filme_id = p_filme_id
    AND i.loja_id = p_loja_id
    AND a.id_aluguel IS NULL; -- Filtra apenas inventários que NÃO estão em aluguel ativo

    RETURN contagem;
END$$
DELIMITER ;

SELECT contar_filmes_disponiveis(1, 1); -- Conta exemplares do Filme ID 1 na Loja ID 1


-- Store Procedure
/*
Interesse para o Sistema: Encapsula uma transação de negócio complexa 
(devolução e cálculo de multa), garantindo que a lógica seja aplicada de forma consistente
e atômica.

Este procedimento marca o aluguel como devolvido e, 
se houver atraso (baseado na duracao_aluguel do filme), 
calcula e registra uma taxa de atraso na tabela pagamentos.
*/
DELIMITER $$
CREATE PROCEDURE processar_devolucao_e_taxa (
    IN p_aluguel_id INT UNSIGNED,
    IN p_funcionario_id INT UNSIGNED
)
BEGIN
    DECLARE v_dias_atraso INT;
    DECLARE v_valor_multa DECIMAL(5, 2);
    DECLARE v_cliente_id INT UNSIGNED;
    DECLARE v_data_devolucao_prevista DATETIME;
    
    -- Inicia a transação
    START TRANSACTION;

    -- 1. Atualiza a data de devolução do aluguel
    UPDATE alugueis
    SET data_devolucao = NOW()
    WHERE id_aluguel = p_aluguel_id;

    -- 2. Recupera dados para cálculo de multa
    SELECT 
        a.cliente_id, 
        DATE_ADD(a.data_aluguel, INTERVAL f.duracao_aluguel DAY)
    INTO 
        v_cliente_id, 
        v_data_devolucao_prevista
    FROM alugueis a
    INNER JOIN inventarios i ON a.id_inventario = i.id_inventario
    INNER JOIN filmes f ON i.filme_id = f.id_filme
    WHERE a.id_aluguel = p_aluguel_id;

    -- 3. Calcula o atraso e a multa (Multa de R$1.00 por dia de atraso, apenas para exemplo)
    SET v_dias_atraso = DATEDIFF(NOW(), v_data_devolucao_prevista);

    IF v_dias_atraso > 0 THEN
        SET v_valor_multa = v_dias_atraso * 1.00; 

        -- 4. Insere o pagamento da multa
        INSERT INTO pagamentos (cliente_id, funcionario_id, aluguel_id, valor, data_pagamento)
        VALUES (v_cliente_id, p_funcionario_id, p_aluguel_id, v_valor_multa, NOW());
    END IF;

    -- Finaliza a transação
    COMMIT;
END$$
DELIMITER ;

-- Como usar? CALL processar_devolucao_e_taxa(p_aluguel_id, p_funcionario_id);
CALL processar_devolucao_e_taxa(1234, 1);

/*
Stored Procedure 2: Ajustar Preço de Aluguel por Categoria
Interesse para o Sistema: Permite operações administrativas em massa de forma segura e eficiente,
 facilitando ajustes de preços de aluguel (Taxa de Aluguel) 
 para todos os filmes de uma categoria específica.
*/
DELIMITER $$
CREATE PROCEDURE ajustar_preco_por_categoria (
    IN p_nome_categoria VARCHAR(25),
    IN p_novo_valor DECIMAL(4, 2)
)
BEGIN
    DECLARE v_categoria_id INT UNSIGNED;

    -- 1. Busca o ID da categoria
    SELECT id_categoria INTO v_categoria_id
    FROM categorias
    WHERE nome = p_nome_categoria;

    -- 2. Verifica se a categoria existe
    IF v_categoria_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Categoria não encontrada.';
    ELSE
        -- 3. Atualiza a taxa de aluguel para todos os filmes na categoria
        UPDATE filmes f
        INNER JOIN filme_categorias fc ON f.id_filme = fc.filme_id
        SET f.taxa_aluguel = p_novo_valor
        WHERE fc.categoria_id = v_categoria_id;
        
        -- Opcional: Retorna quantos filmes foram atualizados
        SELECT ROW_COUNT() AS filmes_atualizados;
    END IF;
END$$
DELIMITER ;

-- Como usar? CALL ajustar_preco_por_categoria(p_nome_categoria, p_novo_valor);
CALL ajustar_preco_por_categoria('Ação', 2.99);
