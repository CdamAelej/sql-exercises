--Zadanie 1
/*
W bazie danych TRPrzychodnia wybrać pacjentki (Nazwisko,imię ,pesel i dataurodzenia),
które miały skończone 80 lat w chwili przyjęcia przez diabetologoa w maju 2014.
Wynik uporządkować wedłg daty urodzenia pacjenta rosnąco.
*/
use TRPrzychodnia;

select P.Nazwisko, P.Imie, pesel, P.DataUrodzenia
from Pacjenci as P inner join Wizyty as W on P.IdPacjenta=W.IdPacjenta
				   inner join Lekarze as L on W.IdLekarza=L.IdLekarza
where DATEDIFF(year, P.DataUrodzenia, DataWizyty) >= 80 and
	  DataWizyty between '20140501' and '20140531' and
	  L.Idspecjalizacji = 6
order by DataUrodzenia asc


-- Zadanie 2
/*
W bazie TRUczelnia wybrać studentów(mężczyzn) (nazwisko,imie,pesel), którzy w roku 2015 mieli średnią ocen (zaokrągloną do 2 miejsc po przecinku) 3.82.
*/
use TRUczelnia;

select Nazwisko, Imie, Pesel
from Studenci as S inner join Oceny as O on S.IdStudenta=O.IdStudenta
where DataOceny between '20150101' and '20151231' and
	  CzyKobieta=0
group by Nazwisko, Imie, Pesel
having ROUND(avg(ocena), 2) = 3.82


-- Zadanie 3
/*
W bazie TRPrzychodnia wybrać lekarzy, którzy w dniach w których było co najmniej 300 wizyt osiągnęli łaczną opłatę za swoje wizyty ponad 250 000 PLN.
Wynik powinien zawierać nazwisko,imię, numer ewidencyjny lekarza oraz sumę opłat. 
Uporządkować malejąco według sumy opłat.
*/
use TRPrzychodnia;

with LiczbaWizyt as
(
	select DataWizyty from Wizyty
	group by DataWizyty
	having COUNT(DataWizyty)>299
	
)

select Nazwisko, Imie, NrEwid, SUM(W.Oplata) as Suma
from Lekarze as L inner join Wizyty as W on L.IdLekarza=W.IdLekarza
				  inner join LiczbaWizyt as LW on W.DataWizyty=LW.DataWizyty
group by Nazwisko, Imie, NrEwid
having SUM(W.Oplata) > 250000
order by Suma desc


-- Zadanie 4
/*
W bazie TRUczelnia wybrać studentki,
które w roku 2016 w rankingu średnich liczonych z co najmniej 20 wystawionych ocen miały 3 co do wielkości średnią w swojej grupie. 
W wyniku przedstawić; nazwisko,imie, pesel oraz średnia ocen. Wynik uporządkować malejąco według średniej.
*/
use TRUczelnia;

with NajWgrupie as
(
	select S.IdStudenta, IdGrupy, DENSE_RANK() over (partition by idgrupy order by avg(ocena) desc) as RK, AVG(ocena) as Srednia
	from Studenci as S inner join Oceny as O on S.IdStudenta=O.IdStudenta
	where DataOceny between '20160101' and '20161231' and
		CzyKobieta=1
	group by S.IdStudenta, IdGrupy
	having COUNT(ocena)>19
)

select Nazwisko, Imie, Pesel, Srednia
from Studenci as S inner join NajWgrupie as NW on S.IdStudenta=NW.IdStudenta
where RK=3
order by Srednia desc
