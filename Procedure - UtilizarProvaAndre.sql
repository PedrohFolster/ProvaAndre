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

DELIMITER ;

CALL ListarUsuarios();
CALL InserirUsuario('Caruso', 30, 'Caruso@gmail.com');
CALL AtualizarIdadeUsuario(28, 4);
CALL ExcluirUsuario(3);
CALL BuscarUsuariosPorIdade(26);
CALL ContarUsuarios(@contar);