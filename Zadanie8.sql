--use TRLiga;

with LiczbaPunktow as
(
	select K.Nazwa + ' ' + C.Nazwa as klub, COUNT(IdGospodarza) + COUNT(IdGoscia) as LiczbaMeczow
	from Kluby as K inner join Mecze as M on K.IdKlubu=M.IdGoscia
					inner join Miasta as C on K.Idmiejscowosci=C.IdMiejscowosci
	group by K.Nazwa, C.Nazwa
)

with Gospodarze as
(
	select IdGospodarza, SUM(BramkiGospodarza) as strzelone, SUM(BramkiGoscia) as stracone
	from Mecze
	group by IdGospodarza
)

with Goscie as
(
	select IdGoscia, SUM(BramkiGoscia) as strzelone, SUM(BramkiGospodarza) as stracone
	from Mecze
	group by IdGoscia
)

with Bramki as
(
	select klub
	from LiczbaPunktow
)

--select K.Nazwa + ' ' + C.Nazwa, COUNT(M.Idgospodarza
--from Kluby as K inner join Miasta as C on K.Idmiejscowosci=C.IdMiejscowosci
