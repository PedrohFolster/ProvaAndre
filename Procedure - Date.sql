-- Desabilita a verificação segura de atualizações SQL
SET SQL_SAFE_UPDATES = 0;

-- Remove o banco de dados se ele existir
DROP DATABASE IF EXISTS provaAndre;

-- Cria um novo banco de dados chamado provaAndre
CREATE DATABASE provaAndre;

-- Seleciona o banco de dados criado
USE provaAndre;

-- Altera o delimitador para '$$' para a criação de stored procedures
DELIMITER $$

-- Procedure para calcular o total de dias em um mês
CREATE PROCEDURE CalcularTotalDiasNoMes(IN p_ano INT, IN p_mes INT, OUT p_totalDias INT)
BEGIN
    -- Declaração de variáveis
    DECLARE ultimoDia INT;

    -- Calcula o último dia do mês usando a função LAST_DAY
    SET ultimoDia = DAY(LAST_DAY(CONCAT(p_ano, '-', p_mes, '-01')));
    
    -- Atribui o resultado à variável de saída
    SET p_totalDias = ultimoDia;
END $$

-- Procedure para calcular a diferença em dias entre duas datas
CREATE PROCEDURE CalcularDiferencaDias(IN dataInicio DATE, IN dataFim DATE, OUT diferencaDias INT)
BEGIN
    -- Usa a função DATEDIFF para calcular a diferença em dias
    SET diferencaDias = DATEDIFF(dataFim, dataInicio);
END $$

-- Procedure para adicionar dias a uma data
CREATE PROCEDURE AdicionarDias(IN dataOriginal DATE, IN diasParaAdicionar INT, OUT novaData DATE)
BEGIN
    -- Usa a função DATE_ADD para adicionar dias à data original
    SET novaData = DATE_ADD(dataOriginal, INTERVAL diasParaAdicionar DAY);
END $$

-- Procedure para verificar se uma data é um aniversário
CREATE PROCEDURE VerificarAniversario(IN dataNascimento DATE, IN dataVerificacao DATE, OUT ehAniversario BOOLEAN)
BEGIN
    -- Compara o dia e o mês da data de nascimento com a data de verificação
    SET ehAniversario = (DAY(dataNascimento) = DAY(dataVerificacao) AND MONTH(dataNascimento) = MONTH(dataVerificacao));
END $$

-- Procedure para obter a data atual
CREATE PROCEDURE ObterDataAtual(OUT dataAtual DATE)
BEGIN
    -- Obtém a data atual usando a função CURRENT_DATE
    SET dataAtual = CURRENT_DATE();
END $$

-- Procedure para calcular a idade a partir da data de nascimento
CREATE PROCEDURE CalcularIdade(IN dataNascimento DATE, OUT idade INT)
BEGIN
    -- Calcula a idade usando a função YEAR e comparação de meses e dias
    SET idade = YEAR(CURRENT_DATE()) - YEAR(dataNascimento) - (DATE_FORMAT(CURRENT_DATE(), '%m%d') < DATE_FORMAT(dataNascimento, '%m%d'));
END $$

-- Procedure para validar se uma data é válida
CREATE PROCEDURE ValidarData(IN dataAValidar DATE, OUT dataValida BOOLEAN)
BEGIN
    -- Utiliza um manipulador de exceções para tratar datas inválidas
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        SET dataValida = FALSE;

    -- Tenta selecionar a data, se não gerar uma exceção, a data é válida
    SET dataValida = TRUE;
    SELECT dataAValidar;
END $$

-- Procedure para concatenar datas e horas
CREATE PROCEDURE ConcatenarDatasHoras(IN data DATE, IN hora TIME, OUT dataHora DATETIME)
BEGIN
    -- Usa a função CONCAT para unir a data e a hora em um campo DATETIME
    SET dataHora = CONCAT(data, ' ', hora);
END $$

-- Procedure para calcular o fatorial de um número
CREATE PROCEDURE CalcularFatorial(IN numero INT, OUT resultado INT)
BEGIN
    -- Declaração de variáveis e loop para calcular o fatorial
    DECLARE i INT DEFAULT 1;
    SET resultado = 1;
    
    WHILE i <= numero DO
        SET resultado = resultado * i;
        SET i = i + 1;
    END WHILE;
END $$

-- Procedure para encontrar números primos até um determinado limite
CREATE PROCEDURE EncontrarPrimos(IN limite INT)
BEGIN
    -- Declaração de variáveis e loops para encontrar números primos
    DECLARE candidato INT;
    DECLARE divisor INT;
    DECLARE ehPrimo BOOLEAN;
    
    SET candidato = 2;
    
    -- Etiqueta de loop para facilitar a saída
    meu_loop: WHILE candidato <= limite DO
        SET ehPrimo = TRUE;
        SET divisor = 2;
        
        WHILE divisor < candidato DO
            IF candidato % divisor = 0 THEN
                SET ehPrimo = FALSE;
                -- Sai do loop externo se não for primo
                LEAVE meu_loop;
            END IF;
            
            SET divisor = divisor + 1;
        END WHILE;
        
        IF ehPrimo THEN
            SELECT candidato AS NumeroPrimo;
        END IF;
        
        SET candidato = candidato + 1;
    END WHILE;
END $$

-- Procedure para concatenar dois nomes
CREATE PROCEDURE ConcatenarNomes(IN nome1 VARCHAR(50), IN nome2 VARCHAR(50), OUT nomeConcatenado VARCHAR(100))
BEGIN
    -- Usa a função CONCAT para unir os dois nomes com um espaço
    SET nomeConcatenado = CONCAT(nome1, ' ', nome2);
END $$

-- Procedure para contar palavras em uma frase
CREATE PROCEDURE ContarPalavras(IN frase TEXT, OUT quantidadePalavras INT)
BEGIN
    -- Usa a função LENGTH e REPLACE para contar as palavras
    SET quantidadePalavras = LENGTH(frase) - LENGTH(REPLACE(frase, ' ', '')) + 1;
END $$

-- Procedure para verificar a existência de palavras em uma frase
CREATE PROCEDURE VerificarExistenciaPalavras(IN frase TEXT, IN palavra1 VARCHAR(50), IN palavra2 VARCHAR(50), OUT existePalavra1 BOOLEAN, OUT existePalavra2 BOOLEAN)
BEGIN
    -- Usa a função INSTR para verificar a presença de palavras na frase
    SET existePalavra1 = INSTR(frase, palavra1) > 0;
    SET existePalavra2 = INSTR(frase, palavra2) > 0;
END $$

-- Procedure para substituir palavras em uma frase
CREATE PROCEDURE SubstituirPalavras(INOUT fraseOriginal TEXT, IN palavraAntiga VARCHAR(50), IN palavraNova VARCHAR(50))
BEGIN
    -- Usa a função REPLACE para substituir palavras na frase original
    SET fraseOriginal = REPLACE(fraseOriginal, palavraAntiga, palavraNova);
END $$

-- Procedure para gerar uma senha aleatória
CREATE PROCEDURE GerarSenhaAleatoria(IN comprimento INT, OUT senha VARCHAR(50))
BEGIN
    -- Declaração de variáveis e loop para gerar a senha
    DECLARE caracteres VARCHAR(62) DEFAULT 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    SET senha = '';

    WHILE comprimento > 0 DO
        SET senha = CONCAT(senha, SUBSTRING(caracteres, FLOOR(1 + RAND() * 62), 1));
        SET comprimento = comprimento - 1;
    END WHILE;
END $$

-- Restaura o delimitador padrão
DELIMITER ;

-- Chamadas e Seleções para Testar as Stored Procedures

CALL CalcularTotalDiasNoMes(2023, 11, @totalDias);
SELECT @totalDias;

CALL CalcularDiferencaDias('2023-01-01', '2023-02-01', @diferenca);
SELECT @diferenca;

CALL AdicionarDias('2023-01-01', 5, @novaData);
SELECT @novaData;

CALL VerificarAniversario('1990-11-17', '2023-11-17', @aniversario);
SELECT @aniversario;

-- Chamadas e Seleções para Testar as Stored Procedures

-- Exemplo 5
CALL ObterDataAtual(@dataAtual5);
SELECT @dataAtual5;

-- Exemplo 6
CALL CalcularIdade('1990-11-17', @idade6);
SELECT @idade6;

-- Exemplo 7
CALL ValidarData('2023-02-28', @dataValida7);
SELECT @dataValida7;

-- Exemplo 8
CALL ConcatenarDatasHoras('2023-11-17', '12:30:00', @dataHora8);
SELECT @dataHora8;

-- Exemplo 9
CALL CalcularFatorial(5, @fatorial);
SELECT @fatorial;

-- Exemplo 10
CALL EncontrarPrimos(20);

-- Exemplo 11
CALL ConcatenarNomes('Maria', 'Silva', @nomeCompleto11);
SELECT @nomeCompleto11;

-- Exemplo 12
CALL ContarPalavras('Isso é um exemplo de contagem de palavras.', @qtdPalavras12);
SELECT @qtdPalavras12;

-- Exemplo 13
CALL VerificarExistenciaPalavras('Isso é um exemplo', 'exemplo', 'teste', @existeExemplo, @existeTeste);
SELECT @existeExemplo, @existeTeste;

-- Exemplo 14
SET @frase = 'Isso é um exemplo de substituição.';
CALL SubstituirPalavras(@frase, 'exemplo', 'teste');
SELECT @frase;

-- Exemplo 15
CALL GerarSenhaAleatoria(8, @senha);
SELECT @senha;