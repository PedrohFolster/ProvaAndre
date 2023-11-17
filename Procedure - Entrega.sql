SET SQL_SAFE_UPDATES = 0;
DROP DATABASE IF EXISTS DBESTACAO;
CREATE DATABASE DBESTACAO;
USE DBESTACAO;

CREATE TABLE TIPOSENSOR (
    IDTIPOSENSOR INT NOT NULL,
    TIPO VARCHAR(45),
    DESCRICAO VARCHAR(100),
    PRIMARY KEY (IDTIPOSENSOR)
);

CREATE TABLE ESTACAO (
    IDESTACAO INT NOT NULL,
    NOME VARCHAR(100),
    DESCRICAO VARCHAR(200),
    PRIMARY KEY (IDESTACAO)
);

CREATE TABLE SENSOR (
    IDSENSOR INT NOT NULL,
    IDTIPOSENSOR INT NOT NULL,
    IDESTACAO INT NOT NULL,
    DESCRICAO VARCHAR(45),
    LIMITE_INFERIOR DECIMAL(8,2),
    LIMITE_SUPERIOR DECIMAL(8,2),
    PRIMARY KEY (IDSENSOR),
    FOREIGN KEY (IDTIPOSENSOR) REFERENCES TIPOSENSOR (IDTIPOSENSOR),
    FOREIGN KEY (IDESTACAO) REFERENCES ESTACAO (IDESTACAO)
);

CREATE TABLE COLETA (
    IDCOLETA INT AUTO_INCREMENT,
    IDSENSOR INT,
    DHCOLETA DATETIME,
    VALOR DECIMAL(8,2),
    PRIMARY KEY (IDCOLETA),
    FOREIGN KEY (IDSENSOR) REFERENCES SENSOR (IDSENSOR)
);

CREATE TABLE ALERTA (
    IDALERTA INT NOT NULL AUTO_INCREMENT,
    IDSENSOR INT NOT NULL,
    DHALERTA DATETIME,
    DESCRICAO VARCHAR(100),
    LIDA CHAR(1),
    PRIMARY KEY (IDALERTA),
    FOREIGN KEY (IDSENSOR) REFERENCES SENSOR (IDSENSOR)
);

-- Inserir tipos de sensores
INSERT INTO TIPOSENSOR VALUES (1, 'Anemômetro', 'Anemômetro 01');
INSERT INTO TIPOSENSOR VALUES (2, 'Pluviômetro', 'Pluviômetro 01');
INSERT INTO TIPOSENSOR VALUES (3, 'Sensor de Umidade', 'Sensor de Umidade 01');
INSERT INTO TIPOSENSOR VALUES (4, 'Sensor Temperatura', 'Sensor Temperatura 01');
INSERT INTO TIPOSENSOR VALUES (5, 'Sensor de Pressão', 'Sensor de Pressão 01');
INSERT INTO TIPOSENSOR VALUES (6, 'Direção do Vento', 'Direção do Vento 01');

-- Inserir estações
INSERT INTO ESTACAO VALUES (1, 'Estacao1', 'Estação Meteorológica 01');
INSERT INTO ESTACAO VALUES (2, 'Estacao2', 'Estação Meteorológica 02');

-- Inserir sensores
INSERT INTO SENSOR VALUES (1, 1, 1, 'Anemômetro 01', NULL, NULL);
INSERT INTO SENSOR VALUES (2, 2, 2, 'Pluviômetro 01', NULL, NULL);

-- Procedimento para calcular outliers
DELIMITER $$

CREATE PROCEDURE CALCULAR_OUTLIERS()
BEGIN
    DECLARE sensor_id INT;
    DECLARE media DECIMAL(8,2);
    DECLARE desvio_padrao DECIMAL(8,2);
    DECLARE limite_inferior DECIMAL(8,2);
    DECLARE limite_superior DECIMAL(8,2);

    -- Cursor para percorrer todos os sensores
    DECLARE sensor_cursor CURSOR FOR SELECT IDSENSOR FROM SENSOR;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET sensor_id = NULL;

    OPEN sensor_cursor;

    -- Loop através de todos os sensores
    sensor_loop: LOOP
        FETCH sensor_cursor INTO sensor_id;
        IF sensor_id IS NULL THEN
            LEAVE sensor_loop;
        END IF;

        -- Verificar se há dados suficientes para calcular a média e o desvio padrão
        SELECT AVG(VALOR), STDDEV(VALOR)
        INTO media, desvio_padrao
        FROM COLETA
        WHERE IDSENSOR = sensor_id
        HAVING COUNT(*) > 1;

        IF media IS NOT NULL AND desvio_padrao IS NOT NULL THEN
            -- Cálculo dos limites inferior e superior
            SET limite_inferior = media - (3 * desvio_padrao);
            SET limite_superior = media + (3 * desvio_padrao);

            -- Atualização dos limites na tabela SENSOR
            UPDATE SENSOR
            SET LIMITE_INFERIOR = limite_inferior, LIMITE_SUPERIOR = limite_superior
            WHERE IDSENSOR = sensor_id;
        END IF;
    END LOOP;

    CLOSE sensor_cursor;
END $$

CREATE TRIGGER TRG_INSERIR_ALERTA
AFTER INSERT ON COLETA
FOR EACH ROW
BEGIN
    DECLARE lim_superior DECIMAL(8,2);
    DECLARE lim_inferior DECIMAL(8,2);
    DECLARE descricao_alerta VARCHAR(100);

    -- Obtém os limites superior e inferior para o sensor da coleta
    SELECT LIMITE_SUPERIOR, LIMITE_INFERIOR
    INTO lim_superior, lim_inferior
    FROM SENSOR
    WHERE IDSENSOR = NEW.IDSENSOR;

    -- Verifica se o valor está acima do limite superior ou abaixo do limite inferior
    IF NEW.VALOR > lim_superior OR NEW.VALOR < lim_inferior THEN
        -- Cria uma mensagem amigável para o alerta
        SET descricao_alerta = CONCAT('Valor fora dos limites: ', NEW.VALOR);
        -- Insere o alerta na tabela ALERTA
        INSERT INTO ALERTA (IDSENSOR, DHALERTA, DESCRICAO, LIDA)
        VALUES (NEW.IDSENSOR, NOW(), descricao_alerta, 'N');
    END IF;
END $$

DELIMITER ;

-- Inserir coletas
INSERT INTO COLETA (IDSENSOR, DHCOLETA, VALOR) VALUES
    (1, NOW(), 20.0),
    (1, NOW(), 22.0),
    (1, NOW(), 21.5),
    (1, NOW(), 21.0),
    (1, NOW(), 23.0),
    (1, NOW(), 50.0), -- Valor atípico para teste
    (2, NOW(), 5.0),
    (2, NOW(), 4.5),
    (2, NOW(), 5.5),
    (2, NOW(), 5.2),
    (2, NOW(), 120.0); -- Valor atípico para teste
    

-- Consultas para visualizar os resultados
SELECT * FROM SENSOR;
SELECT * FROM COLETA;
CALL CALCULAR_OUTLIERS();
SELECT * FROM SENSOR;

INSERT INTO COLETA (IDSENSOR, DHCOLETA, VALOR) VALUES
(1, NOW(), 350.00),
(2, NOW(), 520.00);

SELECT * FROM ALERTA;