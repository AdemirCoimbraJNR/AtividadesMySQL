-- =====================================================================
-- SQL QUEST - O ATAQUE AO REINO DOS DADOS
-- Script completo: criação do banco, carga inicial e recuperação
-- Compatível com MySQL 5.7+ / 8.x
-- =====================================================================

-- Permite UPDATE/DELETE sem filtro por chave primária (Safe Updates do Workbench)
SET SQL_SAFE_UPDATES = 0;

-- ---------------------------------------------------------------------
-- DDL + carga inicial (arquivo original do desafio)
-- ---------------------------------------------------------------------
DROP DATABASE IF EXISTS sql_quest;
CREATE DATABASE sql_quest CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE sql_quest;

CREATE TABLE jogadores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    classe VARCHAR(50) NOT NULL,
    nivel INT NOT NULL,
    moedas INT NOT NULL DEFAULT 0,
    pontos INT NOT NULL,
    guilda VARCHAR(50),
    bonus INT,
    status_jogador VARCHAR(30) NOT NULL,
    classificacao VARCHAR(30)
);

INSERT INTO jogadores
(nome, classe, nivel, moedas, pontos, guilda, bonus, status_jogador)
VALUES
('Arthas', 'Guerreiro', 18, 950, 7200, 'Dragões', 500, 'ATIVO'),
('Luna', 'Maga', 22, 1500, 9800, 'Fênix', NULL, 'ATIVO'),
('Thorim', 'Guerreiro', 15, 450, 5100, 'Dragões', 300, 'ATIVO'),
('Nyx', 'Assassina', 26, 2100, 12500, 'Sombras', NULL, 'ATIVO'),
('Eldrin', 'Mago', 12, 300, 3900, 'Fênix', 200, 'ATIVO'),
('Kael', 'Arqueiro', 20, 1100, 8300, 'Dragões', NULL, 'ATIVO'),
('Morgana', 'Maga', 30, 3200, 16000, 'Sombras', 1000, 'ATIVO'),
('Ragnar', 'Guerreiro', 8, 150, 1800, 'Dragões', NULL, 'INATIVO'),
('Lyra', 'Arqueira', 17, 700, 6500, 'Fênix', 400, 'ATIVO'),
('Draven', 'Assassino', 25, 1800, 11200, 'Sombras', 700, 'ATIVO'),
('Orion', 'Mago', 6, 80, 900, NULL, NULL, 'INATIVO'),
('Freya', 'Guerreira', 21, 1300, 8900, 'Dragões', 600, 'ATIVO');

-- Conferência do estado inicial
SELECT * FROM jogadores;

-- ---------------------------------------------------------------------
-- ETAPA 1: Reconstruir a classificação (CASE)
-- LENDÁRIO >= 12000 | ELITE >= 8000 | VETERANO >= 5000 | APRENDIZ (demais)
-- ---------------------------------------------------------------------
UPDATE jogadores
SET classificacao = CASE
    WHEN pontos >= 12000 THEN 'LENDÁRIO'
    WHEN pontos >= 8000  THEN 'ELITE'
    WHEN pontos >= 5000  THEN 'VETERANO'
    ELSE 'APRENDIZ'
END;

-- Conferência: nenhum jogador sem classificação
SELECT id, nome, pontos, classificacao FROM jogadores;

-- ---------------------------------------------------------------------
-- ETAPA 2: Bônus NULL passa a ser 0 (COALESCE)
-- ---------------------------------------------------------------------
UPDATE jogadores
SET bonus = COALESCE(bonus, 0);

-- Conferência: deve retornar 0
SELECT COUNT(*) AS bonus_nulos FROM jogadores WHERE bonus IS NULL;

-- ---------------------------------------------------------------------
-- ETAPA 3: +250 moedas para quem está acima da média de pontos (subconsulta)
-- A subconsulta fica dentro de uma tabela derivada, pois o MySQL não permite
-- consultar a própria tabela do UPDATE diretamente (erro 1093).
-- ---------------------------------------------------------------------
UPDATE jogadores
SET moedas = moedas + 250
WHERE pontos > (
    SELECT media
    FROM (SELECT AVG(pontos) AS media FROM jogadores) AS m
);

-- ---------------------------------------------------------------------
-- ETAPA 4: Guerra das Guildas (GROUP BY + HAVING)
-- Guildas com média > 7000 recebem +300 moedas por integrante.
-- Jogadores sem guilda ficam fora da análise.
-- ---------------------------------------------------------------------
UPDATE jogadores
SET moedas = moedas + 300
WHERE guilda IN (
    SELECT guilda
    FROM (
        SELECT guilda
        FROM jogadores
        WHERE guilda IS NOT NULL
        GROUP BY guilda
        HAVING AVG(pontos) > 7000
    ) AS guildas_vencedoras
);

-- ---------------------------------------------------------------------
-- ETAPA 5: Conselho dos Campeões (TOP 3 por pontos: +1 nível)
-- O MySQL não aceita LIMIT dentro de IN (...), então usamos JOIN
-- com uma tabela derivada.
-- ---------------------------------------------------------------------
UPDATE jogadores AS j
JOIN (
    SELECT id
    FROM jogadores
    ORDER BY pontos DESC
    LIMIT 3
) AS top3 ON j.id = top3.id
SET j.nivel = j.nivel + 1;

-- ---------------------------------------------------------------------
-- ETAPA 6: Treinamento emergencial (ATIVO e nível < 18: +2 níveis)
-- ---------------------------------------------------------------------
-- Consulta de conferência (quem será afetado):
SELECT id, nome, nivel, status_jogador
FROM jogadores
WHERE status_jogador = 'ATIVO' AND nivel < 18;

-- Atualização:
UPDATE jogadores
SET nivel = nivel + 2
WHERE status_jogador = 'ATIVO' AND nivel < 18;

-- ---------------------------------------------------------------------
-- ETAPA 7: Espiões de NullMaster (INATIVO e pontos < 2000: remover)
-- ---------------------------------------------------------------------
-- Consulta de conferência (quem será excluído):
SELECT id, nome, pontos, status_jogador
FROM jogadores
WHERE status_jogador = 'INATIVO' AND pontos < 2000;

-- Exclusão:
DELETE FROM jogadores
WHERE status_jogador = 'INATIVO' AND pontos < 2000;

-- ---------------------------------------------------------------------
-- AUDITORIA FINAL
-- ---------------------------------------------------------------------
SELECT
    id,
    nome,
    nivel,
    moedas,
    pontos,
    guilda,
    bonus,
    status_jogador,
    classificacao
FROM jogadores
ORDER BY pontos DESC;

-- Validações finais
SELECT COUNT(*) AS total_jogadores FROM jogadores;                       -- esperado: 10
SELECT COUNT(*) AS bonus_nulos FROM jogadores WHERE bonus IS NULL;       -- esperado: 0
SELECT nome FROM jogadores WHERE classificacao = 'LENDÁRIO';             -- esperado: Morgana, Nyx
SELECT nome, nivel, moedas FROM jogadores WHERE nome = 'Morgana';        -- esperado: 31 e 3750
SELECT nome FROM jogadores WHERE nome IN ('Ragnar', 'Orion');            -- esperado: vazio

SET SQL_SAFE_UPDATES = 1;
