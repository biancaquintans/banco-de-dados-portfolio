
-- 1. Garantir que o valor do plano seja sempre maior que zero
ALTER TABLE planos 
ADD CONSTRAINT chk_valor_positivo CHECK (valor > 0);

-- 2. Garantir que a classificação indicativa não seja vazia
ALTER TABLE catalogo 
MODIFY COLUMN classificacao_indicativa VARCHAR(10) NOT NULL;

-- 3. Garantir que o e-mail do usuário sempre tenha um formato básico (opcional/avançado)
ALTER TABLE usuarios 
ADD CONSTRAINT chk_email_valido CHECK (email LIKE '%@%');