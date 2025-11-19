USE sakila;

SHOW TABLES;

SELECT * FROM city;

SELECT city, last_update FROM city;

-- CRIANDO FILTROS(=, <>, <, >, <=, >=)
SELECT title, length FROM film
WHERE length > 70;

-- se for usar = tem que ser exatamente o dado correto

SELECT title FROM film WHERE title = 'Academy dinosaur';

-- operadores lógicos (AND, OR)
SELECT title, length FROM film
WHERE length >= 70 AND length <= 100;

SELECT title, length FROM film
WHERE length < 70 OR length = 100;

-- operadores especiais (BETWEEN, IN, LIKE)
SELECT title, length FROM film
WHERE length BETWEEN 70  AND 100;

SELECT * FROM sakila.payment
WHERE payment_date BETWEEN '2005-07-01' AND '2005-07-30';

SELECT * FROM sakila.payment
WHERE payment_id IN(1, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100);


SELECT * FROM film
WHERE title LIKE "%ACADEMY%";

SELECT * FROM film
WHERE title LIKE "%ACADEMY";

SELECT * FROM film
WHERE title LIKE "ACADEMY%";

-- Encontra luisas e luizas no BD
SELECT * FROM clientes
WHERE nome LIKE 'lui_a';

-- Encontra calças e calcas, inclusive calsas
SELECT * FROM podutos
WHERE nome LIKE 'cal_ca';

-- Apelidos
SELECT
	rental_id AS id_aluguel ,
    rental_date AS date_aluguel,
    inventory_id AS inventario_id,
    customer_id AS  cliente_id,
    return_date AS data_devolucao,
    staff_id AS funcionario_id,
    last_update AS  'Última Atualização'
FROM rental;

-- apelidos e relacionamentos 
SELECT
	rental_id AS id_aluguel,
    rental_date AS date_aluguel,
    inventory_id AS inventario_id,
    -- como customer_id existe nas duas tabelas,precisamos informa de qual desejamos
    aluguel.customer_id AS  cliente_id,
    customer.first_name,
    customer.last_name,
    return_date AS data_devolucao,
    staff_id AS funcionario_id,
    aluguel.last_update AS  'Última Atualização'
FROM rental AS aluguel

-- Aqui vai a especiificação de como o relacionamento acontece
INNER JOIN customer ON customer.customer_id = aluguel.customer_id;
