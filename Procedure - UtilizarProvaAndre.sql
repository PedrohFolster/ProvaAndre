SET SQL_SAFE_UPDATES = 0;
DROP DATABASE IF EXISTS testesprova;
CREATE DATABASE testesprova;
USE testesprova;


CREATE TABLE IF NOT EXISTS Usuarios (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(50),
    Idade INT,
    Email VARCHAR(50)
);

INSERT INTO Usuarios (Nome, Idade, Email) VALUES
('Joao', 25, 'joao@email.com'),
('Maria', 30, 'maria@email.com'),
('Carlos', 22, 'carlos@email.com');

DELIMITER $$

CREATE PROCEDURE ListarUsuarios()
BEGIN
	SELECT *
    FROM Usuarios;
END $$

CREATE PROCEDURE InserirUsuario(IN novoNome VARCHAR(50), IN novaIdade int, IN novoEmail VARCHAR(150))
BEGIN
	INSERT INTO Usuarios (Nome, Idade, Email) VALUES
    (novoNome, novaIdade, novoEmail);
    
	SELECT *
    FROM Usuarios;
END $$

CREATE PROCEDURE AtualizarIdadeUsuario(IN novaIdade int, IN IdUsuario int)
BEGIN
	UPDATE Usuarios SET Idade = novaIdade WHERE ID = IdUsuario;  
    
	SELECT *
    FROM Usuarios;
END $$

CREATE PROCEDURE ExcluirUsuario(IN IdUsuario int)
BEGIN
	Delete FROM Usuarios WHERE ID = IdUsuario;  
    
	SELECT *
    FROM Usuarios;
END $$

CREATE PROCEDURE BuscarUsuariosPorIdade(IN buscarIdade int)
BEGIN
	SELECT *
    FROM Usuarios
    WHERE Idade >= buscarIdade;
END $$

CREATE PROCEDURE ContarUsuarios(OUT ContarUsuarios int)
BEGIN
	SELECT COUNT(ID) AS Quantidade_Usuarios
    FROM Usuarios;
END $$

CREATE PROCEDURE AtualizarEmailUsuarios(IN novoDominio VARCHAR(150))
BEGIN
    UPDATE Usuarios SET Email = CONCAT(SUBSTRING_INDEX(Email, '@', 1), '@', novoDominio);
    
	SELECT *
    FROM Usuarios;
END $$

CREATE PROCEDURE ModificarEmail(IN receberId INT, IN receberEmail VARCHAR(150))
BEGIN
    UPDATE Usuarios SET Email = receberEmail WHERE ID = receberId;
END $$

CREATE PROCEDURE ListarUsuariosComEmailsIguais()
BEGIN
SELECT Id, Nome, Idade, Email
FROM Usuarios
WHERE Email IN (
    SELECT Email
    FROM Usuarios
    GROUP BY Email
    HAVING COUNT(*) > 1
);
END $$

DELIMITER ;

CALL ListarUsuarios();
CALL InserirUsuario('Caruso', 30, 'caruso@gmail.com');
CALL AtualizarIdadeUsuario(28, 4);
CALL ExcluirUsuario(1);
CALL BuscarUsuariosPorIdade(26);
CALL ContarUsuarios(@contar);
CALL AtualizarEmailUsuarios('criancaEsperanca.com');
CALL ModificarEmail(2, 'Caruso@criancaEsperanca.com');
CALL ListarUsuariosComEmailsIguais();




-- FAZER VIEW
CREATE VIEW UsuariosDuplicados AS
SELECT Id, Nome, Idade, Email
FROM Usuarios
WHERE Email IN (
    SELECT Email
    FROM Usuarios
    GROUP BY Email
    HAVING COUNT(*) > 1
);

SELECT * FROM UsuariosDuplicados;