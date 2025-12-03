USE sakila;
SHOW TABLES;

SELECT * FROM city;

SELECT city, last_update FROM city;

-- Criando filtros (=, <>, <, >, <=, >=)
SELECT title, length FROM film
WHERE length > 70;

SELECT title FROM film WHERE title = 'Academy dinosaur';

-- Operadores lógicos (AND, OR)
SELECT title, length FROM film
WHERE length >= 70 AND length <= 100;

SELECT title, length FROM film
WHERE length < 70 OR length = 100;

-- Operadores especiais (BETWEEN, IN, LIKE)
SELECT title, length FROM film
WHERE length BETWEEN 70 AND 100;

SELECT * FROM sakila.payment
WHERE payment_date BETWEEN '2005-07-01' AND '2005-07-30';

SELECT * FROM sakila.payment
WHERE payment_id IN (1, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100);

SELECT * FROM film
WHERE title LIKE "%ACADEMY%";

SELECT * FROM film
WHERE title LIKE "%ACADEMY";

SELECT * FROM film
WHERE title LIKE "ACADEMY%";

-- Encontra Luisas e Luizas no BD
SELECT * FROM clientes
WHERE nome LIKE 'Lui_a';

-- Encontra calças e calcas, inclusive calsas
SELECT * FROM produtos
WHERE nome LIKE 'cal_ca';


-- Apelidos
SELECT 
	rental_id AS id_aluguel,
    rental_date AS data_aluguel,
    inventory_id AS inventario_id,
    customer_id AS cliente_id,
    return_date AS data_devolucao,
    staff_id AS funcionario_id,
    last_update AS 'Última Atualização'
FROM rental;

-- Apelido + Relacionamentos
SELECT 
	rental_id AS id_aluguel,
    rental_date AS data_aluguel,
    aluguel.inventory_id AS inventario_id,
    -- Como customer_id existe nas duas tabelas, precisamos informa de qual desejamos
    aluguel.customer_id AS cliente_id,
    customer.first_name,
    customer.last_name,
    return_date AS data_devolucao,
    aluguel.staff_id AS funcionario_id,
    staff.first_name AS 'Primeiro Nome do Funcionário',
    staff.last_name AS ultimo_nome_funcionario,
    aluguel.last_update AS 'Última Atualização'
FROM rental AS aluguel
-- Aqui vai a especificação de como o relacionamento acontece
-- Se utilizamos apelido, temos que aplicar ele em tudo!
INNER JOIN customer ON customer.customer_id = aluguel.customer_id
INNER JOIN inventory ON inventory.inventory_id = aluguel.inventory_id
INNER JOIN staff ON staff.staff_id = aluguel.staff_id;

-- Relacionamento com relacionamento

SELECT *
FROM rental
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film ON film.film_id = inventory.film_id
INNER JOIN category ON category.category_id = film.category_id;

-- Problema do N:M
-- Neste tipo de relacionamento o resultado virá repetido para cada "M"
-- Vamos utilizar o ORDER BY para ajudar na visualização
SELECT 
	film.film_id,
    film.title,
    category.category_id,
    category.name
FROM film
INNER JOIN film_category ON film_category.film_id = film.film_id
INNER JOIN category ON category.category_id = film_category.category_id
ORDER BY title, name ASC;

INSERT INTO film_category VALUES (1, 8, NOW());


-- Ordenação e Limite
-- ORDER BY pode ordenar ASC = Crescente e DESC que é decrecente
-- O select abaixo apresenta os pagamentos do maior para o menor.
SELECT * FROM payment
ORDER BY amount DESC;

-- Agora além do critério acima também é organizado a data crescente
SELECT * FROM payment
ORDER BY amount DESC, payment_date ASC;

-- Podemos usar apelidos ou "posição" do critério no SELECT
SELECT p.payment_id, c.first_name, c.last_name, p.amount AS total_pago, payment_date
FROM payment p
INNER JOIN customer c ON c.customer_id = p.customer_id
ORDER BY 2 ASC, total_pago DESC, 3 ASC;

-- Podemos limitar a quantidade de retorno com LIMIT
SELECT * FROM film
LIMIT 10;

-- OFFSET é utilizado para paginação de resultados
SELECT * FROM film
LIMIT 10 OFFSET 10;

-- FUNÇÕES
-- Count conta todos os registros e retorna O número
SELECT COUNT(*) FROM FILM;

-- GROUP BY para auxiliar na contagem
-- Ele é utilizado somente com funções de agregação (Junção de dados)
SELECT COUNT(film.film_id), category.name
FROM film
INNER JOIN film_category ON film_category.film_id = film.film_id
INNER JOIN category ON category.category_id = film_category.category_id
-- Agrupa as categorias antes de fazer o select e ordenar
GROUP BY category.category_id
ORDER BY category.name ASC;

SELECT COUNT(film.film_id) AS "QTDE", category.name, NOW()
FROM film
INNER JOIN film_category ON film_category.film_id = film.film_id
INNER JOIN category ON category.category_id = film_category.category_id
WHERE film.title LIKE "%AC%"
-- Agrupa as categorias antes de fazer o select e ordenar
GROUP BY category.category_id
ORDER BY category.name ASC;






















