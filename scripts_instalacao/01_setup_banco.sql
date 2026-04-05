-- ============================================================
-- INSTALAÇÃO E CONFIGURAÇÃO — db_streaming
-- ============================================================
-- Execute este arquivo primeiro, antes de qualquer outro script.
-- Compatível com MySQL 8.0+
-- ============================================================


-- ============================================================
-- PASSO A PASSO — COMO INSTALAR O MYSQL E RODAR O PROJETO
-- ============================================================
--
-- 1. INSTALAR O MYSQL
--    - Acesse: https://dev.mysql.com/downloads/installer/
--    - Baixe o MySQL Installer para Windows (ou use o gerenciador
--      de pacotes no Linux/Mac)
--    - Durante a instalação, escolha "Developer Default"
--    - Defina uma senha para o usuário root quando solicitado
--    - Instale também o MySQL Workbench (já incluso no installer)
--
-- 2. ABRIR O MYSQL WORKBENCH
--    - Abra o MySQL Workbench
--    - Clique em "Local instance MySQL" para conectar
--    - Digite a senha do root que você definiu na instalação
--
-- 3. EXECUTAR OS SCRIPTS NA ORDEM CORRETA
--    - No Workbench: File > Open SQL Script
--    - Abra e execute cada arquivo na ordem abaixo
--    - Para executar: clique no botão "raio" (Execute) ou Ctrl+Shift+Enter
--
--    ORDEM OBRIGATÓRIA:
--    1. scripts_instalacao/01_setup_banco.sql    → este arquivo (cria o banco)
--    2. sql/01_create_tables.sql                 → cria as tabelas
--    3. sql/03_constraints.sql                   → adiciona constraints
--    4. dados_teste/01_insere_dados.sql           → insere os dados de teste
--    5. views/01_views.sql                        → cria as views
--    6. procedures_triggers/01_triggers.sql       → cria triggers e procedures
--    7. consultas_avancadas/consultas_streaming.sql → consultas prontas
--
-- 4. VERIFICAR SE DEU CERTO
--    - Execute: SHOW TABLES;
--    - Devem aparecer: planos, usuarios, catalogo,
--      historico_visualizacao, favoritos, logs_sistema
-- ============================================================


-- ============================================================
-- CRIAÇÃO DO BANCO DE DADOS
-- ============================================================

CREATE DATABASE IF NOT EXISTS db_streaming
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE db_streaming;

SELECT 'Banco db_streaming criado com sucesso!' AS status;


-- ============================================================
-- CRIAÇÃO DE USUÁRIO E PERMISSÕES
-- ============================================================
-- Cria um usuário dedicado para o projeto, separado do root.
-- Boa prática: nunca usar root em aplicações reais.
--
-- COMO USAR:
-- Substitua 'senha_segura' por uma senha de sua escolha
-- e execute os comandos abaixo descomentados.
-- ============================================================

-- CREATE USER IF NOT EXISTS 'streaming_user'@'localhost' 
--     IDENTIFIED BY 'senha_segura';

-- Permissão completa apenas no banco db_streaming
-- GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER 
--     ON db_streaming.* 
--     TO 'streaming_user'@'localhost';

-- Aplica as permissões imediatamente
-- FLUSH PRIVILEGES;

-- Para verificar as permissões criadas:
-- SHOW GRANTS FOR 'streaming_user'@'localhost';

-- Para remover o usuário se necessário:
-- DROP USER IF EXISTS 'streaming_user'@'localhost';
