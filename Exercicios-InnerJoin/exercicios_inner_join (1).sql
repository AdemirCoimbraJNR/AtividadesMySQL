-- ============================================================
-- BANCO DE DADOS II - LISTA DE FIXAÇÃO: INNER JOIN
-- Cenário: TechVendas S/A
-- Compatibilidade: MySQL 8+, PostgreSQL 12+ e SQLite 3+
--
-- Conteúdo:
--   1. Criação das 5 tabelas
--   2. 50 registros em cada tabela
--   3. Índices para as chaves de relacionamento
--   4. 15 exercícios de fixação utilizando INNER JOIN
--
-- Observação didática:
-- Alguns clientes, vendedores e produtos não possuem correspondência
-- nas tabelas transacionais. Isso permite demonstrar que o INNER JOIN
-- retorna somente registros correspondentes.
-- Cada venda possui exatamente um item para simplificar as agregações.
-- ============================================================

DROP TABLE IF EXISTS itens_venda;
DROP TABLE IF EXISTS vendas;
DROP TABLE IF EXISTS produtos;
DROP TABLE IF EXISTS vendedores;
DROP TABLE IF EXISTS clientes;

CREATE TABLE clientes (
    id_cliente      INTEGER       PRIMARY KEY,
    nome_cliente    VARCHAR(100)  NOT NULL,
    cidade          VARCHAR(80)   NOT NULL,
    estado          CHAR(2)       NOT NULL
);

CREATE TABLE vendedores (
    id_vendedor     INTEGER       PRIMARY KEY,
    nome_vendedor   VARCHAR(100)  NOT NULL,
    setor           VARCHAR(50)   NOT NULL
);

CREATE TABLE produtos (
    id_produto      INTEGER        PRIMARY KEY,
    nome_produto    VARCHAR(120)   NOT NULL,
    categoria       VARCHAR(60)    NOT NULL,
    marca           VARCHAR(60)    NOT NULL,
    preco            DECIMAL(10,2) NOT NULL
);

CREATE TABLE vendas (
    id_venda          INTEGER        PRIMARY KEY,
    data_venda        DATE           NOT NULL,
    id_cliente        INTEGER        NOT NULL,
    id_vendedor       INTEGER        NOT NULL,
    forma_pagamento   VARCHAR(40)    NOT NULL,
    status            VARCHAR(20)    NOT NULL,
    valor_total       DECIMAL(10,2)  NOT NULL,
    CONSTRAINT fk_vendas_clientes
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_vendas_vendedores
        FOREIGN KEY (id_vendedor) REFERENCES vendedores(id_vendedor)
);

CREATE TABLE itens_venda (
    id_item          INTEGER        PRIMARY KEY,
    id_venda         INTEGER        NOT NULL,
    id_produto       INTEGER        NOT NULL,
    quantidade       INTEGER        NOT NULL,
    valor_unitario   DECIMAL(10,2)  NOT NULL,
    desconto         DECIMAL(5,2)   NOT NULL DEFAULT 0,
    CONSTRAINT fk_itens_venda
        FOREIGN KEY (id_venda) REFERENCES vendas(id_venda),
    CONSTRAINT fk_itens_produtos
        FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

-- ============================================================
-- 50 REGISTROS: CLIENTES
-- ============================================================

INSERT INTO clientes (id_cliente, nome_cliente, cidade, estado) VALUES
    (1, 'Ana Souza', 'Curitiba', 'PR'),
    (2, 'Bruno Lima', 'São José dos Pinhais', 'PR'),
    (3, 'Carla Mendes', 'Curitiba', 'PR'),
    (4, 'Diego Martins', 'Colombo', 'PR'),
    (5, 'Eduarda Alves', 'Pinhais', 'PR'),
    (6, 'Felipe Rocha', 'Curitiba', 'PR'),
    (7, 'Gabriela Costa', 'Araucária', 'PR'),
    (8, 'Henrique Silva', 'Curitiba', 'PR'),
    (9, 'Isabela Nunes', 'Campo Largo', 'PR'),
    (10, 'João Ribeiro', 'Curitiba', 'PR'),
    (11, 'Karen Oliveira', 'Piraquara', 'PR'),
    (12, 'Lucas Ferreira', 'Curitiba', 'PR'),
    (13, 'Mariana Gomes', 'Almirante Tamandaré', 'PR'),
    (14, 'Nicolas Santos', 'Curitiba', 'PR'),
    (15, 'Olívia Barros', 'Fazenda Rio Grande', 'PR'),
    (16, 'Paulo Moreira', 'Curitiba', 'PR'),
    (17, 'Queila Teixeira', 'Quatro Barras', 'PR'),
    (18, 'Rafael Cardoso', 'Curitiba', 'PR'),
    (19, 'Sabrina Correia', 'Campina Grande do Sul', 'PR'),
    (20, 'Thiago Lopes', 'Curitiba', 'PR'),
    (21, 'Úrsula Freitas', 'Mandirituba', 'PR'),
    (22, 'Vinícius Melo', 'Curitiba', 'PR'),
    (23, 'William Araújo', 'Rio Branco do Sul', 'PR'),
    (24, 'Yasmin Duarte', 'Curitiba', 'PR'),
    (25, 'Alice Pires', 'Joinville', 'SC'),
    (26, 'Bernardo Castro', 'Florianópolis', 'SC'),
    (27, 'Cecília Farias', 'Blumenau', 'SC'),
    (28, 'Daniela Reis', 'Itajaí', 'SC'),
    (29, 'Enzo Carvalho', 'São Paulo', 'SP'),
    (30, 'Fernanda Vieira', 'Campinas', 'SP'),
    (31, 'Gustavo Moraes', 'Sorocaba', 'SP'),
    (32, 'Helena Campos', 'Santos', 'SP'),
    (33, 'Igor Monteiro', 'Rio de Janeiro', 'RJ'),
    (34, 'Juliana Peixoto', 'Niterói', 'RJ'),
    (35, 'Kaique Batista', 'Belo Horizonte', 'MG'),
    (36, 'Larissa Cunha', 'Londrina', 'PR'),
    (37, 'Marcelo Prado', 'Maringá', 'PR'),
    (38, 'Natália Assis', 'Cascavel', 'PR'),
    (39, 'Otávio Rezende', 'Ponta Grossa', 'PR'),
    (40, 'Priscila Leal', 'Guarapuava', 'PR'),
    (41, 'Renato Diniz', 'Paranaguá', 'PR'),
    (42, 'Simone Amaral', 'Curitiba', 'PR'),
    (43, 'Tadeu Coelho', 'Curitiba', 'PR'),
    (44, 'Valéria Neves', 'Curitiba', 'PR'),
    (45, 'Wesley Ramos', 'Curitiba', 'PR'),
    (46, 'Adriana Luz', 'Curitiba', 'PR'),
    (47, 'Caio Borges', 'Curitiba', 'PR'),
    (48, 'Débora Matos', 'Curitiba', 'PR'),
    (49, 'Emanuel Pinto', 'Curitiba', 'PR'),
    (50, 'Flávia Xavier', 'Curitiba', 'PR');

-- ============================================================
-- 50 REGISTROS: VENDEDORES
-- ============================================================

INSERT INTO vendedores (id_vendedor, nome_vendedor, setor) VALUES
    (1, 'Amanda Freire', 'Loja Física'),
    (2, 'Breno Paiva', 'E-commerce'),
    (3, 'Camila Sales', 'Corporativo'),
    (4, 'Douglas Reis', 'Televendas'),
    (5, 'Elaine Braga', 'Marketplace'),
    (6, 'Fábio Moura', 'Loja Física'),
    (7, 'Giovana Teles', 'E-commerce'),
    (8, 'Hugo Andrade', 'Corporativo'),
    (9, 'Ingrid Leite', 'Televendas'),
    (10, 'Jorge Cunha', 'Marketplace'),
    (11, 'Kátia Prado', 'Loja Física'),
    (12, 'Leandro Vaz', 'E-commerce'),
    (13, 'Mônica Dias', 'Corporativo'),
    (14, 'Natan Pacheco', 'Televendas'),
    (15, 'Patrícia Alves', 'Marketplace'),
    (16, 'Ricardo Falcão', 'Loja Física'),
    (17, 'Sara Brito', 'E-commerce'),
    (18, 'Tomás Queiroz', 'Corporativo'),
    (19, 'Vanessa Lins', 'Televendas'),
    (20, 'Yuri Bastos', 'Marketplace'),
    (21, 'Aline Rocha', 'Loja Física'),
    (22, 'Bruno Medeiros', 'E-commerce'),
    (23, 'Cláudia Fontes', 'Corporativo'),
    (24, 'Davi Correia', 'Televendas'),
    (25, 'Ester Maia', 'Marketplace'),
    (26, 'Fernando Lima', 'Loja Física'),
    (27, 'Graziella Moraes', 'E-commerce'),
    (28, 'Heitor Nunes', 'Corporativo'),
    (29, 'Iara Martins', 'Televendas'),
    (30, 'Jonas Cardoso', 'Marketplace'),
    (31, 'Kelly Ribeiro', 'Loja Física'),
    (32, 'Luan Pereira', 'E-commerce'),
    (33, 'Márcia Carvalho', 'Corporativo'),
    (34, 'Noel Souza', 'Televendas'),
    (35, 'Pamela Castro', 'Marketplace'),
    (36, 'Raul Mendes', 'Loja Física'),
    (37, 'Silvia Lopes', 'E-commerce'),
    (38, 'Túlio Barros', 'Corporativo'),
    (39, 'Vitória Gomes', 'Televendas'),
    (40, 'Wallace Freitas', 'Marketplace'),
    (41, 'Ágata Moreira', 'Loja Física'),
    (42, 'César Silva', 'E-commerce'),
    (43, 'Denise Oliveira', 'Corporativo'),
    (44, 'Edson Santos', 'Televendas'),
    (45, 'Francine Costa', 'Marketplace'),
    (46, 'Gilberto Melo', 'Loja Física'),
    (47, 'Heloísa Reis', 'E-commerce'),
    (48, 'Ítalo Vieira', 'Corporativo'),
    (49, 'Jéssica Pires', 'Televendas'),
    (50, 'Kevin Araújo', 'Marketplace');

-- ============================================================
-- 50 REGISTROS: PRODUTOS
-- ============================================================

INSERT INTO produtos (id_produto, nome_produto, categoria, marca, preco) VALUES
    (1, 'Notebook Pro 14', 'Informática', 'TechPlus', 4599.90),
    (2, 'Mouse Sem Fio', 'Informática', 'ClickMax', 89.90),
    (3, 'Teclado Mecânico', 'Informática', 'KeyMaster', 329.90),
    (4, 'Monitor 24 Polegadas', 'Informática', 'Vision', 899.90),
    (5, 'SSD 1 TB', 'Informática', 'FastDrive', 449.90),
    (6, 'Webcam Full HD', 'Informática', 'Vision', 219.90),
    (7, 'Headset Gamer', 'Informática', 'SoundPlay', 289.90),
    (8, 'Roteador Wi-Fi 6', 'Informática', 'Connect', 399.90),
    (9, 'Impressora Multifuncional', 'Informática', 'PrintNow', 799.90),
    (10, 'Hub USB-C', 'Informática', 'Connect', 179.90),
    (11, 'Smartphone X1', 'Telefonia', 'MobileX', 1999.90),
    (12, 'Smartphone X2 Pro', 'Telefonia', 'MobileX', 3299.90),
    (13, 'Carregador Turbo', 'Telefonia', 'Volt', 119.90),
    (14, 'Capa Antichoque', 'Telefonia', 'SafeCase', 69.90),
    (15, 'Fone Bluetooth', 'Telefonia', 'SoundPlay', 199.90),
    (16, 'Smartwatch Fit', 'Wearables', 'Move', 599.90),
    (17, 'Pulseira Inteligente', 'Wearables', 'Move', 249.90),
    (18, 'TV 50 Polegadas 4K', 'TV e Vídeo', 'Vision', 2699.90),
    (19, 'Soundbar 2.1', 'Áudio', 'SoundPlay', 999.90),
    (20, 'Caixa de Som Bluetooth', 'Áudio', 'BeatBox', 349.90),
    (21, 'Air Fryer 5L', 'Eletrodomésticos', 'CasaFácil', 549.90),
    (22, 'Liquidificador 1200W', 'Eletrodomésticos', 'CasaFácil', 229.90),
    (23, 'Cafeteira Elétrica', 'Eletrodomésticos', 'BelaCasa', 189.90),
    (24, 'Micro-ondas 32L', 'Eletrodomésticos', 'BelaCasa', 799.90),
    (25, 'Aspirador Vertical', 'Eletrodomésticos', 'CleanHome', 499.90),
    (26, 'Ventilador de Coluna', 'Climatização', 'FreshAir', 299.90),
    (27, 'Climatizador Portátil', 'Climatização', 'FreshAir', 699.90),
    (28, 'Ar-condicionado 12000 BTU', 'Climatização', 'FreshAir', 2399.90),
    (29, 'Panela Elétrica', 'Eletrodomésticos', 'CasaFácil', 319.90),
    (30, 'Grill Elétrico', 'Eletrodomésticos', 'CasaFácil', 249.90),
    (31, 'Lava-louças 10 Serviços', 'Eletrodomésticos', 'CleanHome', 2999.90),
    (32, 'Máquina de Lavar 12kg', 'Eletrodomésticos', 'CleanHome', 2299.90),
    (33, 'Geladeira Duplex 400L', 'Eletrodomésticos', 'BelaCasa', 3499.90),
    (34, 'Forno Elétrico 50L', 'Eletrodomésticos', 'BelaCasa', 899.90),
    (35, 'Cooktop de Indução', 'Eletrodomésticos', 'CasaFácil', 1399.90),
    (36, 'Ferro a Vapor', 'Eletroportáteis', 'CasaFácil', 159.90),
    (37, 'Secador de Cabelo', 'Cuidados Pessoais', 'BeautyPro', 199.90),
    (38, 'Chapinha Cerâmica', 'Cuidados Pessoais', 'BeautyPro', 169.90),
    (39, 'Barbeador Elétrico', 'Cuidados Pessoais', 'BeautyPro', 249.90),
    (40, 'Escova Secadora', 'Cuidados Pessoais', 'BeautyPro', 229.90),
    (41, 'Câmera de Segurança', 'Segurança', 'SafeHome', 399.90),
    (42, 'Fechadura Digital', 'Segurança', 'SafeHome', 699.90),
    (43, 'Campainha Inteligente', 'Segurança', 'SafeHome', 449.90),
    (44, 'Lâmpada Inteligente', 'Casa Inteligente', 'SmartCasa', 79.90),
    (45, 'Tomada Inteligente', 'Casa Inteligente', 'SmartCasa', 99.90),
    (46, 'Robô Aspirador', 'Casa Inteligente', 'SmartCasa', 1499.90),
    (47, 'Projetor Portátil', 'TV e Vídeo', 'Vision', 1899.90),
    (48, 'Controle Universal', 'TV e Vídeo', 'Connect', 129.90),
    (49, 'Suporte Articulado TV', 'TV e Vídeo', 'SafeMount', 199.90),
    (50, 'Filtro de Linha', 'Acessórios', 'Volt', 89.90);

-- ============================================================
-- 50 REGISTROS: VENDAS
-- ============================================================

INSERT INTO vendas (
    id_venda,
    data_venda,
    id_cliente,
    id_vendedor,
    forma_pagamento,
    status,
    valor_total
) VALUES
    (1, '2026-01-09', 7, 3, 'Pix', 'Concluída', 317.45),
    (2, '2026-01-13', 14, 6, 'Cartão de Crédito', 'Concluída', 454.90),
    (3, '2026-01-17', 21, 9, 'Boleto', 'Concluída', 592.35),
    (4, '2026-01-21', 28, 12, 'Dinheiro', 'Pendente', 729.80),
    (5, '2026-01-25', 35, 15, 'Cartão de Débito', 'Cancelada', 867.25),
    (6, '2026-01-29', 7, 18, 'Pix', 'Concluída', 1004.70),
    (7, '2026-02-02', 14, 1, 'Cartão de Crédito', 'Concluída', 1142.15),
    (8, '2026-02-06', 21, 4, 'Boleto', 'Concluída', 1279.60),
    (9, '2026-02-10', 28, 7, 'Dinheiro', 'Pendente', 1417.05),
    (10, '2026-02-14', 35, 10, 'Cartão de Débito', 'Cancelada', 1554.50),
    (11, '2026-02-18', 7, 13, 'Pix', 'Concluída', 1691.95),
    (12, '2026-02-22', 14, 16, 'Cartão de Crédito', 'Concluída', 1829.40),
    (13, '2026-02-26', 21, 19, 'Boleto', 'Concluída', 1966.85),
    (14, '2026-03-02', 28, 2, 'Dinheiro', 'Pendente', 2104.30),
    (15, '2026-03-06', 35, 5, 'Cartão de Débito', 'Cancelada', 2241.75),
    (16, '2026-03-10', 7, 8, 'Pix', 'Concluída', 2379.20),
    (17, '2026-03-14', 14, 11, 'Cartão de Crédito', 'Concluída', 2516.65),
    (18, '2026-03-18', 21, 14, 'Boleto', 'Concluída', 2654.10),
    (19, '2026-03-22', 28, 17, 'Dinheiro', 'Pendente', 2791.55),
    (20, '2026-03-26', 35, 20, 'Cartão de Débito', 'Cancelada', 2929.00),
    (21, '2026-03-30', 7, 3, 'Pix', 'Concluída', 3066.45),
    (22, '2026-04-03', 14, 6, 'Cartão de Crédito', 'Concluída', 3203.90),
    (23, '2026-04-07', 21, 9, 'Boleto', 'Concluída', 3341.35),
    (24, '2026-04-11', 28, 12, 'Dinheiro', 'Pendente', 3478.80),
    (25, '2026-04-15', 35, 15, 'Cartão de Débito', 'Cancelada', 3616.25),
    (26, '2026-04-19', 7, 18, 'Pix', 'Concluída', 3753.70),
    (27, '2026-04-23', 14, 1, 'Cartão de Crédito', 'Concluída', 3891.15),
    (28, '2026-04-27', 21, 4, 'Boleto', 'Concluída', 4028.60),
    (29, '2026-05-01', 28, 7, 'Dinheiro', 'Pendente', 4166.05),
    (30, '2026-05-05', 35, 10, 'Cartão de Débito', 'Cancelada', 4303.50),
    (31, '2026-05-09', 7, 13, 'Pix', 'Concluída', 4440.95),
    (32, '2026-05-13', 14, 16, 'Cartão de Crédito', 'Concluída', 4578.40),
    (33, '2026-05-17', 21, 19, 'Boleto', 'Concluída', 4715.85),
    (34, '2026-05-21', 28, 2, 'Dinheiro', 'Pendente', 4853.30),
    (35, '2026-05-25', 35, 5, 'Cartão de Débito', 'Cancelada', 190.75),
    (36, '2026-05-29', 7, 8, 'Pix', 'Concluída', 328.20),
    (37, '2026-06-02', 14, 11, 'Cartão de Crédito', 'Concluída', 465.65),
    (38, '2026-06-06', 21, 14, 'Boleto', 'Concluída', 603.10),
    (39, '2026-06-10', 28, 17, 'Dinheiro', 'Pendente', 740.55),
    (40, '2026-06-14', 35, 20, 'Cartão de Débito', 'Cancelada', 878.00),
    (41, '2026-06-18', 7, 3, 'Pix', 'Concluída', 1015.45),
    (42, '2026-06-22', 14, 6, 'Cartão de Crédito', 'Concluída', 1152.90),
    (43, '2026-06-26', 21, 9, 'Boleto', 'Concluída', 1290.35),
    (44, '2026-06-30', 28, 12, 'Dinheiro', 'Pendente', 1427.80),
    (45, '2026-01-05', 35, 15, 'Cartão de Débito', 'Cancelada', 1565.25),
    (46, '2026-01-09', 7, 18, 'Pix', 'Concluída', 1702.70),
    (47, '2026-01-13', 14, 1, 'Cartão de Crédito', 'Concluída', 1840.15),
    (48, '2026-01-17', 21, 4, 'Boleto', 'Concluída', 1977.60),
    (49, '2026-01-21', 28, 7, 'Dinheiro', 'Pendente', 2115.05),
    (50, '2026-01-25', 35, 10, 'Cartão de Débito', 'Cancelada', 2252.50);

-- ============================================================
-- 50 REGISTROS: ITENS_VENDA
-- ============================================================

INSERT INTO itens_venda (
    id_item,
    id_venda,
    id_produto,
    quantidade,
    valor_unitario,
    desconto
) VALUES
    (1, 1, 9, 2, 759.90, 5.00),
    (2, 2, 18, 3, 2429.91, 10.00),
    (3, 3, 27, 4, 734.89, 15.00),
    (4, 4, 36, 1, 159.90, 20.00),
    (5, 5, 5, 2, 427.40, 0.00),
    (6, 6, 14, 3, 62.91, 5.00),
    (7, 7, 23, 4, 199.40, 10.00),
    (8, 8, 32, 1, 2299.90, 15.00),
    (9, 9, 1, 2, 4369.90, 20.00),
    (10, 10, 10, 3, 161.91, 0.00),
    (11, 11, 19, 4, 1049.89, 5.00),
    (12, 12, 28, 1, 2399.90, 10.00),
    (13, 13, 37, 2, 189.91, 15.00),
    (14, 14, 6, 3, 197.91, 20.00),
    (15, 15, 15, 4, 209.90, 0.00),
    (16, 16, 24, 1, 799.90, 5.00),
    (17, 17, 33, 2, 3324.90, 10.00),
    (18, 18, 2, 3, 80.91, 15.00),
    (19, 19, 11, 4, 2099.89, 20.00),
    (20, 20, 20, 1, 349.90, 0.00),
    (21, 21, 29, 2, 303.90, 5.00),
    (22, 22, 38, 3, 152.91, 10.00),
    (23, 23, 7, 4, 304.39, 15.00),
    (24, 24, 16, 1, 599.90, 20.00),
    (25, 25, 25, 2, 474.90, 0.00),
    (26, 26, 34, 3, 809.91, 5.00),
    (27, 27, 3, 4, 346.39, 10.00),
    (28, 28, 12, 1, 3299.90, 15.00),
    (29, 29, 21, 2, 522.40, 20.00),
    (30, 30, 30, 3, 224.91, 0.00),
    (31, 31, 39, 4, 262.40, 5.00),
    (32, 32, 8, 1, 399.90, 10.00),
    (33, 33, 17, 2, 237.41, 15.00),
    (34, 34, 26, 3, 269.91, 20.00),
    (35, 35, 35, 4, 1469.90, 0.00),
    (36, 36, 4, 1, 899.90, 5.00),
    (37, 37, 13, 2, 113.91, 10.00),
    (38, 38, 22, 3, 206.91, 15.00),
    (39, 39, 31, 4, 3149.90, 20.00),
    (40, 40, 40, 1, 229.90, 0.00),
    (41, 41, 9, 2, 759.90, 5.00),
    (42, 42, 18, 3, 2429.91, 10.00),
    (43, 43, 27, 4, 734.89, 15.00),
    (44, 44, 36, 1, 159.90, 20.00),
    (45, 45, 5, 2, 427.40, 0.00),
    (46, 46, 14, 3, 62.91, 5.00),
    (47, 47, 23, 4, 199.40, 10.00),
    (48, 48, 32, 1, 2299.90, 15.00),
    (49, 49, 1, 2, 4369.90, 20.00),
    (50, 50, 10, 3, 161.91, 0.00);

-- ============================================================
-- ÍNDICES NAS CHAVES UTILIZADAS NOS JOINS
-- ============================================================

CREATE INDEX idx_vendas_cliente
    ON vendas (id_cliente);

CREATE INDEX idx_vendas_vendedor
    ON vendas (id_vendedor);

CREATE INDEX idx_itens_venda_venda
    ON itens_venda (id_venda);

CREATE INDEX idx_itens_venda_produto
    ON itens_venda (id_produto);


-- ============================================================
-- 15 EXERCÍCIOS DE FIXAÇÃO - INNER JOIN
-- ============================================================
--
-- Regras:
-- 1. Utilize explicitamente INNER JOIN em todas as questões.
-- 2. Utilize aliases para as tabelas.
-- 3. Não utilize SELECT *.
-- 4. Indente e organize o código.
-- 5. Escreva sua solução abaixo de cada enunciado.
-- ============================================================


-- ------------------------------------------------------------
-- EXERCÍCIO 01 - Clientes que compraram
-- ------------------------------------------------------------
-- Liste todas as vendas com:
-- id_venda, data_venda, nome_cliente e valor_total.
-- Relacione as tabelas clientes e vendas.
--
-- ESCREVA SUA CONSULTA ABAIXO:

SELECT
    v.id_venda,
    v.data_venda,
    c.nome_cliente,
    v.valor_total
FROM vendas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente;

-- ------------------------------------------------------------
-- EXERCÍCIO 02 - Vendedor responsável
-- ------------------------------------------------------------
-- Liste:
-- id_venda, data_venda, nome_vendedor, setor e valor_total.
-- Ordene da venda mais recente para a mais antiga.
--
-- ESCREVA SUA CONSULTA ABAIXO:

SELECT
    v.id_venda,
    v.data_venda,
    vd.nome_vendedor,
    vd.setor,
    v.valor_total
FROM vendas AS v
INNER JOIN vendedores AS vd
    ON v.id_vendedor = vd.id_vendedor
ORDER BY v.data_venda DESC;

-- ------------------------------------------------------------
-- EXERCÍCIO 03 - Produtos presentes nas vendas
-- ------------------------------------------------------------
-- Liste:
-- id_item, nome_produto, categoria, quantidade e valor_unitario.
-- Relacione itens_venda e produtos.
--
-- ESCREVA SUA CONSULTA ABAIXO:

SELECT
    iv.id_item,
    p.nome_produto,
    p.categoria,
    iv.quantidade,
    iv.valor_unitario
FROM itens_venda AS iv
INNER JOIN produtos AS p
    ON iv.id_produto = p.id_produto;

-- ------------------------------------------------------------
-- EXERCÍCIO 04 - Detalhamento da venda
-- ------------------------------------------------------------
-- Liste:
-- id_venda, data_venda, nome_produto, quantidade e valor_unitario.
-- Utilize vendas, itens_venda e produtos.
--
-- ESCREVA SUA CONSULTA ABAIXO:

SELECT
    v.id_venda,
    v.data_venda,
    p.nome_produto,
    iv.quantidade,
    iv.valor_unitario
FROM vendas AS v
INNER JOIN itens_venda AS iv
    ON v.id_venda = iv.id_venda
INNER JOIN produtos AS p
    ON iv.id_produto = p.id_produto;

-- ------------------------------------------------------------
-- EXERCÍCIO 05 - Relatório completo
-- ------------------------------------------------------------
-- Liste:
-- id_venda, data_venda, nome_cliente, nome_vendedor,
-- nome_produto, quantidade e valor_unitario.
-- Utilize as cinco tabelas.
--
-- ESCREVA SUA CONSULTA ABAIXO:

SELECT
    v.id_venda,
    v.data_venda,
    c.nome_cliente,
    vd.nome_vendedor,
    p.nome_produto,
    iv.quantidade,
    iv.valor_unitario
FROM vendas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN vendedores AS vd
    ON v.id_vendedor = vd.id_vendedor
INNER JOIN itens_venda AS iv
    ON v.id_venda = iv.id_venda
INNER JOIN produtos AS p
    ON iv.id_produto = p.id_produto;

-- ------------------------------------------------------------
-- EXERCÍCIO 06 - Clientes de Curitiba
-- ------------------------------------------------------------
-- Liste somente vendas de clientes da cidade de Curitiba.
-- Exiba:
-- nome_cliente, cidade, id_venda, data_venda, status e valor_total.
--
-- ESCREVA SUA CONSULTA ABAIXO:

SELECT
    c.nome_cliente,
    c.cidade,
    v.id_venda,
    v.data_venda,
    v.status,
    v.valor_total
FROM clientes AS c
INNER JOIN vendas AS v
    ON c.id_cliente = v.id_cliente
WHERE c.cidade = 'Curitiba';

-- ------------------------------------------------------------
-- EXERCÍCIO 07 - Produtos de Informática vendidos
-- ------------------------------------------------------------
-- Liste apenas produtos da categoria 'Informática' que foram vendidos.
-- Exiba:
-- nome_produto, categoria, id_venda, data_venda e quantidade.
--
-- ESCREVA SUA CONSULTA ABAIXO:

SELECT
    p.nome_produto,
    p.categoria,
    v.id_venda,
    v.data_venda,
    iv.quantidade
FROM produtos AS p
INNER JOIN itens_venda AS iv
    ON p.id_produto = iv.id_produto
INNER JOIN vendas AS v
    ON iv.id_venda = v.id_venda
WHERE p.categoria = 'Informática';

-- ------------------------------------------------------------
-- EXERCÍCIO 08 - Vendas pagas via Pix
-- ------------------------------------------------------------
-- Liste somente vendas cuja forma de pagamento seja 'Pix'.
-- Exiba:
-- id_venda, data_venda, nome_cliente, nome_vendedor e valor_total.
--
-- ESCREVA SUA CONSULTA ABAIXO:

SELECT
    v.id_venda,
    v.data_venda,
    c.nome_cliente,
    vd.nome_vendedor,
    v.valor_total
FROM vendas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN vendedores AS vd
    ON v.id_vendedor = vd.id_vendedor
WHERE v.forma_pagamento = 'Pix';

-- ------------------------------------------------------------
-- EXERCÍCIO 09 - Subtotal dos itens
-- ------------------------------------------------------------
-- Liste itens cuja quantidade seja maior que 2.
-- Exiba:
-- id_venda, nome_produto, quantidade, valor_unitario,
-- desconto e subtotal_bruto.
-- Calcule subtotal_bruto como quantidade * valor_unitario.
--
-- ESCREVA SUA CONSULTA ABAIXO:

SELECT
    iv.id_venda,
    p.nome_produto,
    iv.quantidade,
    iv.valor_unitario,
    iv.desconto,
    iv.quantidade * iv.valor_unitario AS subtotal_bruto
FROM itens_venda AS iv
INNER JOIN produtos AS p
    ON iv.id_produto = p.id_produto
WHERE iv.quantidade > 2;

-- ------------------------------------------------------------
-- EXERCÍCIO 10 - Total comprado por cliente
-- ------------------------------------------------------------
-- Calcule o total comprado por cada cliente que possui vendas.
-- Exiba:
-- id_cliente, nome_cliente, quantidade_vendas e total_comprado.
-- Utilize COUNT, SUM, GROUP BY e ordene do maior para o menor total.
--
-- ESCREVA SUA CONSULTA ABAIXO:

SELECT
    c.id_cliente,
    c.nome_cliente,
    COUNT(v.id_venda) AS quantidade_vendas,
    SUM(v.valor_total) AS total_comprado
FROM clientes AS c
INNER JOIN vendas AS v
    ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nome_cliente
ORDER BY total_comprado DESC;

-- ------------------------------------------------------------
-- EXERCÍCIO 11 - Desempenho dos vendedores
-- ------------------------------------------------------------
-- Para cada vendedor que realizou vendas, exiba:
-- id_vendedor, nome_vendedor, quantidade_vendas,
-- total_vendido e ticket_medio.
-- Utilize COUNT, SUM, AVG e GROUP BY.
--
-- ESCREVA SUA CONSULTA ABAIXO:

SELECT
    vd.id_vendedor,
    vd.nome_vendedor,
    COUNT(v.id_venda) AS quantidade_vendas,
    SUM(v.valor_total) AS total_vendido,
    AVG(v.valor_total) AS ticket_medio
FROM vendedores AS vd
INNER JOIN vendas AS v
    ON vd.id_vendedor = v.id_vendedor
GROUP BY vd.id_vendedor, vd.nome_vendedor;

-- ------------------------------------------------------------
-- EXERCÍCIO 12 - Quantidade vendida por produto
-- ------------------------------------------------------------
-- Para cada produto vendido, exiba:
-- id_produto, nome_produto, categoria e quantidade_total_vendida.
-- Utilize SUM e ordene do produto mais vendido para o menos vendido.
--
-- ESCREVA SUA CONSULTA ABAIXO:

SELECT
    p.id_produto,
    p.nome_produto,
    p.categoria,
    SUM(iv.quantidade) AS quantidade_total_vendida
FROM produtos AS p
INNER JOIN itens_venda AS iv
    ON p.id_produto = iv.id_produto
GROUP BY p.id_produto, p.nome_produto, p.categoria
ORDER BY quantidade_total_vendida DESC;

-- ------------------------------------------------------------
-- EXERCÍCIO 13 - Faturamento por categoria
-- ------------------------------------------------------------
-- Calcule o faturamento líquido por categoria, considerando:
-- quantidade * valor_unitario * (1 - desconto / 100).
-- Exiba:
-- categoria, quantidade_total_itens e faturamento_liquido.
-- Ordene do maior para o menor faturamento.
--
-- ESCREVA SUA CONSULTA ABAIXO:

SELECT
    p.categoria,
    SUM(iv.quantidade) AS quantidade_total_itens,
    SUM(iv.quantidade * iv.valor_unitario * (1 - iv.desconto / 100)) AS faturamento_liquido
FROM produtos AS p
INNER JOIN itens_venda AS iv
    ON p.id_produto = iv.id_produto
GROUP BY p.categoria
ORDER BY faturamento_liquido DESC;

-- ------------------------------------------------------------
-- EXERCÍCIO 14 - Vendas concluídas em um período
-- ------------------------------------------------------------
-- Liste as vendas concluídas entre '2026-03-01' e '2026-06-30'.
-- Exiba:
-- id_venda, data_venda, nome_cliente, nome_vendedor,
-- forma_pagamento e valor_total.
-- Ordene por data_venda e id_venda.
--
-- ESCREVA SUA CONSULTA ABAIXO:

SELECT
    v.id_venda,
    v.data_venda,
    c.nome_cliente,
    vd.nome_vendedor,
    v.forma_pagamento,
    v.valor_total
FROM vendas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN vendedores AS vd
    ON v.id_vendedor = vd.id_vendedor
WHERE v.status = 'Concluída'
  AND v.data_venda BETWEEN '2026-03-01' AND '2026-06-30'
ORDER BY v.data_venda, v.id_venda;

-- ------------------------------------------------------------
-- EXERCÍCIO 15 - Relatório gerencial
-- ------------------------------------------------------------
-- Considere somente vendas com status 'Concluída'.
-- Para cada vendedor, exiba:
-- nome_vendedor,
-- quantidade_vendas,
-- quantidade_clientes_atendidos,
-- quantidade_produtos_vendidos,
-- faturamento_dos_itens,
-- ticket_medio_das_vendas.
--
-- Requisitos obrigatórios:
-- INNER JOIN, COUNT, COUNT(DISTINCT ...), SUM, AVG,
-- GROUP BY e ORDER BY.


SELECT
    vd.nome_vendedor,
    COUNT(DISTINCT v.id_venda) AS quantidade_vendas,
    COUNT(DISTINCT v.id_cliente) AS quantidade_clientes_atendidos,
    SUM(iv.quantidade) AS quantidade_produtos_vendidos,
    SUM(iv.quantidade * iv.valor_unitario * (1 - iv.desconto / 100)) AS faturamento_dos_itens,
    AVG(v.valor_total) AS ticket_medio_das_vendas
FROM vendedores AS vd
INNER JOIN vendas AS v
    ON vd.id_vendedor = v.id_vendedor
INNER JOIN itens_venda AS iv
    ON v.id_venda = iv.id_venda
WHERE v.status = 'Concluída'
GROUP BY vd.nome_vendedor
ORDER BY faturamento_dos_itens DESC;
