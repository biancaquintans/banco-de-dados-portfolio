
-- PROCEDURES E TRIGGERS - db_streaming

-- ============================================================
-- TRIGGERS 
-- ============================================================

-- TRIGGER 1: Log automático ao cadastrar novo usuário
DELIMITER //
CREATE TRIGGER tr_log_novo_usuario
AFTER INSERT ON usuarios
FOR EACH ROW
BEGIN
    INSERT INTO logs_sistema (descricao) 
    VALUES (CONCAT('Novo usuário cadastrado: ', NEW.nome, ' | Email: ', NEW.email, ' | ID: ', NEW.id_usuario));
END //
DELIMITER ;


-- TRIGGER 2: Log automático ao deletar usuário (impede perda silenciosa de dados)
DELIMITER //
CREATE TRIGGER tr_log_exclusao_usuario
BEFORE DELETE ON usuarios
FOR EACH ROW
BEGIN
    INSERT INTO logs_sistema (descricao)
    VALUES (CONCAT('Usuário removido: ', OLD.nome, ' | Email: ', OLD.email, ' | ID: ', OLD.id_usuario));
END //
DELIMITER ;


-- TRIGGER 3: Log ao registrar uma visualização no histórico
DELIMITER //
CREATE TRIGGER tr_log_visualizacao
AFTER INSERT ON historico_visualizacao
FOR EACH ROW
BEGIN
    INSERT INTO logs_sistema (descricao)
    VALUES (CONCAT('Visualização registrada | Usuário ID: ', NEW.id_usuario, 
                   ' | Conteúdo ID: ', NEW.id_item, 
                   ' | Data: ', NEW.data_visto));
END //
DELIMITER ;


-- ============================================================
-- STORED PROCEDURES 
-- ============================================================

-- PROCEDURE 1: Cadastrar novo usuário validando se o plano existe
DELIMITER //
CREATE PROCEDURE sp_cadastrar_usuario(
    IN p_nome       VARCHAR(100),
    IN p_email      VARCHAR(100),
    IN p_cpf        CHAR(11),
    IN p_telefone   VARCHAR(15),
    IN p_id_plano   INT
)
BEGIN
    -- Verifica se o plano existe antes de inserir
    IF NOT EXISTS (SELECT 1 FROM planos WHERE id_plano = p_id_plano) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: plano informado não existe.';
    ELSE
        INSERT INTO usuarios (nome, email, cpf, telefone, id_plano)
        VALUES (p_nome, p_email, p_cpf, p_telefone, p_id_plano);
        SELECT LAST_INSERT_ID() AS novo_id_usuario;
    END IF;
END //
DELIMITER ;

-- Como usar:
-- CALL sp_cadastrar_usuario('Ana Paula', 'ana@email.com', '11122233344', '11999990000', 1);


-- PROCEDURE 2: Relatório de assinantes por plano
DELIMITER //
CREATE PROCEDURE sp_relatorio_assinantes()
BEGIN
    SELECT 
        p.tipo_plano,
        p.valor,
        p.tipo_pagamento,
        COUNT(u.id_usuario) AS total_assinantes,
        (COUNT(u.id_usuario) * p.valor) AS faturamento_estimado
    FROM planos p
    LEFT JOIN usuarios u ON p.id_plano = u.id_plano
    GROUP BY p.id_plano, p.tipo_plano, p.valor, p.tipo_pagamento
    ORDER BY faturamento_estimado DESC;
END //
DELIMITER ;

-- Como usar:
-- CALL sp_relatorio_assinantes();


-- PROCEDURE 3: Registrar visualização no histórico verificando se usuário e conteúdo existem
DELIMITER //
CREATE PROCEDURE sp_registrar_visualizacao(
    IN p_id_usuario INT,
    IN p_id_item    INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM usuarios WHERE id_usuario = p_id_usuario) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: usuário não encontrado.';
    ELSEIF NOT EXISTS (SELECT 1 FROM catalogo WHERE id_item = p_id_item) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: conteúdo não encontrado no catálogo.';
    ELSE
        INSERT INTO historico_visualizacao (id_usuario, id_item)
        VALUES (p_id_usuario, p_id_item);
        SELECT 'Visualização registrada com sucesso.' AS mensagem;
    END IF;
END //
DELIMITER ;

-- Como usar:
-- CALL sp_registrar_visualizacao(1, 3);

--CALL sp_cadastrar_usuario('Teste Silva', 'teste@email.com', '11111111111', '11999990000', 1);
--SELECT * FROM usuarios WHERE email = 'teste@email.com';


--SELECT * FROM logs_sistema;
