--TD2 Base de données

--R11

--Requete avec JOIN
SELECT nomEmploye, prenomEmploye FROM Employes e
	JOIN Campings c ON e.idCamping = c.idCamping
	WHERE nomCamping = 'Les Flots Bleus'
	ORDER BY salaireEmploye DESC;


--Requete avec EXISTS
SELECT nomEmploye, prenomEmploye FROM Employes e
	WHERE EXISTS (SELECT nomCamping FROM Campings c
					WHERE e.idCamping=c.idCamping
					AND nomCamping='Les Flots Bleus')
	ORDER BY salaireEmploye DESC;

--R12

--Requete avec JOIN
SELECT DISTINCT c.idClient, nomClient, prenomClient FROM Clients c
	JOIN Locations l ON c.idClient = l.idClient
	JOIN Bungalows bung ON l.idBungalow = bung.idBungalow
	JOIN Campings camp ON bung.idCamping = camp.idCamping
		WHERE villeCamping = 'Palavas';

--Requete avec EXISTS
SELECT DISTINCT c.idClient, nomClient, prenomClient FROM Clients c
	WHERE EXISTS (SELECT * FROM Locations l
					WHERE c.idClient = l.idClient
						AND EXISTS (SELECT * FROM Bungalows bung
										WHERE l.idBungalow=bung.idBungalow
											AND EXISTS (SELECT * FROM Campings camp
												WHERE bung.idCamping=camp.idCamping
													AND villeCamping = 'Palavas')));

--R13

--Requete avec JOIN
SELECT nomClient FROM Clients c
	JOIN Locations loc ON c.idClient = loc.idClient
	JOIN Bungalows bung ON loc.idBungalow = bung.idBungalow
		WHERE nomBungalow = 'Le Caniveau'
		ORDER BY nomClient;

--Requete avec EXISTS
SELECT nomClient FROM Clients c
	WHERE EXISTS (SELECT * FROM Locations loc
					WHERE c.idClient = loc.idClient
						AND EXISTS (SELECT * FROM Bungalows bung
										WHERE loc.idBungalow = bung.idBungalow
										AND nomBungalow = 'Le Caniveau'))
	ORDER BY nomClient;

--R14

SELECT nomClient, prenomClient FROM Clients c
	WHERE villeClient IN (SELECT villeCamping FROM Campings);

--R15

SELECT nomEmploye, prenomEmploye FROM Employes e
	WHERE idEmployeChef IN (SELECT idEmploye FROM Employes
							WHERE nomEmploye ='Alizan'
							AND prenomEmploye ='Gaspard');

--R16

SELECT DISTINCT c.idClient, c.nomClient, c.prenomClient FROM Clients c
	JOIN Locations l ON c.idClient = l.idClient
	JOIN Bungalows bung ON l.idBungalow = bung.idBungalow
	JOIN Campings camp ON bung.idCamping = camp.idCamping
		WHERE nomCamping = 'Les Flots Bleus'
			AND '14/07/2021' BETWEEN dateDebut AND dateFin;

--R17

SELECT DISTINCT c.nomClient, c.prenomClient FROM Clients c
	JOIN Locations l ON c.idClient = l.idClient
	JOIN Bungalows bung ON l.idBungalow = bung.idBungalow
	JOIN Campings camp ON bung.idCamping = camp.idCamping
		WHERE nomCamping = 'Les Flots Bleus'
			AND dateDebut <= '31/07/2021'
			AND dateFin >= '01/07/2021'

--R18

SELECT COUNT(serv.idService) AS NBDESERVICES FROM Services serv
	JOIN Proposer p ON serv.idService = p.idService
	JOIN Bungalows bung ON p.idBungalow = bung.idBungalow
		WHERE nomBungalow = 'Le Titanic';

--R19

SELECT MAX(salaireEmploye) FROM Employes e
	JOIN Campings camp ON e.idCamping = camp.idCamping
		WHERE nomCamping = 'Les Flots Bleus';

--R20

SELECT COUNT(DISTINCT camp.idCamping) FROM Campings camp
	JOIN Bungalows bung ON camp.idCamping = bung.idCamping
	JOIN Locations loc ON bung.idBungalow = loc.idBungalow
	JOIN Clients c ON loc.idClient = c.idClient
		WHERE prenomClient = 'Agathe'
		AND nomClient = 'Zeblouse'

--R21

SELECT nomBungalow FROM Bungalows
	WHERE superficieBungalow =(SELECT MAX(superficieBungalow) FROM Bungalows);

--R22

SELECT nomEmploye, prenomEmploye FROM Employes e
	JOIN Campings camp ON e.idCamping = camp.idCamping
		WHERE salaireEmploye = (SELECT MIN(salaireEmploye) FROM Employes e
									JOIN Campings camp ON e.idCamping = camp.idCamping
										WHERE nomCamping = 'Les Flots Bleus')
		AND nomCamping = 'Les Flots Bleus';
		



	