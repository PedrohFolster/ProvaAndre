SET SQL_SAFE_UPDATES = 0;
DROP DATABASE IF EXISTS DBPEDIDO;
CREATE DATABASE DBPEDIDO;
USE DBPEDIDO;

CREATE TABLE PRODUTO (
    IDPRODUTO INT NOT NULL AUTO_INCREMENT,
    NOME VARCHAR(45),
    ESTOQUE INT,
    PRIMARY KEY (IDPRODUTO)
);

CREATE TABLE COMPRA (
    IDCOMPRA INT NOT NULL AUTO_INCREMENT,
    IDPRODUTO INT NOT NULL,
    QTDE INT,
    PRECOUNITARIO NUMERIC(8, 2),
    PRIMARY KEY (IDCOMPRA),
    FOREIGN KEY (IDPRODUTO) REFERENCES PRODUTO (IDPRODUTO)
);

CREATE TABLE VENDA (
    IDVENDA INT NOT NULL AUTO_INCREMENT,
    IDPRODUTO INT NOT NULL,
    QTDE INT,
    PRECOUNITARIO NUMERIC(8, 2),
    PRIMARY KEY (IDVENDA),
    FOREIGN KEY (IDPRODUTO) REFERENCES PRODUTO (IDPRODUTO)
);

DELIMITER $$

-- Questão 01: Adicionar ao estoque quando uma compra é feita
CREATE TRIGGER Adicionar_Estoque_A_I
AFTER INSERT ON COMPRA
FOR EACH ROW
BEGIN
    UPDATE PRODUTO
    SET ESTOQUE = ESTOQUE + NEW.QTDE
    WHERE IDPRODUTO = NEW.IDPRODUTO;
END;
$$

-- Questão 02: Subtrair do estoque quando uma venda é feita
CREATE TRIGGER Estoque_A_I
AFTER INSERT ON VENDA
FOR EACH ROW
BEGIN
    DECLARE estoque_atual INT;
    SELECT ESTOQUE INTO estoque_atual
    FROM PRODUTO
    WHERE IDPRODUTO = NEW.IDPRODUTO;

    IF estoque_atual >= NEW.QTDE THEN
        UPDATE PRODUTO
        SET ESTOQUE = ESTOQUE - NEW.QTDE
        WHERE IDPRODUTO = NEW.IDPRODUTO;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não há estoque suficiente para concluir a venda.';
    END IF;
END;
$$

-- Questão 03: Verificar estoque antes de excluir uma compra
CREATE TRIGGER Estoque_B_D
BEFORE DELETE ON COMPRA
FOR EACH ROW
BEGIN
    DECLARE estoque_disponivel INT;
    SELECT ESTOQUE
    INTO estoque_disponivel
    FROM PRODUTO
    WHERE IDPRODUTO = OLD.IDPRODUTO;

    IF estoque_disponivel < OLD.QTDE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é possível excluir o pedido de compra. Estoque insuficiente.';
    END IF;
END;
$$

-- Questão 04: Acrescentar ao estoque ao excluir uma venda
CREATE TRIGGER Estoque_A_D
AFTER DELETE ON VENDA
FOR EACH ROW
BEGIN
    UPDATE PRODUTO
    SET ESTOQUE = ESTOQUE + OLD.QTDE
    WHERE IDPRODUTO = OLD.IDPRODUTO;
END;
$$

-- Questão 06: Atualizar o estoque ao alterar uma compra
CREATE TRIGGER Atualizar_A_U
AFTER UPDATE ON COMPRA
FOR EACH ROW
BEGIN
    DECLARE estoque_atual INT;
    SELECT ESTOQUE INTO estoque_atual
    FROM PRODUTO
    WHERE IDPRODUTO = OLD.IDPRODUTO;

    IF NEW.IDPRODUTO != OLD.IDPRODUTO THEN
        IF estoque_atual >= OLD.QTDE THEN
            UPDATE PRODUTO
            SET ESTOQUE = ESTOQUE - OLD.QTDE
            WHERE IDPRODUTO = OLD.IDPRODUTO;

            UPDATE PRODUTO
            SET ESTOQUE = ESTOQUE + NEW.QTDE
            WHERE IDPRODUTO = NEW.IDPRODUTO;
        ELSE
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Não há estoque suficiente para transferir.';
        END IF;
    ELSE
        IF estoque_atual >= (NEW.QTDE - OLD.QTDE) THEN
            UPDATE PRODUTO
            SET ESTOQUE = ESTOQUE - (NEW.QTDE - OLD.QTDE)
            WHERE IDPRODUTO = OLD.IDPRODUTO;
        ELSE
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Não há estoque suficiente para a alteração.';
        END IF;
    END IF;
END;
$$

-- Questão 07: Verificar estoque antes de alterar uma venda
CREATE TRIGGER Alterar_B_U
BEFORE UPDATE ON VENDA
FOR EACH ROW
BEGIN
    DECLARE estoque_atual INT;
    SELECT ESTOQUE INTO estoque_atual
    FROM PRODUTO
    WHERE IDPRODUTO = OLD.IDPRODUTO;

    IF NEW.QTDE > (estoque_atual + OLD.QTDE) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não há estoque suficiente para a alteração.';
    END IF;
END;
$$

DELIMITER ;

-- Inserir um produto
INSERT INTO PRODUTO (NOME, ESTOQUE) VALUES ('Coca-Cola', 0);

-- Inserir uma compra associada ao produto
INSERT INTO COMPRA (IDPRODUTO, QTDE, PRECOUNITARIO) VALUES (1, 10, 10.00);

-- Inserir uma venda associada ao produto
INSERT INTO VENDA (IDPRODUTO, QTDE, PRECOUNITARIO) VALUES (1, 5, 12.00);

-- Consultar as tabelas antes das operações
SELECT * FROM PRODUTO;
SELECT * FROM COMPRA;
SELECT * FROM VENDA;

-- Tentar vender mais produtos do que está no estoque (deve falhar)
INSERT INTO VENDA (IDPRODUTO, QTDE, PRECOUNITARIO) VALUES (1, 10, 12.00);

-- Inserir o novo produto
INSERT INTO PRODUTO (NOME, ESTOQUE) VALUES ('Pepsi', 0);

-- Atualizar uma compra (transferência de estoque) (deve falhar)
UPDATE COMPRA SET IDPRODUTO = 2, QTDE = 15 WHERE IDCOMPRA = 1;

-- Tentar alterar uma compra para uma quantidade maior do que o estoque disponível (deve falhar)
UPDATE COMPRA SET QTDE = 100 WHERE IDCOMPRA = 1;

-- Atualizar uma venda (verificação de estoque) (deve falhar)
UPDATE VENDA SET QTDE = 3 WHERE IDVENDA = 1;

-- Consultar as tabelas após as operações
SELECT * FROM PRODUTO;
SELECT * FROM COMPRA;
SELECT * FROM VENDA;

-- Excluir uma venda (acrescentar ao estoque)
DELETE FROM VENDA WHERE IDVENDA = 1;

-- Excluir uma compra (verificação de estoque) (deve falhar)
DELETE FROM COMPRA WHERE IDCOMPRA = 1;

-- Consultar as tabelas após as exclusões
SELECT * FROM PRODUTO;
SELECT * FROM COMPRA;
SELECT * FROM VENDA;
