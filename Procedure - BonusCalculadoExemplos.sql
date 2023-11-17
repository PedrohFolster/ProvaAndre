-- Desabilita a verificação segura de atualizações SQL
SET SQL_SAFE_UPDATES = 0;

-- Remove o banco de dados se ele existir
DROP DATABASE IF EXISTS falta;

-- Cria um novo banco de dados chamado falta
CREATE DATABASE falta;

-- Seleciona o banco de dados criado
USE falta;

-- Criação da tabela FUNCIONARIO
CREATE TABLE FUNCIONARIO (
    IDFUNCIONARIO INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    NOME VARCHAR(100),
    SALARIO NUMERIC(8,2),
    DT_CONTRATACAO DATE
);

-- Inserção de dados na tabela FUNCIONARIO
INSERT INTO FUNCIONARIO (NOME, SALARIO, DT_CONTRATACAO) VALUES
('João', 5000.00, '2022-01-01'),
('Maria', 6000.00, '2022-02-15'),
('Carlos', 4500.00, '2022-03-20');

-- Criação da tabela FALTA
CREATE TABLE FALTA (
    IDFALTA INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    IDFUNCIONARIO INT NOT NULL,
    DT_FALTA DATE,
    MOTIVO VARCHAR(255),
    FOREIGN KEY (IDFUNCIONARIO) REFERENCES FUNCIONARIO (IDFUNCIONARIO)
);

-- Criação da tabela BONUS
CREATE TABLE BONUS (
    IDBONUS INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    IDFUNCIONARIO INT NOT NULL,
    VALOR_BONUS NUMERIC(8,2),
    DT_CALCULO DATE,
    FOREIGN KEY (IDFUNCIONARIO) REFERENCES FUNCIONARIO (IDFUNCIONARIO)
);

-- Criação da tabela HISTORICO
CREATE TABLE HISTORICO (
    IDHISTORICO INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    IDFUNCIONARIO INT NOT NULL,
    EVENTO VARCHAR(255),
    DT_EVENTO DATE,
    FOREIGN KEY (IDFUNCIONARIO) REFERENCES FUNCIONARIO (IDFUNCIONARIO)
);

-- Procedure 1: AtualizarSalario
DELIMITER $$

CREATE PROCEDURE AtualizarSalario(
    IN p_IDFUNCIONARIO INT,
    IN p_NOVO_SALARIO NUMERIC(8,2)
)
BEGIN
    UPDATE FUNCIONARIO
    SET SALARIO = p_NOVO_SALARIO
    WHERE IDFUNCIONARIO = p_IDFUNCIONARIO;
END $$

DELIMITER ;

-- Procedure 2: RegistrarFalta
DELIMITER $$

CREATE PROCEDURE RegistrarFalta(
    IN p_IDFUNCIONARIO INT,
    IN p_DT_FALTA DATE,
    IN p_MOTIVO VARCHAR(255)
)
BEGIN
    INSERT INTO FALTA (IDFUNCIONARIO, DT_FALTA, MOTIVO)
    VALUES (p_IDFUNCIONARIO, p_DT_FALTA, p_MOTIVO);
END $$

DELIMITER ;

-- Procedure 3: CalculoBonus
DELIMITER $$


CREATE PROCEDURE CalculoBonus(
    IN p_IDFUNCIONARIO INT -- Parâmetro: ID do funcionário
)
BEGIN
    -- Declaração de variáveis
    DECLARE salario_funcionario NUMERIC(8,2); -- Variável para armazenar o salário do funcionário
    DECLARE anos_servico DECIMAL(5, 2); -- Variável para armazenar a diferença em anos de serviço
    DECLARE bonus_calculado NUMERIC(8,2); -- Variável para armazenar o valor do bônus calculado

    -- Obtém o salário e a diferença em anos de serviço do funcionário
    SELECT SALARIO, DATEDIFF(CURDATE(), DT_CONTRATACAO) / 365.25 INTO salario_funcionario, anos_servico
    FROM FUNCIONARIO
    WHERE IDFUNCIONARIO = p_IDFUNCIONARIO;

    -- Calcula o bônus usando a fórmula: Salário * Anos de serviço * Taxa fixa
    SET bonus_calculado = salario_funcionario * anos_servico * 0.1;

    -- Insere o bônus calculado na tabela BONUS junto com a data de cálculo
    INSERT INTO BONUS (IDFUNCIONARIO, VALOR_BONUS, DT_CALCULO)
    VALUES (p_IDFUNCIONARIO, bonus_calculado, CURDATE());

    -- Adiciona um registro no histórico quando o bônus é calculado, incluindo o valor do bônus
    INSERT INTO HISTORICO (IDFUNCIONARIO, EVENTO, DT_EVENTO)
    VALUES (p_IDFUNCIONARIO, CONCAT('Bônus Calculado: ', bonus_calculado), CURDATE());
END $$

DELIMITER ;

-- Procedure 4: RemoverFuncionario
DELIMITER $$

CREATE PROCEDURE RemoverFuncionario(
    IN p_IDFUNCIONARIO INT
)
BEGIN
    DELETE FROM FALTA WHERE IDFUNCIONARIO = p_IDFUNCIONARIO;
    DELETE FROM BONUS WHERE IDFUNCIONARIO = p_IDFUNCIONARIO;
    DELETE FROM HISTORICO WHERE IDFUNCIONARIO = p_IDFUNCIONARIO;
    DELETE FROM FUNCIONARIO WHERE IDFUNCIONARIO = p_IDFUNCIONARIO;
END $$

DELIMITER ;

-- Procedure 5: VisualizarHistorico
DELIMITER $$

CREATE PROCEDURE VisualizarHistorico(
    IN p_IDFUNCIONARIO INT
)
BEGIN
    -- Seleciona o histórico para o funcionário específico
    SELECT * FROM HISTORICO
    WHERE IDFUNCIONARIO = p_IDFUNCIONARIO;
END $$

DELIMITER ;

SELECT * FROM FUNCIONARIO;

-- Chamadas das Procedures
-- Call Procedure 1: AtualizarSalario
CALL AtualizarSalario(1, 5500.00);

-- Call Procedure 2: RegistrarFalta
CALL RegistrarFalta(2, '2023-11-17', 'Falta justificada');

SELECT * FROM FALTA;

-- Call Procedure 3: CalculoBonus
CALL CalculoBonus(3);

SELECT * FROM FUNCIONARIO;

-- Call Procedure 4: RemoverFuncionario
CALL RemoverFuncionario(1);

-- Select para visualização dos resultados
-- Exemplo: Selecionar todos os funcionários
SELECT * FROM FUNCIONARIO;

-- Select para visualização do histórico
-- Exemplo: Visualizar o histórico para o funcionário com ID 3
CALL VisualizarHistorico(3);
