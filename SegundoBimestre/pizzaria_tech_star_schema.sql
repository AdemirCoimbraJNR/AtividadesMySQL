-- =====================================================================
-- BANCO DE DADOS II | PIZZARIA TECH | STAR SCHEMA (MODELO ESTRELA)
-- SGBD: MySQL 8.0 | Aluno: Ademir Coimbra Jr.
--
-- Conteúdo deste arquivo:
--   Missão 01 - DDL das 5 tabelas (PKs, FKs, ON DELETE RESTRICT / ON UPDATE CASCADE)
--   Missão 02 - Conferência do carregamento (os INSERTs são os do arquivo do professor)
--   Missão 03 - Pizzas mais vendidas por filial
--   Missão 04 - Faturamento por dia da semana
--   Missão 05 - Desempenho dos vendedores
--   Missão 06 - Ticket médio por cidade
-- A análise gerencial (Missão 07) está no PDF entregue junto com este arquivo.
-- =====================================================================

CREATE DATABASE IF NOT EXISTS bd_pizzaria_tech
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bd_pizzaria_tech;

-- =====================================================================
-- MISSÃO 01 - CRIANDO AS TABELAS
-- Ordem: primeiro as dimensões, depois a fato (a fato depende das dimensões).
-- Os DROP abaixo (fato primeiro) permitem reexecutar o script sem erro.
-- =====================================================================
DROP TABLE IF EXISTS fact_venda;
DROP TABLE IF EXISTS dim_cliente;
DROP TABLE IF EXISTS dim_produto;
DROP TABLE IF EXISTS dim_vendedor;
DROP TABLE IF EXISTS dim_tempo;

-- Dimensão Cliente: quem comprou
CREATE TABLE dim_cliente (
    id_cliente   INT          NOT NULL AUTO_INCREMENT,
    nome_cliente VARCHAR(100) NOT NULL,
    cidade       VARCHAR(100) NOT NULL,
    estado       VARCHAR(2)   NOT NULL,
    PRIMARY KEY (id_cliente)
) ENGINE=InnoDB;

-- Dimensão Produto: o que foi vendido
CREATE TABLE dim_produto (
    id_produto     INT           NOT NULL AUTO_INCREMENT,
    nome_produto   VARCHAR(100)  NOT NULL,
    categoria      VARCHAR(50)   NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_produto)
) ENGINE=InnoDB;

-- Dimensão Vendedor: quem vendeu (turno e filial)
CREATE TABLE dim_vendedor (
    id_vendedor   INT          NOT NULL AUTO_INCREMENT,
    nome_vendedor VARCHAR(100) NOT NULL,
    turno         VARCHAR(20)  NOT NULL,
    filial        VARCHAR(50)  NOT NULL,
    PRIMARY KEY (id_vendedor)
) ENGINE=InnoDB;

-- Dimensão Tempo: quando vendeu
CREATE TABLE dim_tempo (
    id_tempo    INT         NOT NULL AUTO_INCREMENT,
    data_venda  DATE        NOT NULL,
    dia         INT         NOT NULL,
    mes         INT         NOT NULL,
    nome_mes    VARCHAR(20) NOT NULL,
    ano         INT         NOT NULL,
    dia_semana  VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_tempo)
) ENGINE=InnoDB;

-- Tabela Fato: cada registro representa um item vendido.
-- Guarda as 4 chaves estrangeiras (contexto) e as medidas (quantidade e valor_total).
CREATE TABLE fact_venda (
    id_venda    INT           NOT NULL AUTO_INCREMENT,
    id_cliente  INT           NOT NULL,
    id_produto  INT           NOT NULL,
    id_vendedor INT           NOT NULL,
    id_tempo    INT           NOT NULL,
    quantidade  INT           NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_venda),
    CONSTRAINT fk_fact_cliente FOREIGN KEY (id_cliente)
        REFERENCES dim_cliente(id_cliente)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_fact_produto FOREIGN KEY (id_produto)
        REFERENCES dim_produto(id_produto)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_fact_vendedor FOREIGN KEY (id_vendedor)
        REFERENCES dim_vendedor(id_vendedor)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_fact_tempo FOREIGN KEY (id_tempo)
        REFERENCES dim_tempo(id_tempo)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;


-- =====================================================================
-- MISSÃO 02 - POPULANDO O DATA WAREHOUSE
-- Execute AGORA os INSERTs do arquivo do professor
-- (pizzaria_tech_star_schema_ddl_insert.sql), apenas a parte dos INSERT:
-- primeiro as 4 dimensões e por último a fact_venda.
-- (Não rode o DROP DATABASE / CREATE TABLE desse arquivo: as tabelas já existem.)
-- Depois, confira o carregamento com as consultas abaixo.
-- =====================================================================

-- Esperado: dim_cliente 50 | dim_produto 51 | dim_vendedor 50 | dim_tempo 50 | fact_venda 50
SELECT 'dim_cliente' AS tabela, COUNT(*) AS registros FROM dim_cliente
UNION ALL SELECT 'dim_produto',  COUNT(*) FROM dim_produto
UNION ALL SELECT 'dim_vendedor', COUNT(*) FROM dim_vendedor
UNION ALL SELECT 'dim_tempo',    COUNT(*) FROM dim_tempo
UNION ALL SELECT 'fact_venda',   COUNT(*) FROM fact_venda;

-- Teste de integridade: deve retornar ZERO linhas (nenhuma venda "órfã").
SELECT f.id_venda
FROM fact_venda f
LEFT JOIN dim_cliente  c ON c.id_cliente  = f.id_cliente
LEFT JOIN dim_produto  p ON p.id_produto  = f.id_produto
LEFT JOIN dim_vendedor v ON v.id_vendedor = f.id_vendedor
LEFT JOIN dim_tempo    t ON t.id_tempo    = f.id_tempo
WHERE c.id_cliente IS NULL OR p.id_produto IS NULL
   OR v.id_vendedor IS NULL OR t.id_tempo IS NULL;


-- =====================================================================
-- MISSÃO 03 - QUAIS PIZZAS MAIS VENDEM EM CADA FILIAL?
-- Mostra: filial, pizza e total de unidades vendidas.
-- Fato -> dim_vendedor (filial) e fato -> dim_produto (nome da pizza).
-- Ordem: por filial e, dentro dela, da maior para a menor quantidade
-- (o nome da pizza só desempata quantidades iguais).
-- =====================================================================
SELECT
    v.filial                AS filial,
    p.nome_produto          AS pizza,
    SUM(f.quantidade)       AS unidades_vendidas
FROM fact_venda f
INNER JOIN dim_vendedor v ON v.id_vendedor = f.id_vendedor
INNER JOIN dim_produto  p ON p.id_produto  = f.id_produto
GROUP BY v.filial, p.id_produto, p.nome_produto
ORDER BY v.filial, unidades_vendidas DESC, p.nome_produto;


-- =====================================================================
-- MISSÃO 04 - QUAIS DIAS DA SEMANA APRESENTAM MAIOR FATURAMENTO?
-- Mostra: dia da semana, unidades vendidas e faturamento total.
-- Fato -> dim_tempo (dia_semana). Ordenado do maior para o menor faturamento.
-- =====================================================================
SELECT
    t.dia_semana            AS dia_da_semana,
    SUM(f.quantidade)       AS unidades_vendidas,
    SUM(f.valor_total)      AS faturamento_total
FROM fact_venda f
INNER JOIN dim_tempo t ON t.id_tempo = f.id_tempo
GROUP BY t.dia_semana
ORDER BY faturamento_total DESC;


-- =====================================================================
-- MISSÃO 05 - QUAL VENDEDOR APRESENTA O MELHOR DESEMPENHO?
-- Mostra: vendedor, filial, turno, unidades vendidas e faturamento total.
-- Fato -> dim_vendedor. Agrupa pelo id para não misturar vendedores
-- com nomes iguais. Ordenado pelo faturamento (maior -> menor).
-- =====================================================================
SELECT
    v.nome_vendedor         AS vendedor,
    v.filial                AS filial,
    v.turno                 AS turno,
    SUM(f.quantidade)       AS unidades_vendidas,
    SUM(f.valor_total)      AS faturamento_total
FROM fact_venda f
INNER JOIN dim_vendedor v ON v.id_vendedor = f.id_vendedor
GROUP BY v.id_vendedor, v.nome_vendedor, v.filial, v.turno
ORDER BY faturamento_total DESC, v.nome_vendedor;


-- =====================================================================
-- MISSÃO 06 - COMO O TICKET MÉDIO VARIA ENTRE CIDADES?
-- Mostra: cidade do cliente, quantidade de registros de venda,
-- faturamento total e ticket médio.
-- Regra do enunciado: cada registro de fact_venda é uma unidade de análise,
-- então ticket médio = faturamento total / quantidade de registros (AVG).
-- Fato -> dim_cliente. Ordenado do maior para o menor ticket médio.
-- Obs.: a cidade pertence a um estado; no cadastro não há cidades homônimas
-- em estados diferentes, por isso agrupar pela cidade é suficiente.
-- =====================================================================
SELECT
    c.cidade                        AS cidade,
    COUNT(*)                        AS registros_de_venda,
    SUM(f.valor_total)              AS faturamento_total,
    ROUND(AVG(f.valor_total), 2)    AS ticket_medio
FROM fact_venda f
INNER JOIN dim_cliente c ON c.id_cliente = f.id_cliente
GROUP BY c.cidade
ORDER BY ticket_medio DESC, c.cidade;
