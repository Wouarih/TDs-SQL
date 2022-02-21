--TD4


--R5A
SELECT categorieService, COUNT(idService) AS nbService FROM Services
	GROUP BY categorieService;

--R5B

SELECT villeClient FROM Clients
	GROUP BY villeClient
	HAVING COUNT(idClient) > 2;

--R5C

SELECT nomCamping, AVG(salaireEmploye) AS salaireMoyen FROM Campings c
	JOIN Employes e ON c.idCamping = e.idCamping
	GROUP BY nomCamping;

--R5D

SELECT nomCamping FROM Campings c
	JOIN Employes e ON c.idCamping = e.idCamping
	GROUP BY nomCamping
	HAVING COUNT(idEmploye) > 3;

--R50

SELECT nomClient, prenomClient, COUNT(idLocation) as nbLocations FROM Clients c
	JOIN Locations l ON c.idClient = l.idClient
	GROUP BY nomClient, prenomClient
	ORDER BY nbLocations DESC;

--R51

SELECT nomCamping FROM Campings c
	JOIN Employes e ON c.idCamping = e.idCamping
	GROUP BY nomCamping
	HAVING AVG(salaireEmploye) > 1400;

--R52

SELECT nomClient, prenomClient FROM Clients c
	JOIN Locations l ON c.idClient = l.idClient
	JOIN Bungalows b ON l.idBungalow = b.idBungalow
		GROUP BY nomClient, prenomClient, l.idClient
		HAVING COUNT(DISTINCT idCamping) = 2;

--R53

SELECT nomBungalow, COUNT(idService) AS nbServices FROM Bungalows b
	LEFT JOIN Proposer p ON b.idBungalow = p.idBungalow
	GROUP BY nomBungalow, b.idBungalow
	ORDER BY nbServices DESC;

--R54

SELECT nomCamping FROM Campings c
	JOIN Bungalows b ON c.idCamping = b.idCamping
	WHERE superficieBungalow < 65
	GROUP BY nomCamping
	ORDER BY COUNT(idBungalow);
	

--R55

SELECT nomCamping FROM Campings c
	JOIN Employes e ON c.idCamping = e.idCamping
	GROUP BY nomCamping
	HAVING MIN(salaireEmploye) >= 1000;

--R56

SELECT nomBungalow FROM Bungalows b
	JOIN Proposer p ON b.idBungalow = p.idBungalow
	HAVING COUNT(idService) = (SELECT COUNT(idService) FROM Proposer p
									JOIN Bungalows b ON p.idBungalow = b.idBungalow
									WHERE nomBungalow ='Le Royal')
	GROUP BY nomBungalow;

--R57

SELECT nomBungalow, COUNT(idLocation) AS nbLocations FROM Bungalows b
	LEFT JOIN Locations l ON b.idBungalow = l.idBungalow
	JOIN Campings c ON b.idCamping = c.idCamping
		WHERE nomCamping ='La Décharge Monochrome'
		GROUP BY nomBungalow, b.idBungalow
		ORDER BY nbLocations DESC;

--R58

SELECT nomClient, prenomClient FROM Clients c
	JOIN Locations l ON c.idClient = l.idClient
	HAVING AVG(montantLocation) > 1100 AND COUNT(idLocation) >= 2
	GROUP BY nomClient, prenomClient, c.idClient;

--R59

SELECT nomBungalow FROM Bungalows b
	JOIN Proposer p ON b.idBungalow = p.idBungalow
	GROUP BY nomBungalow, b.idBungalow
	HAVING COUNT(*) = (
		SELECT MAX(COUNT(*)) FROM Proposer
		GROUP BY idBungalow); 

--R60

SELECT DISTINCT nomBungalow FROM Bungalows b
	JOIN Proposer p ON b.idBungalow = p.idBungalow
	JOIN Services s ON p.idService = s.idService
	JOIN Locations l ON b.idBungalow = l.idBungalow
		WHERE nomService = 'Kit de Bain';

--R61

SELECT nomBungalow FROM Bungalows b
	JOIN Locations l ON b.idBungalow = l.idBungalow
		

	

	


