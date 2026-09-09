-- ============================================================
-- EXERCÍCIO: UPDATE, DELETE, GROUP BY e Funções de Agregação
-- Base: db_2_bim / tabela vendas
-- Testado em MariaDB 10.11 (compatível com MySQL 8)
-- ============================================================

USE db_2_bim;

-- ------------------------------------------------------------
-- Questão 1 — Atualização da forma de pagamento
-- As vendas registradas como "Cartao" devem virar "Cartão de Crédito"
-- ------------------------------------------------------------
UPDATE vendas
SET forma_pagamento = 'Cartão de Crédito'
WHERE forma_pagamento = 'Cartao';


-- ------------------------------------------------------------
-- Questão 2 — Atualização do status da venda
-- Vendas "Pendente" realizadas antes de 2025-01-01 viram "Cancelada"
-- ------------------------------------------------------------
UPDATE vendas
SET status_venda = 'Cancelada'
WHERE status_venda = 'Pendente'
  AND data_venda < '2025-01-01';


-- ------------------------------------------------------------
-- Questão 3 — Reajuste do valor unitário
-- Produtos da categoria "Informática" recebem reajuste de 10%
-- ------------------------------------------------------------
UPDATE vendas
SET valor_unitario = valor_unitario * 1.10
WHERE categoria = 'Informática';


-- ------------------------------------------------------------
-- Questão 4 — Correção do valor total
-- Recalcula o valor_total da venda de código 10 (quantidade * valor_unitario)
-- ------------------------------------------------------------
UPDATE vendas
SET valor_total = quantidade * valor_unitario
WHERE id_venda = 10;


-- ------------------------------------------------------------
-- Questão 5 — Exclusão de vendas canceladas
-- Remove vendas "Cancelada" realizadas antes de 2024-01-01
-- ------------------------------------------------------------
DELETE FROM vendas
WHERE status_venda = 'Cancelada'
  AND data_venda < '2024-01-01';


-- ------------------------------------------------------------
-- Questão 6 — Exclusão de registros inválidos
-- Remove vendas com quantidade igual ou menor que zero
-- ------------------------------------------------------------
DELETE FROM vendas
WHERE quantidade <= 0;


-- ------------------------------------------------------------
-- Questão 7 — Quantidade de vendas por categoria
-- ------------------------------------------------------------
SELECT
    categoria,
    COUNT(*) AS qtd_vendas
FROM vendas
GROUP BY categoria
ORDER BY qtd_vendas DESC;


-- ------------------------------------------------------------
-- Questão 8 — Resumo financeiro por categoria
-- ------------------------------------------------------------
SELECT
    categoria,
    SUM(valor_total) AS valor_total_vendido,
    AVG(valor_total) AS valor_medio,
    MIN(valor_total) AS menor_valor,
    MAX(valor_total) AS maior_valor
FROM vendas
GROUP BY categoria
ORDER BY valor_total_vendido DESC;


-- ------------------------------------------------------------
-- Questão 9 — Total vendido por vendedor
-- ------------------------------------------------------------
SELECT
    vendedor,
    COUNT(*) AS qtd_vendas,
    SUM(quantidade) AS qtd_produtos_vendidos,
    SUM(valor_total) AS valor_total_vendido
FROM vendas
GROUP BY vendedor
ORDER BY valor_total_vendido DESC;


-- ------------------------------------------------------------
-- Questão 10 — Relatório de vendas por estado
-- Apenas estados com faturamento total acima de R$ 5.000,00
-- ------------------------------------------------------------
SELECT
    estado_cliente,
    COUNT(*) AS qtd_vendas,
    SUM(quantidade) AS qtd_produtos_vendidos,
    SUM(valor_total) AS faturamento_total,
    AVG(valor_total) AS ticket_medio
FROM vendas
GROUP BY estado_cliente
HAVING SUM(valor_total) > 5000.00
ORDER BY faturamento_total DESC;
