-- Challenge Night II – JOINs Avançados (Dashboard Executivo Pt 2)
-- Equipe: Ademir, Christian, Gustavo, Pedro e você.
-- Consultas SQL para os 15 Exercícios

-- ==========================================
-- Exercício 01 – Clientes e Compras
-- ==========================================
SELECT 
    c.nome AS nome_cliente, 
    c.cidade, 
    COUNT(DISTINCT v.id_venda) AS quantidade_compras, 
    COALESCE(SUM(iv.quantidade * iv.preco_unitario), 0) AS valor_total_comprado
FROM Clientes c 
LEFT JOIN Vendas v ON c.id_cliente = v.id_cliente 
LEFT JOIN Itens_Venda iv ON v.id_venda = iv.id_venda
GROUP BY c.nome, c.cidade;

-- ==========================================
-- Exercício 02 – Produtos Comercializados
-- ==========================================
SELECT 
    p.nome AS nome_produto, 
    p.categoria, 
    COALESCE(SUM(iv.quantidade), 0) AS quantidade_vendida, 
    COALESCE(SUM(iv.quantidade * iv.preco_unitario), 0) AS faturamento
FROM Produtos p 
LEFT JOIN Itens_Venda iv ON p.id_produto = iv.id_produto
GROUP BY p.nome, p.categoria;

-- ==========================================
-- Exercício 03 – Desempenho dos Vendedores
-- ==========================================
SELECT 
    vd.nome AS nome_vendedor, 
    vd.setor, 
    COUNT(DISTINCT v.id_venda) AS quantidade_vendas, 
    COALESCE(SUM(iv.quantidade * iv.preco_unitario), 0) AS faturamento
FROM Vendedores vd 
LEFT JOIN Vendas v ON vd.id_vendedor = v.id_vendedor 
LEFT JOIN Itens_Venda iv ON v.id_venda = iv.id_venda
GROUP BY vd.nome, vd.setor;

-- ==========================================
-- Exercício 04 – Auditoria de Clientes
-- ==========================================
WITH ClientesCompradores AS (
    SELECT DISTINCT id_cliente FROM Vendas
)
SELECT c.nome AS cliente_sem_compras
FROM Clientes c 
LEFT JOIN ClientesCompradores cc ON c.id_cliente = cc.id_cliente 
WHERE cc.id_cliente IS NULL;

-- ==========================================
-- Exercício 05 – Auditoria de Produtos (Uso de RIGHT JOIN)
-- ==========================================
WITH ProdutosVendidos AS (
    SELECT DISTINCT id_produto FROM Itens_Venda
)
SELECT p.nome AS produto_nao_vendido
FROM ProdutosVendidos pv 
RIGHT JOIN Produtos p ON pv.id_produto = p.id_produto 
WHERE pv.id_produto IS NULL;

-- ==========================================
-- Exercício 06 – Ranking Comercial (Uso de CASE)
-- ==========================================
WITH FaturamentoVendedor AS (
    SELECT 
        vd.id_vendedor, 
        vd.nome, 
        COALESCE(SUM(iv.quantidade * iv.preco_unitario), 0) AS total_faturado
    FROM Vendedores vd 
    LEFT JOIN Vendas v ON vd.id_vendedor = v.id_vendedor 
    LEFT JOIN Itens_Venda iv ON v.id_venda = iv.id_venda
    GROUP BY vd.id_vendedor, vd.nome
)
SELECT 
    nome, 
    total_faturado,
    CASE
        WHEN total_faturado > 50000 THEN 'Excelente'
        WHEN total_faturado > 10000 THEN 'Bom'
        WHEN total_faturado > 0 THEN 'Regular'
        ELSE 'Sem vendas'
    END AS classificacao
FROM FaturamentoVendedor;

-- ==========================================
-- Exercício 07 – Produtos acima da Média (Uso de HAVING)
-- ==========================================
SELECT 
    p.nome AS produto, 
    SUM(iv.quantidade * iv.preco_unitario) AS faturamento
FROM Produtos p 
INNER JOIN Itens_Venda iv ON p.id_produto = iv.id_produto
GROUP BY p.nome
HAVING SUM(iv.quantidade * iv.preco_unitario) > (
    SELECT AVG(fat_total) FROM (
        SELECT SUM(quantidade * preco_unitario) AS fat_total 
        FROM Itens_Venda 
        GROUP BY id_produto
    ) AS SubqueryMedia
);

-- ==========================================
-- Exercício 08 – Categorias Estratégicas
-- ==========================================
SELECT 
    p.categoria,
    COUNT(DISTINCT p.id_produto) AS quantidade_produtos,
    COUNT(DISTINCT iv.id_produto) AS produtos_vendidos,
    COUNT(DISTINCT p.id_produto) - COUNT(DISTINCT iv.id_produto) AS produtos_nunca_vendidos,
    COALESCE(SUM(iv.quantidade * iv.preco_unitario), 0) AS faturamento
FROM Produtos p 
LEFT JOIN Itens_Venda iv ON p.id_produto = iv.id_produto
GROUP BY p.categoria;

-- ==========================================
-- Exercício 09 – Dashboard de Clientes
-- ==========================================
WITH DadosCliente AS (
    SELECT 
        c.id_cliente, 
        c.nome, 
        COUNT(DISTINCT v.id_venda) AS qtd_compras,
        COALESCE(SUM(iv.quantidade * iv.preco_unitario), 0) AS valor_total
    FROM Clientes c 
    LEFT JOIN Vendas v ON c.id_cliente = v.id_cliente 
    LEFT JOIN Itens_Venda iv ON v.id_venda = iv.id_venda
    GROUP BY c.id_cliente, c.nome
)
SELECT 
    nome, 
    qtd_compras, 
    valor_total,
    CASE WHEN qtd_compras > 0 THEN valor_total / qtd_compras ELSE 0 END AS ticket_medio,
    CASE 
        WHEN valor_total > 10000 THEN 'VIP' 
        WHEN valor_total > 0 THEN 'Ativo' 
        ELSE 'Inativo' 
    END AS classificacao
FROM DadosCliente;

-- ==========================================
-- Exercício 10 – Dashboard de Produtos
-- ==========================================
WITH TotalVendas AS (
    SELECT SUM(quantidade * preco_unitario) AS total_geral FROM Itens_Venda
)
SELECT 
    p.nome, 
    COALESCE(SUM(iv.quantidade), 0) AS qtd_vendida, 
    COALESCE(SUM(iv.quantidade * iv.preco_unitario), 0) AS valor_vendido,
    COALESCE(ROUND((SUM(iv.quantidade * iv.preco_unitario) / MAX(tv.total_geral)) * 100, 2), 0) AS percentual_participacao
FROM Produtos p 
LEFT JOIN Itens_Venda iv ON p.id_produto = iv.id_produto 
CROSS JOIN TotalVendas tv
GROUP BY p.nome;

-- ==========================================
-- Exercício 11 – Auditoria Completa
-- ==========================================
-- Explicação do JOIN: Utilizei o LEFT JOIN a partir da tabela Produtos para a tabela Itens_Venda. 
-- Isso garante que TODOS os produtos cadastrados no sistema sejam retornados na consulta. 
-- Caso o produto não possua correspondência em Itens_Venda (ou seja, nunca foi vendido), 
-- o JOIN retornará valores NULL, permitindo identificá-lo perfeitamente através de uma condicional.
SELECT 
    p.nome AS produto,
    CASE 
        WHEN iv.id_produto IS NOT NULL THEN 'Vendido' 
        ELSE 'Nunca Vendido' 
    END AS status_venda
FROM Produtos p 
LEFT JOIN Itens_Venda iv ON p.id_produto = iv.id_produto
GROUP BY p.nome, iv.id_produto;

-- ==========================================
-- Exercício 12 – Integração de Sistemas (Uso de FULL OUTER JOIN)
-- ==========================================
SELECT 
    COALESCE(ct.nome, cea.nome) AS cliente,
    CASE 
        WHEN cea.id_cliente IS NULL THEN 'Apenas TechVendas'
        WHEN ct.id_cliente IS NULL THEN 'Apenas Empresa Adquirida'
        ELSE 'Em Ambas' 
    END AS origem_cadastro
FROM clientes_techvendas ct 
FULL OUTER JOIN clientes_empresa_adquirida cea ON ct.id_cliente = cea.id_cliente;

-- ==========================================
-- Exercício 13 – Auditoria de Cadastros
-- ==========================================
WITH BaseUnificada AS (
    SELECT 
        ct.id_cliente AS id_tech, 
        cea.id_cliente AS id_empresa
    FROM clientes_techvendas ct 
    FULL OUTER JOIN clientes_empresa_adquirida cea ON ct.id_cliente = cea.id_cliente
)
SELECT 
    SUM(CASE WHEN id_empresa IS NULL THEN 1 ELSE 0 END) AS apenas_base_antiga,
    SUM(CASE WHEN id_tech IS NULL THEN 1 ELSE 0 END) AS apenas_base_nova,
    SUM(CASE WHEN id_tech IS NOT NULL AND id_empresa IS NOT NULL THEN 1 ELSE 0 END) AS presentes_em_ambas
FROM BaseUnificada;

-- ==========================================
-- Exercício 14 – Dashboard Executivo
-- ==========================================
WITH VendasBase AS (
    SELECT 
        v.id_vendedor, v.id_cliente, v.id_venda, p.categoria, p.nome AS produto, 
        (iv.quantidade * iv.preco_unitario) AS valor
    FROM Vendas v 
    JOIN Itens_Venda iv ON v.id_venda = iv.id_venda 
    JOIN Produtos p ON iv.id_produto = p.id_produto
),
AgregadoVendedor AS (
    SELECT 
        id_vendedor, 
        COUNT(DISTINCT id_cliente) AS qtd_clientes, 
        COUNT(DISTINCT id_venda) AS qtd_vendas, 
        SUM(valor)/COUNT(DISTINCT id_venda) AS ticket_medio
    FROM VendasBase GROUP BY id_vendedor
),
RankCliente AS (
    SELECT id_vendedor, id_cliente, ROW_NUMBER() OVER(PARTITION BY id_vendedor ORDER BY SUM(valor) DESC) as rn
    FROM VendasBase GROUP BY id_vendedor, id_cliente
),
RankCat AS (
    SELECT id_vendedor, categoria, ROW_NUMBER() OVER(PARTITION BY id_vendedor ORDER BY SUM(valor) DESC) as rn
    FROM VendasBase GROUP BY id_vendedor, categoria
),
RankProd AS (
    SELECT id_vendedor, produto, ROW_NUMBER() OVER(PARTITION BY id_vendedor ORDER BY SUM(valor) DESC) as rn
    FROM VendasBase GROUP BY id_vendedor, produto
)
SELECT 
    vd.nome AS vendedor, 
    av.qtd_clientes, 
    av.qtd_vendas, 
    av.ticket_medio,
    c.nome AS melhor_cliente, 
    rc2.categoria AS melhor_categoria, 
    rp.produto AS melhor_produto
FROM Vendedores vd
LEFT JOIN AgregadoVendedor av ON vd.id_vendedor = av.id_vendedor
LEFT JOIN RankCliente rc ON vd.id_vendedor = rc.id_vendedor AND rc.rn = 1
LEFT JOIN Clientes c ON rc.id_cliente = c.id_cliente
LEFT JOIN RankCat rc2 ON vd.id_vendedor = rc2.id_vendedor AND rc2.rn = 1
LEFT JOIN RankProd rp ON vd.id_vendedor = rp.id_vendedor AND rp.rn = 1;

-- ==========================================
-- Exercício 15 – Painel de Auditoria Geral
-- ==========================================
SELECT
    (SELECT COUNT(*) FROM Clientes) AS clientes_cadastrados,
    (SELECT COUNT(DISTINCT id_cliente) FROM Vendas) AS clientes_ativos,
    (SELECT COUNT(*) FROM Clientes WHERE id_cliente NOT IN (SELECT id_cliente FROM Vendas)) AS clientes_sem_compras,
    (SELECT COUNT(*) FROM Produtos) AS produtos_cadastrados,
    (SELECT COUNT(DISTINCT id_produto) FROM Itens_Venda) AS produtos_vendidos,
    (SELECT COUNT(*) FROM Produtos WHERE id_produto NOT IN (SELECT id_produto FROM Itens_Venda)) AS produtos_sem_vendas,
    (SELECT COUNT(*) FROM Vendedores) AS vendedores_cadastrados,
    (SELECT COUNT(DISTINCT id_vendedor) FROM Vendas) AS vendedores_ativos,
    (SELECT COUNT(*) FROM Vendedores WHERE id_vendedor NOT IN (SELECT id_vendedor FROM Vendas)) AS vendedores_sem_vendas;
