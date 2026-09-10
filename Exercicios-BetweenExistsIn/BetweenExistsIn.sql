-- Challenge Night III – BETWEEN, IN, LIKE, EXISTS (Missões da Noite)
-- Consultas SQL para as 20 Missões

-- ==========================================
-- PARTE 1 — COALESCE
-- ==========================================

-- Missão 1 — Clientes sem compras
SELECT 
    c.nome, 
    c.cidade, 
    COALESCE(SUM(iv.quantidade * iv.preco_unitario), 0) AS valor_total_gasto
FROM Clientes c
LEFT JOIN Vendas v ON c.id_cliente = v.id_cliente
LEFT JOIN Itens_Venda iv ON v.id_venda = iv.id_venda
GROUP BY c.id_cliente, c.nome, c.cidade;

-- Missão 2 — Produtos sem vendas
SELECT 
    p.nome, 
    p.preco, 
    p.estoque, 
    COALESCE(SUM(iv.quantidade), 0) AS quantidade_total_vendida
FROM Produtos p
LEFT JOIN Itens_Venda iv ON p.id_produto = iv.id_produto
GROUP BY p.id_produto, p.nome, p.preco, p.estoque;

-- Missão 3 — Desempenho dos vendedores
SELECT 
    vd.nome, 
    COUNT(DISTINCT v.id_venda) AS quantidade_vendas, 
    COALESCE(SUM(iv.quantidade * iv.preco_unitario), 0) AS faturamento_total
FROM Vendedores vd
LEFT JOIN Vendas v ON vd.id_vendedor = v.id_vendedor
LEFT JOIN Itens_Venda iv ON v.id_venda = iv.id_venda
GROUP BY vd.id_vendedor, vd.nome;

-- Missão 4 — Classificação de clientes
WITH GastoCliente AS (
    SELECT 
        c.id_cliente, 
        c.nome, 
        c.cidade, 
        COALESCE(SUM(iv.quantidade * iv.preco_unitario), 0) AS total_gasto
    FROM Clientes c
    LEFT JOIN Vendas v ON c.id_cliente = v.id_cliente
    LEFT JOIN Itens_Venda iv ON v.id_venda = iv.id_venda
    GROUP BY c.id_cliente, c.nome, c.cidade
)
SELECT nome, cidade, total_gasto
FROM GastoCliente
ORDER BY total_gasto DESC;

-- ==========================================
-- PARTE 2 — BETWEEN e >= / <=
-- ==========================================

-- Missão 5 — Clientes por faixa de renda
SELECT nome, cidade, renda
FROM Clientes
WHERE renda BETWEEN 3000 AND 6000;

-- Missão 6 — Comparando formas de escrever intervalos
SELECT nome, cidade, renda
FROM Clientes
WHERE renda >= 3000 AND renda <= 6000;
-- Resposta da pergunta: Os resultados das duas consultas devem ser exatamente iguais, pois o BETWEEN é inclusivo, ou seja, ele inclui os valores das extremidades (3000 e 6000), o que equivale exatamente a >= e <=.

-- Missão 7 — Período de vendas
SELECT 
    v.id_venda AS codigo_venda, 
    v.data_venda, 
    c.nome AS cliente, 
    vd.nome AS vendedor
FROM Vendas v
INNER JOIN Clientes c ON v.id_cliente = c.id_cliente
INNER JOIN Vendedores vd ON v.id_vendedor = vd.id_vendedor
WHERE v.data_venda BETWEEN '2025-01-01' AND '2025-03-31';

-- Missão 8 — Produtos em determinada faixa de preço
SELECT nome AS produto, preco, estoque
FROM Produtos
WHERE preco >= 100 AND preco <= 250;

-- ==========================================
-- PARTE 3 — IN
-- ==========================================

-- Missão 9 — Campanha regional
SELECT nome, cidade
FROM Clientes
WHERE cidade IN ('Curitiba', 'Colombo', 'São José dos Pinhais');

-- Missão 10 — Produtos selecionados
SELECT id_produto AS codigo, nome, preco, estoque
FROM Produtos
WHERE id_produto IN (1, 3, 5, 7);

-- Missão 11 — Vendas de vendedores selecionados
SELECT 
    vd.nome AS nome_vendedor, 
    v.id_venda AS codigo_venda, 
    v.data_venda
FROM Vendas v
INNER JOIN Vendedores vd ON v.id_vendedor = vd.id_vendedor
WHERE vd.id_vendedor IN (1, 3, 5);

-- ==========================================
-- PARTE 4 — LIKE
-- ==========================================

-- Missão 12 — Busca por nomes
SELECT nome, cidade, renda
FROM Clientes
WHERE nome LIKE 'A%';

-- Missão 13 — Busca por sobrenome
SELECT nome
FROM Clientes
WHERE nome LIKE '%Silva';

-- Missão 14 — Busca por parte do nome
SELECT nome
FROM Vendedores
WHERE nome LIKE '%Eduardo%';

-- ==========================================
-- PARTE 5 — EXISTS
-- ==========================================

-- Missão 15 — Clientes que já compraram
SELECT id_cliente AS codigo, nome, cidade
FROM Clientes c
WHERE EXISTS (
    SELECT 1 
    FROM Vendas v 
    WHERE v.id_cliente = c.id_cliente
);

-- Missão 16 — Produtos que já foram vendidos
SELECT id_produto AS codigo, nome, preco
FROM Produtos p
WHERE EXISTS (
    SELECT 1 
    FROM Itens_Venda iv 
    WHERE iv.id_produto = p.id_produto
);

-- Missão 17 — Vendedores ativos
SELECT id_vendedor AS codigo_vendedor, nome AS nome_vendedor
FROM Vendedores vd
WHERE EXISTS (
    SELECT 1 
    FROM Vendas v 
    WHERE v.id_vendedor = vd.id_vendedor
);

-- Missão 18 — Clientes que NÃO compraram
SELECT nome, cidade, renda
FROM Clientes c
WHERE NOT EXISTS (
    SELECT 1 
    FROM Vendas v 
    WHERE v.id_cliente = c.id_cliente
);

-- ==========================================
-- PARTE 6 — Combinando os conceitos
-- ==========================================

-- Missão 19 — Clientes de alto potencial
SELECT nome AS cliente, cidade, renda
FROM Clientes c
WHERE renda BETWEEN 5000 AND 8000 
  AND cidade IN ('Curitiba', 'Colombo', 'São José dos Pinhais')
  AND EXISTS (
      SELECT 1 
      FROM Vendas v 
      WHERE v.id_cliente = c.id_cliente
  );

-- Missão 20 — Produtos estratégicos
SELECT nome AS produto, preco, estoque
FROM Produtos p
WHERE preco BETWEEN 100 AND 300 
  AND estoque > 20
  AND EXISTS (
      SELECT 1 
      FROM Itens_Venda iv 
      WHERE iv.id_produto = p.id_produto
  );
