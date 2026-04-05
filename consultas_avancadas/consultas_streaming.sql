-- CONSULTAS STREAMING - db_streaming

-- ============================================================
-- PARTE 1: CONSULTAS SIMPLES 
-- ============================================================

-- 1. Listar todos os usuários cadastrados
SELECT id_usuario, nome, email, telefone FROM usuarios;

-- 2. Listar todos os planos disponíveis com seus valores
SELECT tipo_plano, valor, tipo_pagamento FROM planos;

-- 3. Listar todos os filmes do catálogo
SELECT titulo, classificacao_indicativa, duracao_ou_episodios AS duracao_min
FROM catalogo
WHERE tipo = 'Filme';

-- 4. Listar todas as séries do catálogo
SELECT titulo, classificacao_indicativa, duracao_ou_episodios AS total_episodios
FROM catalogo
WHERE tipo = 'Série';

-- 5. Listar conteúdos com classificação livre (L)
SELECT titulo, tipo, genero
FROM catalogo
WHERE classificacao_indicativa = 'L'
ORDER BY titulo;

-- 6. Listar conteúdos do gênero Ação
SELECT titulo, tipo, classificacao_indicativa
FROM catalogo
WHERE genero = 'Ação'
ORDER BY titulo;

-- 7. Contar quantos itens existem no catálogo por tipo
SELECT tipo, COUNT(*) AS total
FROM catalogo
GROUP BY tipo;

-- 8. Listar os 10 filmes mais longos
SELECT titulo, duracao_ou_episodios AS duracao_min
FROM catalogo
WHERE tipo = 'Filme'
ORDER BY duracao_ou_episodios DESC
LIMIT 10;

-- 9. Listar usuários cadastrados com plano Premium (id_plano = 1)
SELECT nome, email
FROM usuarios
WHERE id_plano = 1
ORDER BY nome;

-- 10. Contar quantos conteúdos existem por gênero
SELECT genero, COUNT(*) AS total_titulos
FROM catalogo
GROUP BY genero
ORDER BY total_titulos DESC;


-- ============================================================
-- PARTE 2: CONSULTAS COM JOIN 
-- ============================================================

-- 1. Listar usuários com o nome do plano que possuem
SELECT u.nome, u.email, p.tipo_plano, p.valor, p.tipo_pagamento
FROM usuarios u
INNER JOIN planos p ON u.id_plano = p.id_plano
ORDER BY p.tipo_plano, u.nome;

-- 2. Listar histórico de visualizações com nome do usuário e título do conteúdo
SELECT u.nome AS usuario, c.titulo, c.tipo, h.data_visto
FROM historico_visualizacao h
INNER JOIN usuarios u ON h.id_usuario = u.id_usuario
INNER JOIN catalogo c ON h.id_item = c.id_item
ORDER BY h.data_visto DESC;

-- 3. Listar favoritos de cada usuário com título e gênero
SELECT u.nome AS usuario, c.titulo, c.genero, c.tipo
FROM favoritos f
INNER JOIN usuarios u ON f.id_usuario = u.id_usuario
INNER JOIN catalogo c ON f.id_item = c.id_item
ORDER BY u.nome;

-- 4. Contar quantas visualizações cada usuário tem
SELECT u.nome, COUNT(h.id_historico) AS total_visualizacoes
FROM usuarios u
LEFT JOIN historico_visualizacao h ON u.id_usuario = h.id_usuario
GROUP BY u.id_usuario, u.nome
ORDER BY total_visualizacoes DESC;

-- 5. Listar conteúdos que nunca foram assistidos (sem histórico)
SELECT c.titulo, c.tipo, c.genero
FROM catalogo c
LEFT JOIN historico_visualizacao h ON c.id_item = h.id_item
WHERE h.id_historico IS NULL
ORDER BY c.titulo;

-- 6. Faturamento estimado por plano (usuários x valor)
SELECT p.tipo_plano, p.valor,
       COUNT(u.id_usuario) AS total_assinantes,
       (COUNT(u.id_usuario) * p.valor) AS faturamento_total
FROM planos p
LEFT JOIN usuarios u ON p.id_plano = u.id_plano
GROUP BY p.id_plano, p.tipo_plano, p.valor
ORDER BY faturamento_total DESC;

-- 7. Listar usuários com o total de itens nos favoritos
SELECT u.nome, COUNT(f.id_favorito) AS total_favoritos
FROM usuarios u
LEFT JOIN favoritos f ON u.id_usuario = f.id_usuario
GROUP BY u.id_usuario, u.nome
ORDER BY total_favoritos DESC;

-- 8. Conteúdos mais assistidos com nome do título e total de visualizações
SELECT c.titulo, c.tipo, c.genero, COUNT(h.id_historico) AS total_views
FROM catalogo c
LEFT JOIN historico_visualizacao h ON c.id_item = h.id_item
GROUP BY c.id_item, c.titulo, c.tipo, c.genero
ORDER BY total_views DESC
LIMIT 10;

-- 9. Listar usuários do plano Padrão com Anúncios e seus favoritos
SELECT u.nome, c.titulo AS favorito
FROM usuarios u
INNER JOIN planos p ON u.id_plano = p.id_plano
LEFT JOIN favoritos f ON u.id_usuario = f.id_usuario
LEFT JOIN catalogo c ON f.id_item = c.id_item
WHERE p.tipo_plano = 'Padrão com Anúncios'
ORDER BY u.nome;

-- 10. Histórico de visualização com classificação indicativa do conteúdo
SELECT u.nome, c.titulo, c.classificacao_indicativa, c.genero, h.data_visto
FROM historico_visualizacao h
INNER JOIN usuarios u ON h.id_usuario = u.id_usuario
INNER JOIN catalogo c ON h.id_item = c.id_item
ORDER BY h.data_visto DESC;


-- ============================================================
-- PARTE 3: CONSULTAS AVANÇADAS 
-- ============================================================

-- 1. Subquery: Usuários que assistiram mais conteúdos do que a média geral
SELECT u.nome, COUNT(h.id_historico) AS total_views
FROM usuarios u
INNER JOIN historico_visualizacao h ON u.id_usuario = h.id_usuario
GROUP BY u.id_usuario, u.nome
HAVING total_views > (
    SELECT AVG(contagem) FROM (
        SELECT COUNT(*) AS contagem
        FROM historico_visualizacao
        GROUP BY id_usuario
    ) AS sub
)
ORDER BY total_views DESC;

-- 2. Ranking de gêneros mais assistidos com percentual do total
SELECT 
    c.genero,
    COUNT(h.id_historico) AS total_views,
    ROUND(COUNT(h.id_historico) * 100.0 / (SELECT COUNT(*) FROM historico_visualizacao), 2) AS percentual
FROM catalogo c
INNER JOIN historico_visualizacao h ON c.id_item = h.id_item
GROUP BY c.genero
ORDER BY total_views DESC;

-- 3. Usuários que nunca assistiram nenhum conteúdo (subquery com NOT IN)
SELECT u.nome, u.email, p.tipo_plano
FROM usuarios u
INNER JOIN planos p ON u.id_plano = p.id_plano
WHERE u.id_usuario NOT IN (
    SELECT DISTINCT id_usuario FROM historico_visualizacao
)
ORDER BY u.nome;

-- 4. Conteúdos favoritos de usuários Premium que ainda não foram assistidos por eles
SELECT u.nome AS usuario, c.titulo AS favorito_nao_assistido
FROM favoritos f
INNER JOIN usuarios u ON f.id_usuario = u.id_usuario
INNER JOIN catalogo c ON f.id_item = c.id_item
WHERE u.id_plano = 1
  AND f.id_item NOT IN (
      SELECT h.id_item 
      FROM historico_visualizacao h 
      WHERE h.id_usuario = f.id_usuario
  )
ORDER BY u.nome;

-- 5. Relatório geral: plano, total de assinantes, total de visualizações e faturamento
SELECT 
    p.tipo_plano,
    p.valor AS valor_plano,
    COUNT(DISTINCT u.id_usuario) AS total_assinantes,
    COUNT(h.id_historico) AS total_visualizacoes,
    (COUNT(DISTINCT u.id_usuario) * p.valor) AS faturamento_estimado,
    ROUND(COUNT(h.id_historico) / NULLIF(COUNT(DISTINCT u.id_usuario), 0), 2) AS media_views_por_usuario
FROM planos p
LEFT JOIN usuarios u ON p.id_plano = u.id_plano
LEFT JOIN historico_visualizacao h ON u.id_usuario = h.id_usuario
GROUP BY p.id_plano, p.tipo_plano, p.valor
ORDER BY faturamento_estimado DESC;
