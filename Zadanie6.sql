/*
W bazie danych TRPrzychodnia, zrobić zestawienie zawierające: nazwę specjalizacji, datę wizyty oraz nazwisko lekarza, imię i numer ewidencyjny,
który jako pierwszy w danej specjalizacji, w roku 2015 przekroczył łączną sumę opłat za wizyty 10000 (od początku roku).
*/
use TRPrzychodnia;

select NazwaSpecjalizacji, L.Nazwisko, L.Imie, NrEwid, SUM(oplata) as Suma, DENSE_RANK() over (partition by NazwaSpecjalizacji order by sum(oplata) desc) as RK
from Wizyty as W inner join Lekarze as L on W.IdLekarza=L.IdLekarza
				 inner join Specjalizacje as S on L.Idspecjalizacji=S.idspecjalizacji
where DataWizyty between '20150101' and '20150108'
group by NazwaSpecjalizacji, L.Nazwisko, L.Imie, NrEwid
order by Suma desc

/*
W bazie danych TRUczelnia wyszukać studentki, które w roku 2013 miały jedną z 10 najwyższych średnich ocen na uczelni
a jednocześnie nie miały najwyższej średniej w swojej grupie szkoleniowej
*/
use TRUczelnia;

with najlepsze as
(
	select S.IdStudenta as IdStudenta, DENSE_RANK() over ( order by avg(ocena) desc) as rk
	from Studenci as S inner join Oceny as O on S.IdStudenta=O.IdStudenta
	where DataOceny between '20130101' and '20131231' and
		  S.CzyKobieta=1
	group by S.IdStudenta
),

NajWgrupie as
(
	select S.IdStudenta, IdGrupy, DENSE_RANK() over (partition by idgrupy order by avg(ocena) desc) as RK
	from Studenci as S inner join Oceny as O on S.IdStudenta=O.IdStudenta
	where DataOceny between '20130101' and '20131231' and
		CzyKobieta=1
	group by S.IdStudenta, IdGrupy
)

select Nazwisko, Imie, pesel
from Studenci as S inner join najlepsze as N on S.IdStudenta=N.IdStudenta
				   inner join NajWgrupie as G on S.IdStudenta=G.IdStudenta
where  N.rk<11 and
	   G.RK <> 1
