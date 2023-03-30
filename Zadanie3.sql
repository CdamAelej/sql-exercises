--D404 Celej Adam
------ Zadanie 1 agregacja
/*
W bazie danych TRPrzychodnia przygotować zestawienie zawierające następujące dane; nazwisko, imię i Pesel pacjenta
oraz liczbę wizyt danego pacjenta w II półroczu 2013.
W wyniku uwzględnić tylko tych pacjentów, którzy byli przynajmniej 3 razy u lekarza.
Wynik zapytania uporządkować malejąco według liczby wizyt
*/
use TRPrzychodnia;

select Nazwisko, Imie, Pesel, COUNT(W.IdPacjenta) as liczbaWizyt
from Pacjenci as P join  Wizyty as W on P.IdPacjenta=W.IdPacjenta
where DataWizyty between '20130701' and '20131231'
group by Nazwisko, Imie, Pesel
having COUNT(W.IdPacjenta)>2
order by COUNT(W.IdPacjenta) desc

------ Zadanie 2 agregacja
/*
W bazie danych TRUczelnia przygotować zestawienie zawierające następujące dane;
nazwę przedmiotu oraz liczbę ocen bardzo dobrych wystawionych studentkom w roku 2013 z tego przedmiotu.
Wynik uporządkować malejąco według liczby ocen.
*/
use TRUczelnia;

select Nazwa, count(Ocena) as liczbaOcen
from Przedmioty as P join Oceny as O on P.IdPrzedmiotu=O.IdPrzedmiotu
where Ocena=5 and DataOceny between '20130101' and '20131231'
group by Nazwa
order by count(Ocena) desc


-------- Zadanie 3 agregacja
/*
W bazie TRPrzychodnia napisać zapytanie, które zwróci dane pacjentek urodzonych po roku 1965;
nazwisko, imię i pesel, które w roku 2013 miały przynajmniej trzy wizyty u lekarza rodzinnego i przynajmniej 3 wizyty u innych specjalistów.
*/
use TRPrzychodnia;

select P.Nazwisko, P.Imie, Pesel
from Pacjenci as P join Wizyty as W on P.IdPacjenta=W.IdPacjenta
				   join Lekarze as L on W.IdLekarza=L.IdLekarza
				   join Specjalizacje as S on L.Idspecjalizacji=S.idspecjalizacji
where DataWizyty between '20130101' and '20131231' and 
	  P.CzyKobieta=1 and
	  YEAR(P.DataUrodzenia)>1965	  
group by P.Nazwisko, P.Imie, Pesel
having count(distinct L.Idspecjalizacji)>3 and
	   COUNT(case when L.Idspecjalizacji=1 then 1 end)>2
