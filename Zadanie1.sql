--Zdefiniować, w swoim schemacie, przykładowa tabelę.
--CREATE SCHEMA CdamAelej;

	CREATE TABLE CdamAelej.Osoby
		(
			IDosoby int Primary Key identity(1,1),
			Guid uniqueidentifier not null,
			Nazwisko varchar(80) not null,
			Imie varchar(80) not null,
			Pesel char(11) not null,
			DataUrodzenia date not null
		);
	
		CREATE TABLE CdamAelej.Ksiazki
		(
			IDksiazki int Primary Key identity(1,1),
			LiczbaStron int not null,
			AutorImie varchar(80) not null,
			AutorNazwisko varchar(80) not null,
			Tytul varchar(80) not null,
			RokWydania int not null,
			Gatunek varchar(80) not null,
			Cena int not null
		);
