-- Inserindo os Planos
INSERT INTO planos (tipo_plano, valor, tipo_pagamento) VALUES 
('Premium', 55.90, 'Cartão de Crédito'),
('Padrão', 39.90, 'PIX'),
('Padrão com Anúncios', 18.90, 'Boleto');

-- Inserindo Catálogo
INSERT INTO catalogo (titulo, classificacao_indicativa, tipo, duracao_ou_episodios, genero) VALUES 
('Stranger Things', '14', 'Série', 34, 'Ficção Científica'),
('Inception', '12', 'Filme', 148, 'Ação'),
('The Office', 'L', 'Série', 201, 'Comédia'),
('Interstellar', '10', 'Filme', 169, 'Ficção Científica');

-- Inserindo Usuários
INSERT INTO usuarios (nome, email, cpf, telefone, id_plano) VALUES 
('Lucas Souza', 'lucas@email.com', '12345678900', '11999999999', 1),
('João Silva', 'joao@email.com', '98765432100', '11888888888', 2);