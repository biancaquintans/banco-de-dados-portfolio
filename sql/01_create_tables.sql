-- Tabela de Planos 
CREATE TABLE planos (
    id_plano INT PRIMARY KEY AUTO_INCREMENT,
    tipo_plano ENUM('Premium', 'Padrão', 'Padrão com Anúncios'),
    valor DECIMAL(10,2),
    tipo_pagamento VARCHAR(50)
);

-- Tabela de Usuários e Admins 
CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    cpf CHAR(11) UNIQUE,
    telefone VARCHAR(15),
    id_plano INT,
    FOREIGN KEY (id_plano) REFERENCES planos(id_plano)
);

-- Catálogo de Filmes e Séries
CREATE TABLE catalogo (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(150),
    classificacao_indicativa VARCHAR(10),
    tipo ENUM('Filme', 'Série'),
    duracao_ou_episodios INT,
    genero VARCHAR(50)
);


-- Tabela de Histórico 
CREATE TABLE historico_visualizacao (
    id_historico INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT,
    id_item INT,
    data_visto DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_item) REFERENCES catalogo(id_item)
);

-- Tabela de Favoritos 
CREATE TABLE favoritos (
    id_favorito INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT,
    id_item INT,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_item) REFERENCES catalogo(id_item)
);

-- Tabela de Logs
CREATE TABLE logs_sistema (
    id_log INT PRIMARY KEY AUTO_INCREMENT,
    descricao TEXT,
    data_evento DATETIME DEFAULT CURRENT_TIMESTAMP
);