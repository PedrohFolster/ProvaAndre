SET SQL_SAFE_UPDATES = 0;
DROP DATABASE IF EXISTS provaAndre;
CREATE DATABASE provaAndre;
USE provaAndre;

DELIMITER $$

CREATE PROCEDURE CalcularTotalDiasNoMes(IN p_ano INT, IN p_mes INT, OUT p_totalDias INT)
BEGIN
    DECLARE ultimoDia INT;

    SET ultimoDia = DAY(LAST_DAY(CONCAT(p_ano, '-', p_mes, '-01')));
    
    SET p_totalDias = ultimoDia;
END $$

DELIMITER ;

CALL CalcularTotalDiasNoMes(2023, 11, @totalDias);
SELECT @totalDias;