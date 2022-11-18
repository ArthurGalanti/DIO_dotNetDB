-------------------------------------- CRIANDO TABELA
CREATE TABLE Enderecos (
Id int PRIMARY KEY IDENTITY(1,1) NOT NULL,
IdCliente int NULL,
Rua varchar(255) NULL,
Bairro varchar(255) NULL,
Cidade varchar(255) NULL,
Estado char(2) NULL)
ALTER TABLE Clientes
ADD PRIMARY KEY (Id)
ALTER TABLE Enderecos
ADD CONSTRAINT FK_Enderecos_Clientes 
FOREIGN KEY (IdCliente) REFERENCES Clientes(Id);

-------------------------------------- POPULANDO TABELA
INSERT INTO Enderecos VALUES (4, 'Rua Teste', 'Bairro Teste', 'Cidade Teste', 'SP')
SELECT * FROM Clientes WHERE Id = 4
SELECT * FROM Enderecos WHERE IdCliente = 4

-------------------------------------- FAZENDO INNER JOIN
SELECT *
FROM
	Clientes C
INNER JOIN Enderecos E ON C.Id  = E.IdCliente
WHERE C.Id = 4

-------------------------------------- ADICIONANDO PRIMARY KEY FORA DA CRIAÇÃO
ALTER TABLE Produtos
ADD CONSTRAINT PK_Produtos_Id PRIMARY KEY(Id)

-------------------------------------- ADICIONANDO CONSTRAINT UNIQUE E TESTANDO
ALTER TABLE Produtos
ADD CONSTRAINT UNQ_Produtos_Nome UNIQUE (Nome) 

INSERT INTO Produtos (Nome, Cor, Preco, Tamanho, Genero, DataCadastro)
VALUES ('Mountain Bike Socks, M', 'Cor', 10, 'G', 'M', GETDATE())

-------------------------------------- REMOVENDO LINHA
DELETE FROM Produtos WHERE Id = 47

-------------------------------------- ADICIONANDO CONSTRAINT CHECK e TESTANDO
ALTER TABLE Produtos
ADD CONSTRAINT CHK_Produtos_Genero CHECK (Genero = 'U' OR Genero = 'M' OR Genero = 'F')

INSERT INTO Produtos (Nome, Cor, Preco, Tamanho, Genero, DataCadastro)
VALUES ('Nome teste', 'Cor', 10, 'G', 'U', GETDATE())

-------------------------------------- ADICIONANDO CONSTRAINT DEFAULT e TESTANDO
ALTER TABLE Produtos
ADD CONSTRAINT DEF_Produtos_DataCadastro DEFAULT GETDATE() FOR DataCadastro

INSERT INTO Produtos (Nome, Cor, Preco, Tamanho, Genero)
VALUES ('Nome teste3', 'Cor', 10, 'G', 'U')

-------------------------------------- DROPANDO CONSTRAINT
ALTER TABLE Produtos
DROP CONSTRAINT UNQ_Produtos_Nome

-------------------------------------- STORED PROCEDURES DE INSERT
CREATE PROCEDURE InserirNovoProduto
@Nome varchar(255),
@Cor varchar(50),
@Preco decimal,
@Tamanho varchar(5),
@Genero char(1)
AS
INSERT INTO Produtos (Nome, Cor, Preco, Tamanho, Genero)
VALUES (@Nome, @Cor, @Preco, @Tamanho, @Genero)

-------------------------------------- CHAMANDO PROCEDURES
EXEC InserirNovoProduto
'Novo prod procedure',
'colorido',
50,
'G',
'U'
--OU
EXEC InserirNovoProduto
@Preco = 60,
@Nome = 'Novo prod procedure',
@Cor = '',
@Genero = 'U',
@Tamanho = 'G'

-------------------------------------- STORED PROCEDURES DE SELECT
CREATE PROCEDURE ObterProdutosPorTamanho
@TamanhoProduto VARCHAR(5)
AS
SELECT * FROM Produtos WHERE Tamanho = @TamanhoProduto

CREATE PROCEDURE ObterTodosProdutos
AS
SELECT * FROM Produtos

-------------------------------------- CHAMANDO PROCEDURE
EXEC ObterProdutosPorTamanho 'P'
EXEC ObterTodosProdutos

-------------------------------------- CRIANDO SCALAR FUNCTION (Nas functions é obrigatório ter retorno)
CREATE FUNCTION CalcularDesconto(@Preco DECIMAL(13,2), @Porcentagem INT)
RETURNS DECIMAL(13, 2)

BEGIN
	RETURN @Preco - (@Preco / 100) * @Porcentagem
END

-------------------------------------- CHAMANDO SCALR FUNCTION
SELECT
	Nome,
	Preco,
	dbo.CalcularDesconto(Preco,10) PrecoComDesconto
FROM Produtos WHERE Tamanho = 'M'