/*
W bazie danych TRPrzychodnia, zrobić zestawienie zawierające: nazwisko, imię, datę urodzenia oraz numer Pesel pacjentów w wieku ponad 65 lat( w momencie wizyty),
którzy w roku 2015 byli u co najmniej 3 różnych lekarzy rodzinnych. Wynik uporządkować malejąco według daty urodzenia.
*/
use TRPrzychodnia;

with LekarzeRodzinni as
(
	select * from Lekarze where Idspecjalizacji = 1
)


select P.Nazwisko, P.Imie, P.DataUrodzenia, P.Pesel
from Pacjenci as P inner join Wizyty as W on P.IdPacjenta=W.IdPacjenta
				   inner join Lekarze as L on W.IdLekarza=L.IdLekarza
where DATEDIFF(year, P.DataUrodzenia, DataWizyty)>64 and
	  DataWizyty between '20150101' and '20151231' and
	  L.Idspecjalizacji=1
group by P.Nazwisko, P.Imie, P.DataUrodzenia, P.Pesel
having count(distinct L.NrEwid)>2
order by P.DataUrodzenia desc



/*
W bazie TRUczelnia zrobić zestawienie wykładowców (nazwisko, imię NIP),
którzy studentom o dwóch najwyższych średnich ocen z roku 2015 w swoich grupach szkoleniowych,
wystawili (w roku 2015) co najmniej 2 oceny niedostateczne.
*/

use TRUczelnia;

with najlepsi as
(
	select S.IdStudenta, IdGrupy, DENSE_RANK() over (partition by idgrupy order by avg(ocena) desc) as rk
	from Studenci as S inner join Oceny as O on S.IdStudenta=O.IdStudenta
	where DataOceny between '20150101' and '20151231'
	group by S.IdStudenta, IdGrupy
)
select W.Nazwisko, W.Imie, W.Nip, COUNT(*) as ile2
from Wykladowcy as W inner join Oceny as O on W.IdWykladowcy=O.IdWykladowcy
					 inner join Studenci as S on O.IdStudenta=S.IdStudenta
where O.DataOceny between '20150101' and '20151231' and
	  Ocena=2 and
	  S.IdStudenta in (select IdStudenta from najlepsi where RK in(1,2))
group by W.Nazwisko, W.Imie, W.Nip
having COUNT(*)>1
