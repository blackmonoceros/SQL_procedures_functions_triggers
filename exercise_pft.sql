--1
CREATE PROCEDURE InformacjeOKsiazkach
@NazwiskoAutora VARCHAR(100)
AS
BEGIN
SELECT K.Tytuł, A.Nazwisko, G.Nazwa_gatunku, E.Stan_egzemplarza
FROM Książki K
JOIN Autorzy A ON K.Id_autora = A.Id_autora
JOIN Książki_Gatunki KG ON K.Id_książki = KG.Id_książki
JOIN Gatunki G ON KG.Id_gatunku = G.Id_gatunku
JOIN Egzemplarze E ON K.Id_książki = E.Id_książki
WHERE A.Nazwisko = @NazwiskoAutora
END
-- wywołanie np:
-- EXEC InformacjeOKsiazkach 'nazwisko autora np. Kowalski'

--2
CREATE FUNCTION ObliczSredniaCenaEgzemplarzy (@Id_książki INT)
RETURNS MONEY
AS
BEGIN
DECLARE @SredniaCena MONEY;
SELECT @SredniaCena = AVG(Cena)
FROM Egzemplarze
WHERE Id_książki = @Id_książki;
RETURN @SredniaCena;
END;
-- wywołanie SELECT dbo.ObliczSredniaCenaEgzemplarzy(tutaj wpisujemy id_ksiazki) AS SredniaCena;
]


--3
CREATE TRIGGER UpdateCenaEgzemplarza
ON Egzemplarze
AFTER UPDATE
AS
BEGIN
IF UPDATE(Cena)
BEGIN
DECLARE @IdKsiazki INT
SELECT @IdKsiazki = IdKsiazki FROM inserted
-- Wywołanie funkcji z zadania 2
EXECUTE dbo.SredniaCenaEgzemplarzy @IdKsiazki;
END
END


--4
CREATE TRIGGER UpdateInformacjiAutora
ON Autorzy
AFTER UPDATE
AS
BEGIN
IF UPDATE(Nazwisko) OR UPDATE(Imie1) OR UPDATE(Imie2)
BEGIN
DECLARE @NazwiskoAutora NVARCHAR(50)
SELECT @NazwiskoAutora = Nazwisko FROM inserted
-- Wywołanie procedury z zadania 1
EXECUTE dbo.InformacjeOKsiazkach @NazwiskoAutora;
END
END
