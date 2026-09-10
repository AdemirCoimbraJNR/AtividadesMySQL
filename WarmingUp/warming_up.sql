-- ============================================================
-- BASE DE DADOS DIDÁTICA: CONTROLE DE VENDAS
-- Compatível com MySQL 8
-- ============================================================
create database if not exists db_2_bim;
use db_2_bim;

DROP TABLE IF EXISTS vendas;

CREATE TABLE vendas (
    id_venda INT NOT NULL,
    data_venda DATE NOT NULL,
    nome_cliente VARCHAR(100) NOT NULL,
    cidade_cliente VARCHAR(80) NOT NULL,
    estado_cliente CHAR(2) NOT NULL,
    nome_produto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    valor_total DECIMAL(12,2) NOT NULL,
    forma_pagamento VARCHAR(30) NOT NULL,
    status_venda VARCHAR(20) NOT NULL,
    vendedor VARCHAR(100) NOT NULL,

    CONSTRAINT pk_vendas PRIMARY KEY (id_venda)
);

CREATE INDEX idx_vendas_data
    ON vendas (data_venda);

CREATE INDEX idx_vendas_categoria
    ON vendas (categoria);

CREATE INDEX idx_vendas_status_data
    ON vendas (status_venda, data_venda);

CREATE INDEX idx_vendas_vendedor
    ON vendas (vendedor);

CREATE INDEX idx_vendas_estado
    ON vendas (estado_cliente);

START TRANSACTION;
INSERT INTO vendas (
    id_venda,
    data_venda,
    nome_cliente,
    cidade_cliente,
    estado_cliente,
    nome_produto,
    categoria,
    quantidade,
    valor_unitario,
    valor_total,
    forma_pagamento,
    status_venda,
    vendedor
) VALUES
    (1, '2023-02-04', 'Felipe Martins', 'Campinas', 'SP', 'Caixa de Som', 'Eletrônicos', 2, 399.90, 799.80, 'Boleto', 'Pendente', 'Diego'),
    (2, '2023-03-04', 'Isabela Ribeiro', 'Belo Horizonte', 'MG', 'Notebook Pro 15', 'Informática', 3, 4599.90, 13799.70, 'Cartao', 'Concluída', 'Bernardo'),
    (3, '2023-04-01', 'Lucas Barbosa', 'Joinville', 'SC', 'Smart TV 50 Polegadas', 'Eletrônicos', 4, 2799.90, 11199.60, 'Dinheiro', 'Cancelada', 'Elisa'),
    (4, '2023-04-29', 'Olívia Carvalho', 'Salvador', 'BA', 'Webcam Full HD', 'Informática', 5, 299.90, 1499.50, 'Débito', 'Concluída', 'Camila'),
    (5, '2023-05-15', 'Rafael Teixeira', 'Brasília', 'DF', 'Fone Bluetooth', 'Eletrônicos', 1, 249.90, 249.90, 'Pix', 'Cancelada', 'Amanda'),
    (6, '2023-06-24', 'Ana Souza', 'Curitiba', 'PR', 'Mesa para Computador', 'Móveis', 2, 649.90, 1299.80, 'Boleto', 'Concluída', 'Diego'),
    (7, '2023-07-22', 'Daniel Rocha', 'Maringá', 'PR', 'Carregador USB-C', 'Acessórios', 3, 89.90, 269.70, 'Cartao', 'Pendente', 'Bernardo'),
    (8, '2023-08-19', 'Gabriela Costa', 'Rio de Janeiro', 'RJ', 'Cadeira de Escritório', 'Móveis', 4, 749.90, 2999.60, 'Dinheiro', 'Concluída', 'Elisa'),
    (9, '2023-06-09', 'João Ferreira', 'Contagem', 'MG', 'Smartphone X20', 'Telefonia', 5, 1899.90, 9499.50, 'Débito', 'Cancelada', 'Camila'),
    (10, '2023-07-07', 'Mariana Santos', 'Porto Alegre', 'RS', 'Micro-ondas 32L', 'Eletrodomésticos', 1, 849.90, 999.99, 'Pix', 'Concluída', 'Amanda'),
    (11, '2023-08-04', 'Paulo Araújo', 'Recife', 'PE', 'Monitor 24 Polegadas', 'Informática', 2, 899.90, 1799.80, 'Boleto', 'Concluída', 'Diego'),
    (12, '2024-03-27', 'Sofia Nunes', 'Vitória', 'ES', 'Liquidificador', 'Eletrodomésticos', 3, 219.90, 659.70, 'Cartao', 'Pendente', 'Bernardo'),
    (13, '2023-09-29', 'Bruno Lima', 'São José dos Pinhais', 'PR', 'Teclado Mecânico', 'Informática', 4, 349.90, 1399.60, 'Dinheiro', 'Pendente', 'Elisa'),
    (14, '2023-10-27', 'Eduarda Alves', 'São Paulo', 'SP', 'Air Fryer 5L', 'Eletrodomésticos', 5, 599.90, 2999.50, 'Débito', 'Concluída', 'Camila'),
    (15, '2023-11-24', 'Henrique Gomes', 'Niterói', 'RJ', 'Mouse Sem Fio', 'Informática', 1, 129.90, 129.90, 'Pix', 'Cancelada', 'Amanda'),
    (16, '2023-12-22', 'Karen Oliveira', 'Florianópolis', 'SC', 'Caixa de Som', 'Eletrônicos', 2, 399.90, 799.80, 'Boleto', 'Concluída', 'Diego'),
    (17, '2024-01-19', 'Nicolas Pereira', 'Caxias do Sul', 'RS', 'Notebook Pro 15', 'Informática', 3, 4599.90, 13799.70, 'Cartao', 'Concluída', 'Bernardo'),
    (18, '2023-05-28', 'Quezia Fernandes', 'Goiânia', 'GO', 'Smart TV 50 Polegadas', 'Eletrônicos', 4, 2799.90, 11199.60, 'Dinheiro', 'Cancelada', 'Elisa'),
    (19, '2023-12-07', 'Thiago Moreira', 'Fortaleza', 'CE', 'Webcam Full HD', 'Informática', 5, 299.90, 1499.50, 'Débito', 'Pendente', 'Camila'),
    (20, '2024-01-04', 'Carla Mendes', 'Londrina', 'PR', 'Fone Bluetooth', 'Eletrônicos', 1, 249.90, 249.90, 'Pix', 'Concluída', 'Amanda'),
    (21, '2024-02-01', 'Felipe Martins', 'Campinas', 'SP', 'Mesa para Computador', 'Móveis', 2, 649.90, 1299.80, 'Boleto', 'Cancelada', 'Diego'),
    (22, '2024-02-29', 'Isabela Ribeiro', 'Belo Horizonte', 'MG', 'Carregador USB-C', 'Acessórios', 3, 89.90, 269.70, 'Cartao', 'Concluída', 'Bernardo'),
    (23, '2024-03-28', 'Lucas Barbosa', 'Joinville', 'SC', 'Cadeira de Escritório', 'Móveis', 4, 749.90, 2999.60, 'Dinheiro', 'Concluída', 'Elisa'),
    (24, '2024-04-25', 'Olívia Carvalho', 'Salvador', 'BA', 'Smartphone X20', 'Telefonia', 5, 1899.90, 9499.50, 'Débito', 'Concluída', 'Camila'),
    (25, '2024-05-23', 'Rafael Teixeira', 'Brasília', 'DF', 'Micro-ondas 32L', 'Eletrodomésticos', 1, 849.90, 849.90, 'Pix', 'Pendente', 'Amanda'),
    (26, '2024-06-20', 'Ana Souza', 'Curitiba', 'PR', 'Monitor 24 Polegadas', 'Informática', 2, 899.90, 1799.80, 'Boleto', 'Concluída', 'Diego'),
    (27, '2024-04-10', 'Daniel Rocha', 'Maringá', 'PR', 'Liquidificador', 'Eletrodomésticos', 0, 219.90, 0.00, 'Cartao', 'Cancelada', 'Bernardo'),
    (28, '2024-05-08', 'Gabriela Costa', 'Rio de Janeiro', 'RJ', 'Teclado Mecânico', 'Informática', 4, 349.90, 1399.60, 'Dinheiro', 'Concluída', 'Elisa'),
    (29, '2024-06-05', 'João Ferreira', 'Contagem', 'MG', 'Air Fryer 5L', 'Eletrodomésticos', 5, 599.90, 2999.50, 'Débito', 'Concluída', 'Camila'),
    (30, '2024-07-03', 'Mariana Santos', 'Porto Alegre', 'RS', 'Mouse Sem Fio', 'Informática', 1, 129.90, 129.90, 'Pix', 'Concluída', 'Amanda'),
    (31, '2024-07-31', 'Paulo Araújo', 'Recife', 'PE', 'Caixa de Som', 'Eletrônicos', 2, 399.90, 799.80, 'Boleto', 'Pendente', 'Diego'),
    (32, '2024-08-28', 'Sofia Nunes', 'Vitória', 'ES', 'Notebook Pro 15', 'Informática', 3, 4599.90, 13799.70, 'Cartao', 'Concluída', 'Bernardo'),
    (33, '2024-04-17', 'Bruno Lima', 'São José dos Pinhais', 'PR', 'Smart TV 50 Polegadas', 'Eletrônicos', 4, 2799.90, 11199.60, 'Dinheiro', 'Pendente', 'Elisa'),
    (34, '2024-10-23', 'Eduarda Alves', 'São Paulo', 'SP', 'Webcam Full HD', 'Informática', 5, 299.90, 1499.50, 'Débito', 'Concluída', 'Camila'),
    (35, '2024-11-20', 'Henrique Gomes', 'Niterói', 'RJ', 'Fone Bluetooth', 'Eletrônicos', 1, 249.90, 249.90, 'Pix', 'Concluída', 'Amanda'),
    (36, '2024-09-10', 'Karen Oliveira', 'Florianópolis', 'SC', 'Mesa para Computador', 'Móveis', 2, 649.90, 1299.80, 'Boleto', 'Concluída', 'Diego'),
    (37, '2024-10-08', 'Nicolas Pereira', 'Caxias do Sul', 'RS', 'Carregador USB-C', 'Acessórios', 3, 89.90, 269.70, 'Cartao', 'Pendente', 'Bernardo'),
    (38, '2024-11-05', 'Quezia Fernandes', 'Goiânia', 'GO', 'Cadeira de Escritório', 'Móveis', 4, 749.90, 2999.60, 'Dinheiro', 'Concluída', 'Elisa'),
    (39, '2024-12-03', 'Thiago Moreira', 'Fortaleza', 'CE', 'Smartphone X20', 'Telefonia', 5, 1899.90, 9499.50, 'Débito', 'Cancelada', 'Camila'),
    (40, '2024-12-31', 'Carla Mendes', 'Londrina', 'PR', 'Micro-ondas 32L', 'Eletrodomésticos', 1, 849.90, 849.90, 'Pix', 'Concluída', 'Amanda'),
    (41, '2023-06-20', 'Felipe Martins', 'Campinas', 'SP', 'Monitor 24 Polegadas', 'Informática', 2, 899.90, 1799.80, 'Boleto', 'Cancelada', 'Diego'),
    (42, '2025-02-25', 'Isabela Ribeiro', 'Belo Horizonte', 'MG', 'Liquidificador', 'Eletrodomésticos', 3, 219.90, 659.70, 'Cartao', 'Concluída', 'Bernardo'),
    (43, '2025-03-25', 'Lucas Barbosa', 'Joinville', 'SC', 'Teclado Mecânico', 'Informática', 4, 349.90, 1399.60, 'Dinheiro', 'Pendente', 'Elisa'),
    (44, '2025-04-22', 'Olívia Carvalho', 'Salvador', 'BA', 'Air Fryer 5L', 'Eletrodomésticos', 5, 599.90, 2999.50, 'Débito', 'Concluída', 'Camila'),
    (45, '2025-02-10', 'Rafael Teixeira', 'Brasília', 'DF', 'Mouse Sem Fio', 'Informática', 1, 129.90, 129.90, 'Pix', 'Cancelada', 'Amanda'),
    (46, '2025-03-10', 'Ana Souza', 'Curitiba', 'PR', 'Caixa de Som', 'Eletrônicos', 2, 399.90, 799.80, 'Boleto', 'Concluída', 'Diego'),
    (47, '2024-05-01', 'Daniel Rocha', 'Maringá', 'PR', 'Notebook Pro 15', 'Informática', 3, 4599.90, 13799.70, 'Cartao', 'Pendente', 'Bernardo'),
    (48, '2025-05-05', 'Gabriela Costa', 'Rio de Janeiro', 'RJ', 'Smart TV 50 Polegadas', 'Eletrônicos', 4, 2799.90, 11199.60, 'Dinheiro', 'Concluída', 'Elisa'),
    (49, '2025-06-02', 'João Ferreira', 'Contagem', 'MG', 'Webcam Full HD', 'Informática', 5, 299.90, 1499.50, 'Débito', 'Pendente', 'Camila'),
    (50, '2025-06-30', 'Mariana Santos', 'Porto Alegre', 'RS', 'Fone Bluetooth', 'Eletrônicos', 1, 249.90, 249.90, 'Pix', 'Concluída', 'Amanda'),
    (51, '2025-07-28', 'Paulo Araújo', 'Recife', 'PE', 'Mesa para Computador', 'Móveis', 2, 649.90, 1299.80, 'Boleto', 'Cancelada', 'Diego'),
    (52, '2025-08-25', 'Sofia Nunes', 'Vitória', 'ES', 'Carregador USB-C', 'Acessórios', 3, 89.90, 269.70, 'Cartao', 'Concluída', 'Bernardo'),
    (53, '2025-09-22', 'Bruno Lima', 'São José dos Pinhais', 'PR', 'Cadeira de Escritório', 'Móveis', 4, 749.90, 2999.60, 'Dinheiro', 'Concluída', 'Elisa'),
    (54, '2025-07-13', 'Eduarda Alves', 'São Paulo', 'SP', 'Smartphone X20', 'Telefonia', 5, 1899.90, 9499.50, 'Débito', 'Concluída', 'Camila'),
    (55, '2025-08-10', 'Henrique Gomes', 'Niterói', 'RJ', 'Micro-ondas 32L', 'Eletrodomésticos', 1, 849.90, 849.90, 'Pix', 'Pendente', 'Amanda'),
    (56, '2025-09-07', 'Karen Oliveira', 'Florianópolis', 'SC', 'Monitor 24 Polegadas', 'Informática', 2, 899.90, 1799.80, 'Boleto', 'Concluída', 'Diego'),
    (57, '2025-10-05', 'Nicolas Pereira', 'Caxias do Sul', 'RS', 'Liquidificador', 'Eletrodomésticos', 3, 219.90, 659.70, 'Cartao', 'Cancelada', 'Bernardo'),
    (58, '2025-11-02', 'Quezia Fernandes', 'Goiânia', 'GO', 'Teclado Mecânico', 'Informática', 0, 349.90, 0.00, 'Dinheiro', 'Concluída', 'Elisa'),
    (59, '2025-11-30', 'Thiago Moreira', 'Fortaleza', 'CE', 'Air Fryer 5L', 'Eletrodomésticos', 5, 599.90, 2999.50, 'Débito', 'Concluída', 'Camila'),
    (60, '2025-12-28', 'Carla Mendes', 'Londrina', 'PR', 'Mouse Sem Fio', 'Informática', 1, 129.90, 129.90, 'Pix', 'Concluída', 'Amanda'),
    (61, '2026-01-25', 'Felipe Martins', 'Campinas', 'SP', 'Caixa de Som', 'Eletrônicos', 2, 399.90, 799.80, 'Boleto', 'Pendente', 'Diego'),
    (62, '2026-02-22', 'Isabela Ribeiro', 'Belo Horizonte', 'MG', 'Notebook Pro 15', 'Informática', 3, 4599.90, 13799.70, 'Cartao', 'Concluída', 'Bernardo'),
    (63, '2025-12-13', 'Lucas Barbosa', 'Joinville', 'SC', 'Smart TV 50 Polegadas', 'Eletrônicos', 4, 2799.90, 11199.60, 'Dinheiro', 'Cancelada', 'Elisa'),
    (64, '2026-01-10', 'Olívia Carvalho', 'Salvador', 'BA', 'Webcam Full HD', 'Informática', 5, 299.90, 1499.50, 'Débito', 'Concluída', 'Camila'),
    (65, '2026-02-07', 'Rafael Teixeira', 'Brasília', 'DF', 'Fone Bluetooth', 'Eletrônicos', 1, 249.90, 249.90, 'Pix', 'Concluída', 'Amanda'),
    (66, '2024-05-20', 'Ana Souza', 'Curitiba', 'PR', 'Mesa para Computador', 'Móveis', 2, 649.90, 1299.80, 'Boleto', 'Pendente', 'Diego'),
    (67, '2026-04-04', 'Daniel Rocha', 'Maringá', 'PR', 'Carregador USB-C', 'Acessórios', 3, 89.90, 269.70, 'Cartao', 'Pendente', 'Bernardo'),
    (68, '2026-05-02', 'Gabriela Costa', 'Rio de Janeiro', 'RJ', 'Cadeira de Escritório', 'Móveis', 4, 749.90, 2999.60, 'Dinheiro', 'Concluída', 'Elisa'),
    (69, '2026-05-30', 'João Ferreira', 'Contagem', 'MG', 'Smartphone X20', 'Telefonia', 5, 1899.90, 9499.50, 'Débito', 'Cancelada', 'Camila'),
    (70, '2023-02-03', 'Mariana Santos', 'Porto Alegre', 'RS', 'Micro-ondas 32L', 'Eletrodomésticos', 1, 849.90, 849.90, 'Pix', 'Concluída', 'Amanda'),
    (71, '2023-03-03', 'Paulo Araújo', 'Recife', 'PE', 'Monitor 24 Polegadas', 'Informática', 2, 899.90, 1799.80, 'Boleto', 'Concluída', 'Diego'),
    (72, '2026-05-15', 'Sofia Nunes', 'Vitória', 'ES', 'Liquidificador', 'Eletrodomésticos', 3, 219.90, 659.70, 'Cartao', 'Concluída', 'Bernardo'),
    (73, '2023-01-19', 'Bruno Lima', 'São José dos Pinhais', 'PR', 'Teclado Mecânico', 'Informática', 4, 349.90, 1399.60, 'Dinheiro', 'Pendente', 'Elisa'),
    (74, '2023-02-16', 'Eduarda Alves', 'São Paulo', 'SP', 'Air Fryer 5L', 'Eletrodomésticos', 5, 599.90, 2999.50, 'Débito', 'Concluída', 'Camila'),
    (75, '2023-03-16', 'Henrique Gomes', 'Niterói', 'RJ', 'Mouse Sem Fio', 'Informática', 1, 129.90, 129.90, 'Pix', 'Cancelada', 'Amanda'),
    (76, '2023-04-13', 'Karen Oliveira', 'Florianópolis', 'SC', 'Caixa de Som', 'Eletrônicos', 2, 399.90, 799.80, 'Boleto', 'Concluída', 'Diego'),
    (77, '2023-05-11', 'Nicolas Pereira', 'Caxias do Sul', 'RS', 'Notebook Pro 15', 'Informática', 3, 4599.90, 13799.70, 'Cartao', 'Concluída', 'Bernardo'),
    (78, '2023-06-08', 'Quezia Fernandes', 'Goiânia', 'GO', 'Smart TV 50 Polegadas', 'Eletrônicos', 4, 2799.90, 11199.60, 'Dinheiro', 'Concluída', 'Elisa'),
    (79, '2023-07-06', 'Thiago Moreira', 'Fortaleza', 'CE', 'Webcam Full HD', 'Informática', 5, 299.90, 1499.50, 'Débito', 'Pendente', 'Camila'),
    (80, '2023-08-03', 'Carla Mendes', 'Londrina', 'PR', 'Fone Bluetooth', 'Eletrônicos', 1, 249.90, 249.90, 'Pix', 'Concluída', 'Amanda'),
    (81, '2023-05-24', 'Felipe Martins', 'Campinas', 'SP', 'Mesa para Computador', 'Móveis', 2, 649.90, 1299.80, 'Boleto', 'Cancelada', 'Diego'),
    (82, '2023-06-21', 'Isabela Ribeiro', 'Belo Horizonte', 'MG', 'Carregador USB-C', 'Acessórios', 3, 89.90, 269.70, 'Cartao', 'Concluída', 'Bernardo'),
    (83, '2023-07-19', 'Lucas Barbosa', 'Joinville', 'SC', 'Cadeira de Escritório', 'Móveis', -1, 749.90, -749.90, 'Dinheiro', 'Concluída', 'Elisa'),
    (84, '2023-08-16', 'Olívia Carvalho', 'Salvador', 'BA', 'Smartphone X20', 'Telefonia', 5, 1899.90, 9499.50, 'Débito', 'Concluída', 'Camila'),
    (85, '2023-09-13', 'Rafael Teixeira', 'Brasília', 'DF', 'Micro-ondas 32L', 'Eletrodomésticos', 1, 849.90, 849.90, 'Pix', 'Pendente', 'Amanda'),
    (86, '2023-10-11', 'Ana Souza', 'Curitiba', 'PR', 'Monitor 24 Polegadas', 'Informática', 2, 899.90, 1799.80, 'Boleto', 'Concluída', 'Diego'),
    (87, '2023-11-08', 'Daniel Rocha', 'Maringá', 'PR', 'Liquidificador', 'Eletrodomésticos', 3, 219.90, 659.70, 'Cartao', 'Cancelada', 'Bernardo'),
    (88, '2023-12-06', 'Gabriela Costa', 'Rio de Janeiro', 'RJ', 'Teclado Mecânico', 'Informática', 4, 349.90, 1399.60, 'Dinheiro', 'Concluída', 'Elisa'),
    (89, '2024-01-03', 'João Ferreira', 'Contagem', 'MG', 'Air Fryer 5L', 'Eletrodomésticos', 5, 599.90, 2999.50, 'Débito', 'Concluída', 'Camila'),
    (90, '2023-10-24', 'Mariana Santos', 'Porto Alegre', 'RS', 'Mouse Sem Fio', 'Informática', 1, 129.90, 129.90, 'Pix', 'Concluída', 'Amanda'),
    (91, '2023-11-21', 'Paulo Araújo', 'Recife', 'PE', 'Caixa de Som', 'Eletrônicos', 2, 399.90, 799.80, 'Boleto', 'Pendente', 'Diego'),
    (92, '2023-12-19', 'Sofia Nunes', 'Vitória', 'ES', 'Notebook Pro 15', 'Informática', 3, 4599.90, 13799.70, 'Cartao', 'Concluída', 'Bernardo'),
    (93, '2024-01-16', 'Bruno Lima', 'São José dos Pinhais', 'PR', 'Smart TV 50 Polegadas', 'Eletrônicos', 4, 2799.90, 11199.60, 'Dinheiro', 'Cancelada', 'Elisa'),
    (94, '2024-02-13', 'Eduarda Alves', 'São Paulo', 'SP', 'Webcam Full HD', 'Informática', 5, 299.90, 1499.50, 'Débito', 'Concluída', 'Camila'),
    (95, '2024-03-12', 'Henrique Gomes', 'Niterói', 'RJ', 'Fone Bluetooth', 'Eletrônicos', 1, 249.90, 249.90, 'Pix', 'Concluída', 'Amanda'),
    (96, '2024-04-09', 'Karen Oliveira', 'Florianópolis', 'SC', 'Mesa para Computador', 'Móveis', 2, 649.90, 1299.80, 'Boleto', 'Concluída', 'Diego'),
    (97, '2024-05-07', 'Nicolas Pereira', 'Caxias do Sul', 'RS', 'Carregador USB-C', 'Acessórios', 3, 89.90, 269.70, 'Cartao', 'Pendente', 'Bernardo'),
    (98, '2024-06-04', 'Quezia Fernandes', 'Goiânia', 'GO', 'Cadeira de Escritório', 'Móveis', 4, 749.90, 2999.60, 'Dinheiro', 'Concluída', 'Elisa'),
    (99, '2024-03-25', 'Thiago Moreira', 'Fortaleza', 'CE', 'Smartphone X20', 'Telefonia', 5, 1899.90, 9499.50, 'Débito', 'Cancelada', 'Camila'),
    (100, '2024-04-22', 'Carla Mendes', 'Londrina', 'PR', 'Micro-ondas 32L', 'Eletrodomésticos', 1, 849.90, 849.90, 'Pix', 'Concluída', 'Amanda');

COMMIT;

-- Conferência da carga
SELECT COUNT(*) AS total_registros
FROM vendas;
