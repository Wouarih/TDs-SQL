--TD5

--R70
--division

SELECT nomBungalow FROM Bungalows b
	JOIN Proposer p ON b.idBungalow = p.idBungalow
	GROUP BY nomBungalow
	HAVING COUNT(idService) = (SELECT COUNT(idService) FROM Services);

--division not exists

SELECT nomBungalow FROM Bungalows b
	WHERE NOT EXISTS (SELECT idService FROM Services
						MINUS
					SELECT idService FROM Proposer ea
					WHERE ea.idBungalow = b.idBungalow);

--R71

--division

SELECT nomBungalow FROM Bungalows b
	JOIN Proposer p ON b.idBungalow = p.idBungalow
	JOIN Services s ON p.idService = s.idService
	WHERE categorieService='Luxe'
	GROUP BY nomBungalow 
	HAVING COUNT(p.idService) = (SELECT COUNT(*) FROM Services
							WHERE categorieService ='Luxe');

--division not exists

SELECT nomBungalow FROM Bungalows b
	WHERE NOT EXISTS (SELECT idService FROM Services
						WHERE categorieService = 'Luxe'
						MINUS
					SELECT idService FROM Proposer ea
					WHERE ea.idBungalow = b.idBungalow);

--R72

--division

SELECT nomBungalow FROM Bungalows b
	JOIN Proposer p ON b.idBungalow = p.idBungalow
	WHERE idService IN (SELECT idService  FROM Proposer p
						JOIN Bungalows b ON p.idBungalow = b.idBungalow 
							WHERE nomBungalow='La Poubelle')
	GROUP BY nomBungalow
	HAVING COUNT(idService) = (SELECT COUNT(idService) FROM Proposer p
						JOIN Bungalows b ON p.idBungalow = b.idBungalow 
							WHERE nomBungalow='La Poubelle');

--division not exists

SELECT nomBungalow FROM Bungalows b
	WHERE NOT EXISTS (SELECT idService FROM Proposer p
		JOIN Bungalows b ON p.idBungalow = b.idBungalow
		WHERE nomBungalow = 'La Poubelle'
		MINUS
		SELECT idService FROM Proposer p
		WHERE p.idBungalow = b.idBungalow);

--R73

--division

SELECT nomClient FROM Clients c
	JOIN Locations l ON c.idClient = l.idClient
	JOIN Bungalows b ON l.idBungalow = b.idBungalow
	GROUP BY nomClient
	HAVING COUNT(DISTINCT idCamping) = (SELECT COUNT (DISTINCT idCamping) FROM Bungalows);

--division not exists(a réesayer)

SELECT nomClient FROM Clients c
	WHERE NOT EXISTS (SELECT l.idBungalow FROM Locations l
					JOIN Bungalows b ON l.idBungalow = b.idBungalow
					JOIN Campings camping ON b.idCamping = camping.idCamping
					MINUS 
					SELECT idBungalow FROM Locations l
					WHERE b.idCamping = camping.idCamping)

--R74


SELECT nomClient FROM Clients c
	WHERE NOT EXISTS (SELECT idBungalow FROM Locations l
		JOIN Clients c ON l.idClient = c.idClient
		WHERE nomClient ='Zeblouse'
			AND prenomClient='Agathe'
		MINUS
		SELECT idBungalow FROM Locations l
			WHERE l.idClient = c.idClient);

--R75

SELECT nomClient, prenomClient FROM Clients c
	WHERE NOT EXISTS (SELECT idCamping FROM Bungalows b
		JOIN Locations l ON b.idBungalow = l.idBungalow
		JOIN Clients c ON l.idClient = c.idClient
			WHERE nomClient ='Zeblouse'
			 AND prenomClient ='Agathe'
		MINUS 
		SELECT idCamping FROM Bungalows b
		JOIN Locations l ON b.idBungalow = l.idBungalow
			WHERE c.idClient=l.idClient)
	AND NOT EXISTS (SELECT idCamping FROM Bungalows b
		JOIN Locations l ON b.idBungalow = l.idBungalow
			WHERE c.idClient = l.idClient
		MINUS 
		SELECT idCamping FROM Bungalows b
		JOIN Locations l ON b.idBungalow = l.idBungalow
		JOIN Clients c ON l.idClient = c.idClient
			WHERE nomClient ='Zeblouse'
			 AND prenomClient ='Agathe');

--R80


SELECT idClient, nomClient, prenomClient FROM Clients c
	WHERE idClient NOT IN (SELECT idClient FROM Locations l
		JOIN Bungalows b ON l.idBungalow = b.idBungalow
		JOIN Campings camp ON b.idCamping = camp.idCamping
		WHERE villeCamping = 'Palavas');

--R81

SELECT DISTINCT nomService FROM Services s
	JOIN Proposer p ON s.idService = p.idService
	JOIN Bungalows b ON p.idBungalow = b.idBungalow
	WHERE superficieBungalow > 60
	GROUP BY nomService, s.idService
	HAVING COUNT(*) = (SELECT COUNT(*)
		FROM Bungalows b
		WHERE superficieBungalow > 60);

-- R81 NOT EXISTS

SELECT nomService FROM Services s
	WHERE NOT EXISTS (SELECT idBungalow
					FROM Bungalows
					WHERE superficieBungalow > 60
					MINUS
					SELECT idBungalow
					FROM Proposer p
					WHERE p.idService = s.idService);

--R82

SELECT nomService FROM Services	s
	JOIN Proposer p ON s.idService = p.idService
		WHERE idBungalow IN (SELECT idBungalow FROM Bungalows b
								JOIN Campings c ON b.idCamping = c.idCamping
								WHERE nomCamping = 'Les Flots Bleus'
							AND superficieBungalow = (SELECT MAX(superficieBungalow) 
								FROM Bungalows b
								JOIN Campings c ON b.idCamping = c.idCamping
									WHERE nomCamping = 'Les Flots Bleus'));

--R83

SELECT e.nomEmploye, e.prenomEmploye, COUNT(sub.idEmploye) AS nbSubordonnes
FROM Employes e
		JOIN Campings c ON e.idCamping = c.idCamping
		LEFT JOIN Employes sub ON sub.idEmployeChef = e.idEmploye 
WHERE nomCamping = 'La Décharge Monochrome'
GROUP BY e.nomEmploye, e.prenomEmploye, e.idEmploye;

--R84

SELECT nomCamping FROM Campings c
	WHERE NOT EXISTS (SELECT idBungalow
					FROM Bungalows b
					WHERE b.idCamping = c.idCamping
					MINUS
					SELECT idBungalow
					FROM Bungalows b
					WHERE superficieBungalow > 50);
	




			