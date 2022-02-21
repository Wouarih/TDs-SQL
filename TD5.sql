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


