SET SQL_SAFE_UPDATES = 0;
DROP DATABASE IF EXISTS DBESTATISTICA;
CREATE DATABASE DBESTATISTICA;
USE DBESTATISTICA;

CREATE TABLE PESSOA (
	IDPESSOA INT NOT NULL PRIMARY KEY AUTO_INCREMENT
	, NOME VARCHAR(45)
	, SEXO CHAR(1)
);

CREATE TABLE ESTATISTICA (	
	HOMEM INT
	, MULHER INT
);

-- CRIANDO A LINHA NA TABELA ESTATISTICAS PARA ATUALIZAÇÃO DA QTDE DE PESSOAS

INSERT INTO ESTATISTICA VALUES (0,0);

DELIMITER $$

CREATE TRIGGER TR_PESSOA_AI AFTER INSERT ON PESSOA FOR EACH ROW
BEGIN 
	IF NEW.SEXO = 'F' THEN
		UPDATE ESTATISTICA SET MULHER = MULHER + 1;
    ELSEIF NEW.SEXO = 'M' THEN
		UPDATE ESTATISTICA SET HOMEM = HOMEM + 1;
	END IF;
END $$

CREATE TRIGGER TR_PESSOA_AD AFTER DELETE ON PESSOA FOR EACH ROW
BEGIN 
	IF OLD.SEXO = 'F' THEN
		UPDATE ESTATISTICA SET MULHER = MULHER - 1;
    ELSEIF OLD.SEXO = 'M' THEN
		UPDATE ESTATISTICA SET HOMEM = HOMEM - 1;
	END IF;
END $$

CREATE TRIGGER TR_PESSOA_AU AFTER UPDATE ON PESSOA FOR EACH ROW
BEGIN 
	IF OLD.SEXO = 'F' THEN
		UPDATE ESTATISTICA SET MULHER = MULHER - 1;
	ELSEIF OLD.SEXO = 'M' THEN
		UPDATE ESTATISTICA SET HOMEM = HOMEM - 1;
	END IF;
    
    -- CAMPO NOVO
    
    IF NEW.SEXO = 'F' THEN
		UPDATE ESTATISTICA SET MULHER = MULHER + 1;
	ELSEIF NEW.SEXO = 'M' THEN
		UPDATE ESTATISTICA SET HOMEM = HOMEM + 1;
	END IF;

END $$

CREATE TRIGGER TR_PESSOA_BI BEFORE INSERT ON PESSOA FOR EACH ROW
BEGIN 
	IF (NEW.SEXO NOT IN ('F', 'M')) OR (NEW.SEXO IS NULL) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Campo sexo é inválido';
	END IF;

END $$

DELIMITER ;

INSERT INTO PESSOA (NOME, SEXO) VALUES ('ANA', 'F');
INSERT INTO PESSOA (NOME, SEXO) VALUES ('JOAO', 'M');
INSERT INTO PESSOA (NOME, SEXO) VALUES ('CARLOS', 'J');

DELETE FROM PESSOA WHERE NOME = 'JOAO';

UPDATE PESSOA SET SEXO = 'M' WHERE NOME = 'ANA';

SELECT * FROM PESSOA;
SELECT * FROM ESTATISTICA;