-- ============================================================
-- VIEWS — db_streaming
-- ============================================================
 
 
-- VIEW 1: Relatório de Conteúdo Mais Visto
-- Lista todos os títulos do catálogo ordenados pelo número
-- de visualizações, do mais assistido para o menos assistido.
CREATE VIEW vw_conteudo_mais_visto AS
SELECT 
    c.titulo,
    c.tipo,
    c.genero,
    COUNT(h.id_item) AS total_visualizacoes
FROM catalogo c
LEFT JOIN historico_visualizacao h ON c.id_item = h.id_item
GROUP BY c.id_item, c.titulo, c.tipo, c.genero
ORDER BY total_visualizacoes DESC;
 
 
-- VIEW 2: Relatório de Faturamento Estimado por Plano
-- Mostra o total de assinantes e o faturamento mensal
-- estimado para cada tipo de plano, do maior para o menor.
CREATE VIEW vw_faturamento_estimado AS
SELECT 
    p.tipo_plano,
    p.valor AS valor_plano,
    p.tipo_pagamento,
    COUNT(u.id_usuario) AS total_assinantes,
    (COUNT(u.id_usuario) * p.valor) AS faturamento_total
FROM planos p
LEFT JOIN usuarios u ON p.id_plano = u.id_plano
GROUP BY p.id_plano, p.tipo_plano, p.valor, p.tipo_pagamento
ORDER BY faturamento_total DESC;
 
 
-- VIEW 3: Relatório de Usuários por Plano
-- Lista todos os usuários com o plano que possuem,
-- útil para relatórios administrativos e suporte.
CREATE VIEW vw_usuarios_por_plano AS
SELECT 
    p.tipo_plano,
    p.valor,
    u.nome,
    u.email,
    u.telefone
FROM planos p
LEFT JOIN usuarios u ON p.id_plano = u.id_plano
ORDER BY p.tipo_plano, u.nome;
 
 
-- VIEW 4: Relatório de Catálogo por Gênero
-- Mostra a quantidade de títulos disponíveis por gênero
-- e tipo (Filme ou Série), útil para análise do catálogo.
CREATE VIEW vw_catalogo_por_genero AS
SELECT 
    genero,
    tipo,
    COUNT(*) AS total_titulos
FROM catalogo
GROUP BY genero, tipo
ORDER BY genero, total_titulos DESC;
 
 
-- ============================================================
-- DICA DE COMO USAR AS VIEWS
-- ============================================================
 
-- Conteúdos mais assistidos:
-- SELECT * FROM vw_conteudo_mais_visto;
 
-- Faturamento estimado por plano:
-- SELECT * FROM vw_faturamento_estimado;
 
-- Usuários agrupados por plano:
-- SELECT * FROM vw_usuarios_por_plano;
 
-- Títulos disponíveis por gênero:
-- SELECT * FROM vw_catalogo_por_genero;