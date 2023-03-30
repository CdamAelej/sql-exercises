--use TRPrzychodnia;
/*
W bazie danych TRPrzychodnia, zrobić zestawienie wizyt z 22.04.2013, w których brali udział pacjenci urodzeni po roku 1987 a lekarz był kobietą.
W zestawieniu powinny się znajdować następujące dane: nazwisko i imię pacjenta, numer ewidencyjny lekarza oraz kwota opłaty za wizytę.
Wynik uporządkować według nazwiska pacjenta malejąco.
*/
select P.Nazwisko, P.imie, L.NrEwid, W.Oplata
from Pacjenci as P  
inner join Lekarze as L on L.IdLekarza=L.IdLekarza 
inner join Wizyty as W on W.IdWizyty=W.IdWizyty
where year(P.DataUrodzenia)>1987 and W.DataWizyty='20130422'
/*ORDER BY Nazwisko*/;

/*
W bazie danych TRPrzychodnia napisać zapytanie zwracające następujące dane: nazwisko, imię, pesel i płeć tych pacjentów,
którzy w pierwszym półroczu 2013 byli w diabetologa lub chirurga.
*/
select P.Nazwisko, P.Imie, P.Pesel, P.CzyKobieta, W.DataWizyty, L.Idspecjalizacji 
from Pacjenci as P
inner join Lekarze as L on L.IdLekarza=L.IdLekarza
inner join Wizyty as W on W.IdWizyty=W.IdWizyty
where L.Idspecjalizacji=6 or L.Idspecjalizacji=7 and W.DataWizyty between '20130101' and '20130630'*/

/*
W bazie danych TRPrzychodnia napisać zapytanie zwracające następujące dane: nazwisko i imię lekarza, nazwisko i imię pacjenta,
datę wizyty i kwotę opłaty za wizytę dla wizyt z marca 2013 w których lekarz był tej samej płci co pacjent i był od niego straszy.
Wynik uporządkować według daty wizyty rosnąco.
*/
select L.Nazwisko, L.Imie, P.Nazwisko, P.Imie, W.DataWizyty, W.Oplata
from Pacjenci as P
inner join Lekarze as L on L.IdLekarza=L.IdLekarza
inner join Wizyty as W on W.IdWizyty=W.IdWizyty
where L.CzyKobieta=P.CzyKobieta and L.DataUrodzenia>P.DataUrodzenia and W.DataWizyty between '20130301' and '20130330'
/*order by DataWizyty*/;
