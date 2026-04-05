SET SQL_SAFE_UPDATES = 0;

-- 1. Atualizar valor do plano Premium (usando PK)
UPDATE planos 
SET valor = 59.90 
WHERE id_plano = 1;

-- 2. Alterar plano de um usuário (usando PK)
UPDATE usuarios 
SET id_plano = 2 
WHERE id_usuario = 1;

-- 3. Corrigir gênero de um item no catálogo (usando PK)
UPDATE catalogo 
SET genero = 'Ficção Científica e Aventura' 
WHERE id_item = 2;

-- 4. Atualizar telefone de um usuário via CPF
UPDATE usuarios 
SET telefone = '11988887777' 
WHERE cpf = '84736291504';

-- Confirma os updates
SELECT * FROM planos;
SELECT * FROM usuarios LIMIT 5;
SELECT * FROM catalogo WHERE id_item = 2;

-- 5. Insere um registro temporário para demonstrar o DELETE
INSERT INTO catalogo (titulo, classificacao_indicativa, tipo, duracao_ou_episodios, genero)
VALUES ('Filme Teste Delete', '12', 'Filme', 90, 'Ação');

-- Confirma que foi inserido
SELECT * FROM catalogo WHERE titulo = 'Filme Teste Delete';

-- 6. Deleta o registro temporário
DELETE FROM catalogo WHERE titulo = 'Filme Teste Delete';

-- Confirma que foi removido (deve retornar vazio)
SELECT * FROM catalogo WHERE titulo = 'Filme Teste Delete';

-- 7. Limpar histórico anterior a uma data
DELETE FROM historico_visualizacao 
WHERE data_visto < '2024-01-01 00:00:00';

-- 8. Remover item dos favoritos
DELETE FROM favoritos 
WHERE id_usuario = 1 AND id_item = 2;

-- Confirma
SELECT * FROM favoritos WHERE id_usuario = 1;

SET SQL_SAFE_UPDATES = 1;