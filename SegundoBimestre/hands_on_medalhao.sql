-- =====================================================================
-- HANDS-ON: Engenharia de Dados - Stored Procedures e Arquitetura Medalhão
-- Empresa fictícia: AgroTech Digital | SGBD: MySQL 8.0+
-- Aluno: Ademir Coimbra Jr.
--
-- PRÉ-REQUISITO: executar antes, nesta ordem, os scripts do professor:
--   01_camada_bronze.sql  | 02_camada_silver.sql | 03_camada_gold.sql
-- Este arquivo substitui o 04_procedure_silver_desafio.sql.
-- A camada Bronze NUNCA é alterada: todo tratamento ocorre na carga da Silver.
-- =====================================================================

CREATE DATABASE IF NOT EXISTS db_sp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


-- =====================================================================
-- PARTE 1 - PROCEDURE SILVER: db_sp.sp_carregar_silver()  (Bronze -> Silver)
-- =====================================================================
-- Regras implementadas:
--  * Datas: YYYY-MM-DD, YYYY/MM/DD, YYYY.MM.DD e DD-MM-YYYY -> DATE
--           (qualquer outro formato ou data inexistente, ex.: 31-02, vira NULL)
--  * Valores: "1.200,00" e "399,90" (padrão BR: vírgula decimal) e
--             "150.5" e "75.50" (padrão internacional: ponto decimal)
--             -> DECIMAL(12,2). "NaN" ou texto não numérico = inválido.
--  * E-mail: VALIDO | CORRIGIDO (termina exatamente em @gmail -> + ".com")
--            | INVALIDO (email = NULL). Todos os clientes são preservados.
--  * Vendas: só entram em tb_vendas se cliente existe + valor > 0 + data válida.
--            As demais vão para tb_vendas_rejeitadas com o motivo principal,
--            na ordem: CLIENTE_INEXISTENTE > VALOR_INVALIDO >
--                      VALOR_NAO_POSITIVO > DATA_INVALIDA.
--  * Transação com COMMIT / ROLLBACK; reexecutável (limpa e recarrega).
-- =====================================================================
DROP PROCEDURE IF EXISTS db_sp.sp_carregar_silver;

DELIMITER $$
CREATE PROCEDURE db_sp.sp_carregar_silver()
BEGIN
    -- Tratamento de falhas: desfaz tudo e propaga o erro original.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        DROP TEMPORARY TABLE IF EXISTS tmp_vendas_tratadas;
        RESIGNAL;
    END;

    -- Área de trabalho (tabela temporária não causa COMMIT implícito).
    DROP TEMPORARY TABLE IF EXISTS tmp_vendas_tratadas;
    CREATE TEMPORARY TABLE tmp_vendas_tratadas (
        id_venda        INT PRIMARY KEY,
        id_cliente      INT,
        valor_original  VARCHAR(30),
        data_original   VARCHAR(30),
        produto         VARCHAR(100),
        valor_texto     VARCHAR(40)   NULL,  -- valor normalizado (texto numérico)
        valor_decimal   DECIMAL(12,2) NULL,
        data_convertida DATE          NULL,
        cliente_existe  TINYINT(1)    NOT NULL DEFAULT 0,
        motivo          VARCHAR(60)   NULL
    );

    START TRANSACTION;

    -- ---------------------------------------------------------------
    -- 1) Limpeza controlada (DELETE, e não TRUNCATE, para poder
    --    dar ROLLBACK). Ordem respeita a chave estrangeira.
    -- ---------------------------------------------------------------
    DELETE FROM db_silver.tb_vendas_rejeitadas;
    DELETE FROM db_silver.tb_vendas;
    DELETE FROM db_silver.tb_clientes;

    -- ---------------------------------------------------------------
    -- 2) Clientes: padroniza data e e-mail. Nenhum cliente é descartado.
    -- ---------------------------------------------------------------
    INSERT INTO db_silver.tb_clientes
        (id_cliente, nome, email, status_email, cidade, data_cadastro)
    SELECT
        c.id_cliente,
        c.nome,
        -- e-mail final
        CASE
            WHEN TRIM(c.email) REGEXP '^[^@[:space:]]+@[^@[:space:].]+(\\.[^@[:space:].]+)+$'
                THEN TRIM(c.email)                          -- já válido
            WHEN TRIM(c.email) REGEXP '^[^@[:space:]]+@gmail$'
                THEN CONCAT(TRIM(c.email), '.com')          -- termina exatamente em @gmail
            ELSE NULL                                       -- incompleto e sem regra de correção
        END,
        -- status do e-mail
        CASE
            WHEN TRIM(c.email) REGEXP '^[^@[:space:]]+@[^@[:space:].]+(\\.[^@[:space:].]+)+$'
                THEN 'VALIDO'
            WHEN TRIM(c.email) REGEXP '^[^@[:space:]]+@gmail$'
                THEN 'CORRIGIDO'
            ELSE 'INVALIDO'
        END,
        c.cidade,
        -- data de cadastro -> DATE (NULL se formato desconhecido/data inexistente)
        CASE
            WHEN TRIM(c.data_cadastro) REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
                THEN STR_TO_DATE(TRIM(c.data_cadastro), '%Y-%m-%d')
            WHEN TRIM(c.data_cadastro) REGEXP '^[0-9]{4}/[0-9]{2}/[0-9]{2}$'
                THEN STR_TO_DATE(TRIM(c.data_cadastro), '%Y/%m/%d')
            WHEN TRIM(c.data_cadastro) REGEXP '^[0-9]{4}\\.[0-9]{2}\\.[0-9]{2}$'
                THEN STR_TO_DATE(TRIM(c.data_cadastro), '%Y.%m.%d')
            WHEN TRIM(c.data_cadastro) REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
                THEN STR_TO_DATE(TRIM(c.data_cadastro), '%d-%m-%Y')
            ELSE NULL
        END
    FROM db_bronze.tb_clientes_raw c;

    -- ---------------------------------------------------------------
    -- 3) Vendas: carrega a área de trabalho com os dados brutos.
    -- ---------------------------------------------------------------
    INSERT INTO tmp_vendas_tratadas
        (id_venda, id_cliente, valor_original, data_original, produto, cliente_existe)
    SELECT
        v.id_venda, v.id_cliente, v.valor_venda, v.data_venda, v.produto,
        EXISTS (SELECT 1 FROM db_silver.tb_clientes c WHERE c.id_cliente = v.id_cliente)
    FROM db_bronze.tb_vendas_raw v;

    -- 3a) Normaliza o valor: padrão BR (tem vírgula) remove o ponto de
    --     milhar e troca a vírgula por ponto; sem vírgula, já é decimal
    --     internacional. Só aceita número com até 10 dígitos inteiros.
    UPDATE tmp_vendas_tratadas
    SET valor_texto = CASE
            WHEN TRIM(valor_original) LIKE '%,%'
                THEN REPLACE(REPLACE(TRIM(valor_original), '.', ''), ',', '.')
            ELSE TRIM(valor_original)
        END;

    UPDATE tmp_vendas_tratadas
    SET valor_decimal = CAST(valor_texto AS DECIMAL(12,2))
    WHERE valor_texto REGEXP '^-?[0-9]{1,10}(\\.[0-9]+)?$';   -- 'NaN' e lixo ficam NULL

    -- 3b) Converte a data da venda.
    UPDATE tmp_vendas_tratadas
    SET data_convertida = CASE
            WHEN TRIM(data_original) REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
                THEN STR_TO_DATE(TRIM(data_original), '%Y-%m-%d')
            WHEN TRIM(data_original) REGEXP '^[0-9]{4}/[0-9]{2}/[0-9]{2}$'
                THEN STR_TO_DATE(TRIM(data_original), '%Y/%m/%d')
            WHEN TRIM(data_original) REGEXP '^[0-9]{4}\\.[0-9]{2}\\.[0-9]{2}$'
                THEN STR_TO_DATE(TRIM(data_original), '%Y.%m.%d')
            WHEN TRIM(data_original) REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
                THEN STR_TO_DATE(TRIM(data_original), '%d-%m-%Y')
            ELSE NULL
        END;

    -- 3c) Classifica o motivo principal (primeiro problema na ordem definida).
    UPDATE tmp_vendas_tratadas
    SET motivo = CASE
            WHEN cliente_existe = 0            THEN 'CLIENTE_INEXISTENTE'
            WHEN valor_decimal IS NULL         THEN 'VALOR_INVALIDO'
            WHEN valor_decimal <= 0            THEN 'VALOR_NAO_POSITIVO'
            WHEN data_convertida IS NULL       THEN 'DATA_INVALIDA'
            ELSE NULL                                   -- venda válida
        END;

    -- ---------------------------------------------------------------
    -- 4) Grava vendas válidas e rejeitadas.
    -- ---------------------------------------------------------------
    INSERT INTO db_silver.tb_vendas
        (id_venda, id_cliente, valor_venda, data_venda, produto)
    SELECT id_venda, id_cliente, valor_decimal, data_convertida, produto
    FROM tmp_vendas_tratadas
    WHERE motivo IS NULL;

    INSERT INTO db_silver.tb_vendas_rejeitadas
        (id_venda, id_cliente, valor_venda_original, data_venda_original, produto, motivo)
    SELECT id_venda, id_cliente, valor_original, data_original, produto, motivo
    FROM tmp_vendas_tratadas
    WHERE motivo IS NOT NULL;

    -- ---------------------------------------------------------------
    -- 5) Confirma a carga e remove a área de trabalho.
    -- ---------------------------------------------------------------
    COMMIT;
    DROP TEMPORARY TABLE IF EXISTS tmp_vendas_tratadas;
END $$
DELIMITER ;


-- =====================================================================
-- PARTE 2 - PROCEDURE GOLD: db_sp.sp_carregar_gold()  (Silver -> Gold)
-- =====================================================================
-- * Uma linha por cliente (LEFT JOIN: clientes sem venda válida aparecem com 0).
-- * Indicadores via SUM, COUNT e AVG.
-- * Resultado intermediário na tabela temporária tmp_resumo_vendas,
--   removida ao final.
-- * Transação + handler: se algo falhar, a Gold não fica parcialmente carregada.
-- * Reexecutável: a Gold é recalculada por completo a partir da Silver.
-- =====================================================================
DROP PROCEDURE IF EXISTS db_sp.sp_carregar_gold;

DELIMITER $$
CREATE PROCEDURE db_sp.sp_carregar_gold()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        DROP TEMPORARY TABLE IF EXISTS tmp_resumo_vendas;
        RESIGNAL;
    END;

    -- Garante um começo limpo caso uma execução anterior tenha falhado.
    DROP TEMPORARY TABLE IF EXISTS tmp_resumo_vendas;

    -- Tabela temporária com o resultado intermediário da consolidação.
    CREATE TEMPORARY TABLE tmp_resumo_vendas (
        id_cliente   INT           NOT NULL PRIMARY KEY,
        nome_cliente VARCHAR(100)  NOT NULL,
        total_vendas DECIMAL(14,2) NOT NULL,
        qtd_vendas   INT           NOT NULL,
        ticket_medio DECIMAL(14,2) NOT NULL
    );

    INSERT INTO tmp_resumo_vendas
        (id_cliente, nome_cliente, total_vendas, qtd_vendas, ticket_medio)
    SELECT
        c.id_cliente,
        c.nome,
        COALESCE(SUM(v.valor_venda), 0),
        COUNT(v.id_venda),
        COALESCE(ROUND(AVG(v.valor_venda), 2), 0)
    FROM db_silver.tb_clientes c
    LEFT JOIN db_silver.tb_vendas v
           ON v.id_cliente = c.id_cliente
    GROUP BY c.id_cliente, c.nome;

    -- Atualização atômica da tabela definitiva.
    START TRANSACTION;

    DELETE FROM db_gold.tb_relatorio_vendas;

    INSERT INTO db_gold.tb_relatorio_vendas
        (id_cliente, nome_cliente, total_vendas, qtd_vendas, ticket_medio)
    SELECT id_cliente, nome_cliente, total_vendas, qtd_vendas, ticket_medio
    FROM tmp_resumo_vendas;

    COMMIT;

    DROP TEMPORARY TABLE IF EXISTS tmp_resumo_vendas;
END $$
DELIMITER ;


-- =====================================================================
-- PARTE 3 - EXECUÇÃO E CONSULTAS DE VALIDAÇÃO
-- =====================================================================

-- ---------------------------------------------------------------------
-- TESTE 1 - Processamento da Silver
-- ---------------------------------------------------------------------
CALL db_sp.sp_carregar_silver();

SELECT * FROM db_silver.tb_clientes ORDER BY id_cliente;
SELECT * FROM db_silver.tb_vendas ORDER BY id_venda;
SELECT * FROM db_silver.tb_vendas_rejeitadas ORDER BY id_venda;

-- Resumo da Silver
SELECT status_email, COUNT(*) AS clientes
FROM db_silver.tb_clientes GROUP BY status_email;

SELECT motivo, COUNT(*) AS vendas
FROM db_silver.tb_vendas_rejeitadas GROUP BY motivo ORDER BY motivo;

SELECT COUNT(*) AS vendas_validas, SUM(valor_venda) AS receita_silver
FROM db_silver.tb_vendas;

-- Conferência: válidas + rejeitadas = total da Bronze (nenhuma venda se perde)
SELECT
    (SELECT COUNT(*) FROM db_silver.tb_vendas)            AS validas,
    (SELECT COUNT(*) FROM db_silver.tb_vendas_rejeitadas) AS rejeitadas,
    (SELECT COUNT(*) FROM db_bronze.tb_vendas_raw)        AS total_bronze;

-- ---------------------------------------------------------------------
-- TESTE 2 - Processamento da Gold
-- ---------------------------------------------------------------------
CALL db_sp.sp_carregar_gold();

SELECT * FROM db_gold.tb_relatorio_vendas ORDER BY total_vendas DESC, id_cliente;

-- ---------------------------------------------------------------------
-- TESTE 3 - Reexecução (nenhum registro duplicado)
-- ---------------------------------------------------------------------
CALL db_sp.sp_carregar_silver();
CALL db_sp.sp_carregar_gold();

SELECT
    (SELECT COUNT(*) FROM db_silver.tb_clientes)          AS clientes_silver,
    (SELECT COUNT(*) FROM db_silver.tb_vendas)            AS vendas_silver,
    (SELECT COUNT(*) FROM db_silver.tb_vendas_rejeitadas) AS rejeitadas_silver,
    (SELECT COUNT(*) FROM db_gold.tb_relatorio_vendas)    AS linhas_gold;

-- ---------------------------------------------------------------------
-- TESTE 4 - Conferência dos indicadores
-- ---------------------------------------------------------------------

-- 4.1 Os três clientes com maior faturamento
SELECT id_cliente, nome_cliente, total_vendas, qtd_vendas, ticket_medio
FROM db_gold.tb_relatorio_vendas
ORDER BY total_vendas DESC, id_cliente   -- id_cliente desempata valores iguais
LIMIT 3;

-- 4.2 Cliente com maior ticket médio
SELECT id_cliente, nome_cliente, ticket_medio
FROM db_gold.tb_relatorio_vendas
ORDER BY ticket_medio DESC
LIMIT 1;

-- 4.3 Clientes que não realizaram compras válidas
SELECT id_cliente, nome_cliente
FROM db_gold.tb_relatorio_vendas
WHERE qtd_vendas = 0
ORDER BY id_cliente;

-- 4.4 Faturamento total na Silver
SELECT SUM(valor_venda) AS faturamento_silver
FROM db_silver.tb_vendas;

-- 4.5 Faturamento total na Gold
SELECT SUM(total_vendas) AS faturamento_gold
FROM db_gold.tb_relatorio_vendas;

-- 4.6 Silver x Gold devem ser iguais (diferenca = 0.00)
SELECT
    (SELECT SUM(valor_venda)  FROM db_silver.tb_vendas)             AS receita_silver,
    (SELECT SUM(total_vendas) FROM db_gold.tb_relatorio_vendas)     AS receita_gold,
    (SELECT SUM(valor_venda)  FROM db_silver.tb_vendas)
  - (SELECT SUM(total_vendas) FROM db_gold.tb_relatorio_vendas)     AS diferenca;
