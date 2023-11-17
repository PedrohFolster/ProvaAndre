DROP DATABASE IF EXISTS DBFUNCAO;
CREATE DATABASE DBFUNCAO;
USE DBFUNCAO;
-- EXERCÍCIO 1
DROP FUNCTION IF EXISTS FN_ADICAO;
DELIMITER $$
CREATE FUNCTION FN_ADICAO(NUMERO_A INT, NUMERO_B INT) RETURNS INT
BEGIN
	DECLARE RESULTADO INT;
	SET RESULTADO = NUMERO_A + NUMERO_B;

	RETURN RESULTADO;
END $$
DELIMITER ;

-- EXERCÍCIO 2
DROP FUNCTION IF EXISTS FN_SUBTRACAO;
DELIMITER $$
CREATE FUNCTION FN_SUBTRACAO(NUMERO_A INT, NUMERO_B INT) RETURNS INT
BEGIN
	DECLARE RESULTADO INT;
	SET RESULTADO = NUMERO_A - NUMERO_B;

	RETURN RESULTADO;
END $$
DELIMITER ;

-- EXERCÍCIO 3
DELIMITER $$

CREATE FUNCTION FN_MULTIPLICACAO(NUMERO_A INT, NUMERO_B INT) RETURNS INT
BEGIN
	DECLARE RESULTADO INT;
	SET RESULTADO = NUMERO_A * NUMERO_B;

	RETURN RESULTADO;
END $$
DELIMITER ;

-- EXERCÍCIO 4
DROP FUNCTION IF EXISTS FN_DIVISAO;
DELIMITER $$
CREATE FUNCTION FN_DIVISAO(NUMERO_A INT, NUMERO_B INT) RETURNS NUMERIC(8,2)
BEGIN
	DECLARE RESULTADO NUMERIC(8,2);
	SET RESULTADO = NUMERO_A / NUMERO_B;

	RETURN RESULTADO;
END $$
DELIMITER ;

-- EXERCÍCIO 5
DROP FUNCTION IF EXISTS FN_CALCULADORA;
DELIMITER $$
CREATE FUNCTION FN_CALCULADORA(NUMERO_A INT, NUMERO_B INT, OPERADOR CHAR(1)) RETURNS NUMERIC(8,2)
BEGIN
	DECLARE RESULTADO NUMERIC(8,2);

	CASE OPERADOR 
		WHEN '+' THEN SET RESULTADO = FN_ADICAO(NUMERO_A,NUMERO_B);
		WHEN '-' THEN SET RESULTADO = FN_SUBTRACAO(NUMERO_A,NUMERO_B);
		WHEN '*' THEN SET RESULTADO = FN_MULTIPLICACAO(NUMERO_A,NUMERO_B);
		WHEN '/' THEN SET RESULTADO = FN_DIVISAO(NUMERO_A,NUMERO_B);
	END CASE;

	RETURN RESULTADO;
END $$
DELIMITER ;

-- EXERCÍCIO 6
DROP FUNCTION IF EXISTS FN_PRIMO;
DELIMITER $$
CREATE FUNCTION FN_PRIMO(NUMERO INT) RETURNS CHAR(3)
BEGIN
	DECLARE RESULTADO CHAR(3);
	DECLARE CONTADOR INT;

	SET CONTADOR = NUMERO - 1;
	SET RESULTADO = 'SIM';
	
	WHILE ((CONTADOR > 1)AND(RESULTADO = 'SIM')) DO

		IF ((NUMERO % CONTADOR) = 0) THEN
			SET RESULTADO = 'NÃO';
		END IF;

		SET CONTADOR = CONTADOR - 1;

	END WHILE;

	RETURN RESULTADO;
END $$
DELIMITER ;

-- EXERCÍCIO 7
DROP FUNCTION IF EXISTS FN_IDADE;
DELIMITER $$
CREATE FUNCTION FN_IDADE(DT_NASCIMENTO DATE) RETURNS INT
BEGIN
	DECLARE IDADE INT;

	SET IDADE = YEAR(NOW()) - YEAR(DT_NASCIMENTO);

	IF DATE_ADD(DT_NASCIMENTO, INTERVAL IDADE YEAR) > NOW() THEN
		SET IDADE = IDADE - 1;
	END IF;

	RETURN IDADE;
END $$
DELIMITER ;


-- EXERCÍCIO 8
DROP FUNCTION IF EXISTS FN_NIVER;
DELIMITER $$
CREATE FUNCTION FN_NIVER(DT_NASCIMENTO DATE) RETURNS DATE
BEGIN
	DECLARE NIVER DATE;
	DECLARE QTDE INT;

	SET QTDE = YEAR(NOW()) - YEAR(DT_NASCIMENTO);
	SET NIVER = DATE_ADD(DT_NASCIMENTO, INTERVAL QTDE YEAR);

	IF NIVER < NOW() THEN
		SET NIVER = DATE_ADD(NIVER, INTERVAL 1 YEAR);
	END IF;
	
	RETURN NIVER;
END $$
DELIMITER ;

-- EXERCÍCIO 9
DROP FUNCTION IF EXISTS FN_ROMANO;
DELIMITER $$
CREATE FUNCTION FN_ROMANO(NUMERO INT) RETURNS TEXT
BEGIN
/*
   1 = I
   5 = V
  10 = X
  50 = L
 100 = C
 500 = D
1000 = M

*/
	DECLARE NUMEROROMANO TEXT;
	SET NUMEROROMANO = '';

	WHILE (NUMERO > 0) DO

		IF(NUMERO >= 1 AND NUMERO <= 3) THEN
			SET NUMEROROMANO = CONCAT(NUMEROROMANO, 'I');
			SET NUMERO = NUMERO - 1;
		ELSEIF(NUMERO = 4) THEN
			SET NUMEROROMANO = CONCAT(NUMEROROMANO, 'IV');
			SET NUMERO = NUMERO - 4;
		ELSEIF(NUMERO >= 5 AND NUMERO < 9) THEN
			SET NUMEROROMANO = CONCAT(NUMEROROMANO, 'V');
			SET NUMERO = NUMERO - 5;
		ELSEIF(NUMERO = 9) THEN
			SET NUMEROROMANO = CONCAT(NUMEROROMANO, 'IX');
			SET NUMERO = NUMERO - 9;
		ELSEIF(NUMERO >= 10 AND NUMERO < 40) THEN
			SET NUMEROROMANO = CONCAT(NUMEROROMANO, 'X');
			SET NUMERO = NUMERO - 10;
		ELSEIF(NUMERO >= 40 AND NUMERO < 50) THEN
			SET NUMEROROMANO = CONCAT(NUMEROROMANO, 'XL');
			SET NUMERO = NUMERO - 40;
		ELSEIF(NUMERO >= 50 AND NUMERO < 90) THEN
			SET NUMEROROMANO = CONCAT(NUMEROROMANO, 'L');
			SET NUMERO = NUMERO - 50;
		ELSEIF(NUMERO >= 90 AND NUMERO < 100) THEN
			SET NUMEROROMANO = CONCAT(NUMEROROMANO, 'XC');
			SET NUMERO = NUMERO - 90;
		ELSEIF(NUMERO >= 100 AND NUMERO < 400) THEN
			SET NUMEROROMANO = CONCAT(NUMEROROMANO, 'C');
			SET NUMERO = NUMERO - 100;
		ELSEIF(NUMERO >= 400 AND NUMERO < 500) THEN
			SET NUMEROROMANO = CONCAT(NUMEROROMANO, 'CD');
			SET NUMERO = NUMERO - 400;
		ELSEIF(NUMERO >= 500 AND NUMERO < 900) THEN
			SET NUMEROROMANO = CONCAT(NUMEROROMANO, 'D');
			SET NUMERO = NUMERO - 500;
		ELSEIF(NUMERO >= 900 AND NUMERO < 1000) THEN
			SET NUMEROROMANO = CONCAT(NUMEROROMANO, 'CM');
			SET NUMERO = NUMERO - 900;
		ELSEIF(NUMERO >= 1000 AND NUMERO < 4000) THEN
			SET NUMEROROMANO = CONCAT(NUMEROROMANO, 'M');
			SET NUMERO = NUMERO - 1000;
		ELSE
			SET NUMEROROMANO = CONCAT('NUMERO NÃO PREVISTO (', NUMERO, ')');
			SET NUMERO = 0;
		END IF;
	END WHILE;

	RETURN NUMEROROMANO;

END $$
DELIMITER ;

SELECT FN_ROMANO(1986);

-- EXERCÍCIO 10
DROP FUNCTION IF EXISTS FN_EXTENSO;
DELIMITER $$
CREATE FUNCTION FN_EXTENSO(pVALOR  NUMERIC(17,2)) RETURNS TEXT
BEGIN
	-- VARIAVEL PARA VERIFICAR O GRUPO DA DIREITA PARA A ESQUERDA
    DECLARE vGRUPO INT DEFAULT 0;
    -- VARIAVEL PARA TRABALHAR COM O VALOR INFORMADO NO FORMATO TEXTO
    DECLARE vVALORTEXTO VARCHAR(100);
    -- VARIAVEL PARA TRABALHAR COM O VALOR DE CADA GRUPO
    DECLARE VALOR  NUMERIC(14,2);
    -- TEXT DO NUMERO
    DECLARE vTEXTO TEXT DEFAULT '';
    DECLARE EXTENSO TEXT DEFAULT '';
    -- RESULTADO
    DECLARE vRESULTADO TEXT DEFAULT '';

    -- TRANSFORMANDO O NUMERO EM TEXTO
    SET vVALORTEXTO = pVALOR;

    -- PERCORRENDO O VALOR
    WHILE (LENGTH(vVALORTEXTO) > 0 ) DO
 
        SET vGRUPO = vGRUPO + 1;
 
        IF vGRUPO = 1 THEN
            SET VALOR = REPLACE(RIGHT(vVALORTEXTO, 3), '.', '');
        ELSE
            SET VALOR = RIGHT(vVALORTEXTO, 3);
        END IF;

        WHILE (VALOR > 0) DO
            CASE 
                WHEN VALOR = 1 THEN
                    SET EXTENSO = 'UM';
                    SET VALOR = VALOR - 1;
                WHEN VALOR = 2 THEN 
                    SET EXTENSO = 'DOIS';
                    SET VALOR = VALOR - 2;
                WHEN VALOR = 3 THEN 
                    SET EXTENSO = 'TRES';
                    SET VALOR = VALOR - 3;
                WHEN VALOR = 4 THEN 
                    SET EXTENSO = 'QUATRO';
                    SET VALOR = VALOR - 4;
                WHEN VALOR = 5 THEN 
                    SET EXTENSO = 'CINCO';
                    SET VALOR = VALOR - 5;
                WHEN VALOR = 6 THEN 
                    SET EXTENSO = 'SEIS';
                    SET VALOR = VALOR - 6;
                WHEN VALOR = 7 THEN 
                    SET EXTENSO = 'SETE';
                    SET VALOR = VALOR - 7;
                WHEN VALOR = 8 THEN 
                    SET EXTENSO = 'OITO';
                    SET VALOR = VALOR - 8;
                WHEN VALOR = 9 THEN 
                    SET EXTENSO = 'NOVE';
                    SET VALOR = VALOR - 9;
                WHEN VALOR = 10 THEN 
                    SET EXTENSO = 'DEZ';
                    SET VALOR = VALOR - 10;
                WHEN VALOR = 11 THEN 
                    SET EXTENSO = 'ONZE';
                    SET VALOR = VALOR - 11;
                WHEN VALOR = 12 THEN 
                    SET EXTENSO = 'DOZE';
                    SET VALOR = VALOR - 12;
                WHEN VALOR = 13 THEN 
                    SET EXTENSO = 'TREZE';
                    SET VALOR = VALOR - 13;
                WHEN VALOR = 14 THEN 
                    SET EXTENSO = 'CATORZE';
                    SET VALOR = VALOR - 14;
                WHEN VALOR = 15 THEN 
                     SET EXTENSO = 'QUINZE';
                     SET VALOR = VALOR - 15;
                WHEN VALOR = 16 THEN 
                     SET EXTENSO = 'DEZESSEIS';
                     SET VALOR = VALOR - 16;
                WHEN VALOR = 17 THEN 
                     SET EXTENSO = 'DEZESSETE';
                     SET VALOR = VALOR - 17;
                WHEN VALOR = 18 THEN 
                     SET EXTENSO = 'DEZOITO';
                     SET VALOR = VALOR - 18;
                WHEN VALOR = 19 THEN 
                     SET EXTENSO = 'DEZENOVE';
                     SET VALOR = VALOR - 19;
                WHEN VALOR BETWEEN 20 AND 29 THEN 
                     SET EXTENSO = 'VINTE';
                     SET VALOR = VALOR - 20;
                WHEN VALOR BETWEEN 30 AND 39 THEN 
                     SET EXTENSO = 'TRINTA';
                     SET VALOR = VALOR - 30;
                WHEN VALOR BETWEEN 40 AND 49 THEN 
                     SET EXTENSO = 'QUARENTA';
                     SET VALOR = VALOR - 40;
                WHEN VALOR BETWEEN 50 AND 59 THEN 
                     SET EXTENSO = 'CINQUENTA';
                     SET VALOR = VALOR - 50;
                WHEN VALOR BETWEEN 60 AND 69 THEN 
                     SET EXTENSO = 'SESSENTA';
                     SET VALOR = VALOR - 60;
                WHEN VALOR BETWEEN 70 AND 79 THEN 
                     SET EXTENSO = 'SETENTA';
                     SET VALOR = VALOR - 70;
                WHEN VALOR BETWEEN 80 AND 89 THEN 
                     SET EXTENSO = 'OITENTA';
                     SET VALOR = VALOR - 80;
                WHEN VALOR BETWEEN 90 AND 99 THEN 
                     SET EXTENSO = 'NOVENTA';
                     SET VALOR = VALOR - 90;
                WHEN VALOR = 100 THEN 
                     SET EXTENSO = 'CEM';
                     SET VALOR = VALOR - 100;
                WHEN VALOR >= 100 AND VALOR < 200 THEN 
                     SET EXTENSO = 'CENTO';
                     SET VALOR = VALOR - 100;
                WHEN VALOR >= 200 AND VALOR < 300 THEN 
                     SET EXTENSO = 'DUZENTOS';
                     SET VALOR = VALOR - 200;
                WHEN VALOR >= 300 AND VALOR < 400 THEN 
                     SET EXTENSO = 'TREZENTOS';
                     SET VALOR = VALOR - 300;
                WHEN VALOR >= 400 AND VALOR < 500 THEN 
                     SET EXTENSO = 'QUATROCENTOS';
                     SET VALOR = VALOR - 400;
                WHEN VALOR >= 500 AND VALOR < 600 THEN 
                     SET EXTENSO = 'QUINHENTOS';
                     SET VALOR = VALOR - 500;
                WHEN VALOR >= 600 AND VALOR < 700 THEN 
                     SET EXTENSO = 'SEISCENTOS';
                     SET VALOR = VALOR - 600;
                WHEN VALOR >= 700 AND VALOR < 800 THEN 
                     SET EXTENSO = 'SETECENTOS';
                     SET VALOR = VALOR - 700;
                WHEN VALOR >= 800 AND VALOR < 900 THEN 
                     SET EXTENSO = 'OITOCENTOS';
                     SET VALOR = VALOR - 800;
                WHEN VALOR >= 900 AND VALOR < 1000 THEN 
                     SET EXTENSO = 'NOVECENTOS';
                     SET VALOR = VALOR - 900;
                ELSE
                     SET EXTENSO = 'ERRO';
                     SET VALOR = -1;
            END CASE;
               
            IF vTEXTO <> '' THEN
                SET vTEXTO = CONCAT(vTEXTO, ' E ');
            END IF;
            SET vTEXTO = CONCAT(vTEXTO, EXTENSO);

        END WHILE;

        CASE vGRUPO
            WHEN 1 THEN 

                SET VALOR = REPLACE(RIGHT(vVALORTEXTO, 3), '.', '');
                IF VALOR = 0 THEN
                    SET vTEXTO = CONCAT(vTEXTO, '');
                ELSEIF VALOR = 1 THEN
                    SET vTEXTO = CONCAT(vTEXTO, ' CENTAVO');
                ELSE
                    SET vTEXTO = CONCAT(vTEXTO, ' CENTAVOS');
                END IF;
 
            WHEN 2 THEN

                SET VALOR = REPLACE(RIGHT(vVALORTEXTO, 3), '.', '');
                IF VALOR = 0 THEN
                    SET vTEXTO = CONCAT(vTEXTO, '');
                ELSEIF VALOR = 1 THEN
                    SET vTEXTO = CONCAT(vTEXTO, ' REAL');
                ELSE
                    SET vTEXTO = CONCAT(vTEXTO, ' REAIS');
                END IF;

            WHEN 3 THEN SET vTEXTO = CONCAT(vTEXTO, ' MIL');
            WHEN 4 THEN

                SET VALOR = REPLACE(RIGHT(vVALORTEXTO, 3), '.', '');
                IF VALOR = 0 THEN
                    SET vTEXTO = CONCAT(vTEXTO, '');
                ELSEIF VALOR = 1 THEN
                    SET vTEXTO = CONCAT(vTEXTO, ' MILHÃO');
                ELSE
                    SET vTEXTO = CONCAT(vTEXTO, ' MILHÕES');
                END IF;

            WHEN 5 THEN 
                
                SET VALOR = REPLACE(RIGHT(vVALORTEXTO, 3), '.', '');
                IF VALOR = 0 THEN
                    SET vTEXTO = CONCAT(vTEXTO, '');
                ELSEIF VALOR = 1 THEN
                    SET vTEXTO = CONCAT(vTEXTO, ' BILHÃO');
                ELSE
                    SET vTEXTO = CONCAT(vTEXTO, ' BILHÕES');
                END IF;

            WHEN 6 THEN 
                
                SET VALOR = REPLACE(RIGHT(vVALORTEXTO, 3), '.', '');
                IF VALOR = 0 THEN
                    SET vTEXTO = CONCAT(vTEXTO, '');
                ELSEIF VALOR = 1 THEN
                    SET vTEXTO = CONCAT(vTEXTO, ' TRILHÃO');
                ELSE
                    SET vTEXTO = CONCAT(vTEXTO, ' TRILHÕES');
                END IF;

        END CASE;

        IF vRESULTADO <> '' THEN
            IF vGRUPO = 2 THEN
                SET vRESULTADO = CONCAT(' E ', vRESULTADO);
            ELSE
                SET vRESULTADO = CONCAT(' E ', vRESULTADO);
            END IF;
        END IF;

        SET vRESULTADO = CONCAT(vTEXTO, '', vRESULTADO);
        SET vTEXTO = '';
        SET vVALORTEXTO = TRIM(LEFT(vVALORTEXTO, LENGTH(vVALORTEXTO) - 3));

    END WHILE;

    RETURN vRESULTADO;

END $$
DELIMITER ;

SELECT FN_EXTENSO(999999999999999.99);




NOVECENTOS E NOVENTA E NOVE MIL E NOVECENTOS E NOVENTA E NOVE REAIS E NOVENTA E NOVE CENTAVOS
