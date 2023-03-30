--Dla roku 2015, przygotować w bazie TRUczelnia zestawienie które dla każdego miesiąca poda liczbę dni w których nie wystawiono żadnej oceny niedostatecznej.

--use TRUczelnia;

--SET LANGUAGE Polish;   

WITH miesiąc AS
(
    select 0 as numerMiesiaca
    union all
    select numerMiesiaca+1 
    from miesiąc
    where numerMiesiaca < 11
),
wykluczone as
(
    select DataOceny
    from oceny
    where ocena=2 and DataOceny between '20150101' and '20151231'
),
Daty as
(
    select cast('20150101' as date) as Dzien
    union all
    select dateadd(day,1,Dzien) as Dzien
    from Daty
    where Dzien<'20151231'
),
brakujace as
(
    select month(Dzien) as miesiac, count(*) as ileDni
    from Daty
    where Dzien not in (select DataOceny from wykluczone)
    group by month(Dzien)
    
)
select DATENAME(MONTH,DATEADD(MONTH,numerMiesiaca,'20150101')) AS miesiąc, numerMiesiaca+1 as numerMiesiaca, isnull(ileDni,0) as ileDni
from miesiąc as m left join brakujace on m.numerMiesiaca+1=brakujace.miesiac
option(maxrecursion 400)
