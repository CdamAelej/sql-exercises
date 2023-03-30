/*
W bazie danych TRPrzychodnia przygotować zestawienie zawierające następujące dane; nazwisko, imię i numer ewidencyjny lekarza oraz liczbę wizyt,
dla tych lekarzy, którzy w roku 2015 przyjęli w ramach wizyt co najmniej 50 różnych kobiet w wieku powyżej 75 lat.
Wynik uporządkować malejąco wg. liczby wizyt.
*/

use TRPrzychodnia;

select L.Nazwisko, L.Imie, NrEwid, count(distinct W.IdPacjenta) as ile
from Lekarze as L inner join Wizyty as W on W.IdLekarza=L.IdLekarza
				  inner join Pacjenci as P on W.IdPacjenta=P.IdPacjenta
where DATEDIFF(year, P.DataUrodzenia, '20220101') >= 75 and
	  P.CzyKobieta=1 and
	  DataWizyty between '20150101' and '20151231'
group by L.Nazwisko, L.Imie, NrEwid
having count(distinct W.IdPacjenta) >= 50
order by ile desc

/*
W bazie danych TRUczelnia przygotować zestawienie zawierające następujące dane;
nazwę przedmiotu oraz liczbę ocen niedostatecznych wystawionych studentkom w roku 2013 z tego przedmiotu.
Do obliczeń uwzględniamy tylko studentki, które w roku 2013 miały jedną z dwóch najwyższych średnich w swojej grupie szkoleniowe.
W zestawieniu pokazać tylko te przedmiotu z których wystawiono więcej niż trzy oceny niedostateczne.
*/

use TRUczelnia;

with najlepsze as
(
	select S.IdStudenta, IdGrupy, DENSE_RANK() over (partition by idgrupy order by avg(ocena) desc) as rk
	from Studenci as S inner join Oceny as O on S.IdStudenta=O.IdStudenta
	where DataOceny between '20130101' and '20131231'
	group by S.IdStudenta, IdGrupy
)
--select IdStudenta from najlepsze where RK in(1,2)
select P.Nazwa, COUNT(*) as ile2
from Przedmioty as P inner join Oceny as O on P.IdPrzedmiotu=O.IdPrzedmiotu
					 inner join Studenci as S on O.IdStudenta=S.IdStudenta
where O.DataOceny between '20130101' and '20131231' and
	  S.CzyKobieta=1 and
	  Ocena=2 and
	  S.IdStudenta in (select IdStudenta from najlepsze where RK in(1,2))
group by P.Nazwa
having COUNT(*)>3
