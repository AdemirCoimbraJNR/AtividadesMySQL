-- Challenge Night – Dashboard Executivo da TechVendas S/A
-- Equipe: Ademir, Christian, Gustavo, Pedro e você.
-- Consultas SQL para os 15 KPIs

-- ==========================================
-- KPI 1: Produtos "Encalhados" (Estoque Parado)
-- ==========================================
SELECT 
    p.nome AS produto_encalhado
FROM Produtos p
LEFT JOIN Itens_Venda iv ON p.id_produto = iv.id_produto
WHERE iv.id_produto IS NULL;

-- ==========================================
-- KPI 2: Alcance e Eficiência dos Vendedores
-- ==========================================
WITH DesempenhoVendas AS (
    SELECT 
        v.id_vendedor,
        COUNT(DISTINCT v.id_cliente) AS total_clientes_distintos,
        SUM(i.quantidade * i.preco_unitario) AS faturamento_total
    FROM Vendas v
    INNER JOIN Itens_Venda i ON v.id_venda = i.id_venda
    GROUP BY v.id_vendedor
)
SELECT 
    vend.nome AS vendedor,
    d.total_clientes_distintos,
    d.faturamento_total
FROM Vendedores vend
INNER JOIN DesempenhoVendas d ON vend.id_vendedor = d.id_vendedor
ORDER BY d.faturamento_total DESC;

-- ==========================================
-- KPI 3: Desempenho Diário de Faturamento (Picos e Vales)
-- ==========================================
WITH FaturamentoDiario AS (
    SELECT 
        v.data_venda,
        SUM(i.quantidade * i.preco_unitario) AS total_dia
    FROM Vendas v
    INNER JOIN Itens_Venda i ON v.id_venda = i.id_venda
    GROUP BY v.data_venda
)
SELECT 
    MAX(total_dia) AS melhor_dia_faturamento,
    MIN(total_dia) AS pior_dia_faturamento,
    AVG(total_dia) AS media_diaria_faturamento
FROM FaturamentoDiario;

-- ==========================================
-- KPI 4: Taxa de Retenção (Clientes Recorrentes)
-- ==========================================
WITH ComprasPorCliente AS (
    SELECT 
        id_cliente,
        COUNT(id_venda) AS total_pedidos
    FROM Vendas
    GROUP BY id_cliente
)
SELECT 
    c.nome AS cliente,
    cp.total_pedidos
FROM Clientes c
INNER JOIN ComprasPorCliente cp ON c.id_cliente = cp.id_cliente
WHERE cp.total_pedidos > 1
ORDER BY cp.total_pedidos DESC;

-- ==========================================
-- KPI 5: Vendedores Ociosos (Sem Histórico de Venda)
-- ==========================================
SELECT 
    v.nome AS vendedor_sem_venda,
    v.data_contratacao
FROM Vendedores v
LEFT JOIN Vendas ven ON v.id_vendedor = ven.id_vendedor
WHERE ven.id_venda IS NULL;

-- ==========================================
-- KPI 6: Desempenho de Faturamento por Categoria
-- ==========================================
SELECT 
    p.categoria,
    SUM(iv.quantidade * iv.preco_unitario) AS faturamento_categoria
FROM Produtos p
INNER JOIN Itens_Venda iv ON p.id_produto = iv.id_produto
GROUP BY p.categoria
ORDER BY faturamento_categoria DESC;

-- ==========================================
-- KPI 7: Clientes Cadastrados sem Compras (Leads Frios)
-- ==========================================
SELECT 
    c.nome AS cliente_inativo,
    c.email
FROM Clientes c
LEFT JOIN Vendas v ON c.id_cliente = v.id_cliente
WHERE v.id_venda IS NULL;

-- ==========================================
-- KPI 8: Valor Médio Gasto por Cliente (LTV Básico)
-- ==========================================
WITH GastoPorCliente AS (
    SELECT 
        v.id_cliente,
        SUM(iv.quantidade * iv.preco_unitario) AS total_gasto
    FROM Vendas v
    INNER JOIN Itens_Venda iv ON v.id_venda = iv.id_venda
    GROUP BY v.id_cliente
)
SELECT 
    AVG(total_gasto) AS ticket_medio_por_cliente
FROM GastoPorCliente;

-- ==========================================
-- KPI 9: Produtos Mais Populares (Volume de Saída)
-- ==========================================
SELECT 
    p.nome AS produto,
    SUM(iv.quantidade) AS total_unidades_vendidas
FROM Produtos p
INNER JOIN Itens_Venda iv ON p.id_produto = iv.id_produto
GROUP BY p.nome
ORDER BY total_unidades_vendidas DESC;

-- ==========================================
-- KPI 10: Ranking Completo de Clientes (Tratando Nulos com COALESCE)
-- ==========================================
WITH FaturamentoClientes AS (
    SELECT 
        v.id_cliente,
        SUM(iv.quantidade * iv.preco_unitario) AS faturamento
    FROM Vendas v
    INNER JOIN Itens_Venda iv ON v.id_venda = iv.id_venda
    GROUP BY v.id_cliente
)
SELECT 
    c.nome AS cliente,
    COALESCE(fc.faturamento, 0) AS faturamento_total
FROM Clientes c
LEFT JOIN FaturamentoClientes fc ON c.id_cliente = fc.id_cliente
ORDER BY faturamento_total DESC;

-- ==========================================
-- KPI 11: UPT (Units Per Transaction / Unidades por Venda)
-- ==========================================
WITH UnidadesPorVenda AS (
    SELECT 
        id_venda,
        SUM(quantidade) AS total_unidades
    FROM Itens_Venda
    GROUP BY id_venda
)
SELECT 
    AVG(total_unidades) AS media_unidades_por_pedido
FROM UnidadesPorVenda;

-- ==========================================
-- KPI 12: Taxa de Cross-Selling (Mix de Produtos por Pedido)
-- ==========================================
WITH ProdutosPorVenda AS (
    SELECT 
        id_venda,
        COUNT(DISTINCT id_produto) AS mix_produtos
    FROM Itens_Venda
    GROUP BY id_venda
)
SELECT 
    AVG(mix_produtos) AS media_produtos_diferentes_por_venda
FROM ProdutosPorVenda;

-- ==========================================
-- KPI 13: Ticket Médio por Vendedor (Qualidade da Venda)
-- ==========================================
WITH VendasTotais AS (
    SELECT 
        v.id_vendedor, 
        v.id_venda, 
        SUM(iv.quantidade * iv.preco_unitario) AS valor_venda
    FROM Vendas v
    INNER JOIN Itens_Venda iv ON v.id_venda = iv.id_venda
    GROUP BY v.id_vendedor, v.id_venda
)
SELECT 
    vend.nome AS vendedor, 
    AVG(vt.valor_venda) AS ticket_medio_vendedor
FROM VendasTotais vt
INNER JOIN Vendedores vend ON vt.id_vendedor = vend.id_vendedor
GROUP BY vend.nome
ORDER BY ticket_medio_vendedor DESC;

-- ==========================================
-- KPI 14: Identificação de Outliers (Melhor e Pior Venda Histórica)
-- ==========================================
WITH TotalPorVenda AS (
    SELECT 
        id_venda, 
        SUM(quantidade * preco_unitario) AS valor_venda
    FROM Itens_Venda
    GROUP BY id_venda
)
SELECT 
    MAX(valor_venda) AS maior_pedido_historico, 
    MIN(valor_venda) AS menor_pedido_historico
FROM TotalPorVenda;

-- ==========================================
-- KPI 15: Recência de Vendas (Vendedores "Esfriando")
-- ==========================================
SELECT 
    vend.nome AS vendedor, 
    MAX(v.data_venda) AS data_ultima_venda
FROM Vendedores vend
LEFT JOIN Vendas v ON vend.id_vendedor = v.id_vendedor
GROUP BY vend.nome
ORDER BY data_ultima_venda ASC;
