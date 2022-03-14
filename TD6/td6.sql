--GRANTS ON TO: Donne aux utilisateurs l'accès à une table, on peut donner un droit d'accès
--en DELETE, INSERT, UPDATE, SELECT (ALL pour selectionner les 4)

--REVOKE ON FROM : même fonctionnement mais retire l'accès aux utilisateurs

--CREATE (OR REPLACE) VIEW nomvue AS ...
--SELECT ...
--FROM
--Référence une requête, créer une table de façon virtuelle





--Première partie
--1

CREATE VIEW BungalowsLFB(idBungalow, nomBungalow, superficieBungalow) AS
	SELECT idBungalow, nomBungalow, superficieBungalow
	FROM Bungalows b
	JOIN Campings c ON b.idCamping = c.idCamping
	WHERE nomCamping = 'Les Flots Bleus';


SELECT COUNT(idBungalow) AS "NB Bungalows" FROM BungalowsLFB;

--2

CREATE VIEW LocationsLFB(idLocation, idClient, nomClient, prenomClient, idBungalow, nomBungalow) AS
	SELECT idLocation, l.idClient, nomClient, prenomClient, l.idBungalow, nomBungalow
	FROM Locations l
	JOIN Clients c ON l.idClient = c.idClient
	JOIN BungalowsLFB b ON l.idBungalow = b.idBungalow;


SELECT idBungalow, nomBungalow, COUNT(idLocation)
FROM LocationsLFB
GROUP BY idBungalow, nomBungalow;


--Deuxième partie
--3

CREATE VIEW EmployesSansCamping(idEmploye, nomEmploye, prenomEmploye, salaireEmploye, idEmployeChef) AS
	SELECT idEmploye, nomEmploye, prenomEmploye, salaireEmploye, idEmployeChef
	FROM Employes e 
	WHERE idCamping IS NULL;

SELECT * FROM EmployesSansCamping;

INSERT INTO EmployesSansCamping (idEmploye, nomEmploye, prenomEmploye, salaireEmploye) VALUES ('E100', Stiko, Judas, 3000);

UPDATE EmployesSansCamping SET nomEmploye = 'Nana' WHERE idEmploye='E100';

DELETE FROM EmployesSansCamping WHERE idEmploye='E100';


--4

CREATE VIEW EmployesAvecCamping(nomEmploye, prenomEmploye, salaireEmploye) AS
	SELECT nomEmploye, prenomEmploye, salaireEmploye
	FROM Employes e
	WHERE idCamping IS NOT NULL;

--Il n'est pas possible d'insérer de nouvelles lignes dans la table Employes à travers cette vue car il n'y a pas la clef primaire idEmploye
--Il est parcontre possible de modifier/suppression les lignes présentes dans la table Employe à travers la vue

INSERT INTO EmployesAvecCamping VALUES ('Nana', 'Judas', 5000);

UPDATE EmployesAvecCamping SET nomEmploye = 'Javel' WHERE prenomEmploye = 'Aude';
	
DELETE FROM EmployesAvecCamping WHERE prenomEmploye ='Aude';

--5

CREATE VIEW ClientsParVille(ville, nbClient) AS
	SELECT villeClient, COUNT(idClient)
	FROM Clients c
	GROUP BY villeClient;

--Impossible d'insérer des lignes car la vue utilise la fonction COUNT et la requête contient un GROUP BY

INSERT INTO ClientsParVille VALUES ('Rodez', 3);

UPDATE ClientsParVille SET ville = 'MTP' WHERE ville = 'Montpellier';

DELETE FROM ClientsParVille WHERE nbClient = 2;

--6

CREATE VIEW BungalowsEtCampings (idBungalow, nomBungalow, superficieBungalow, idCamping, nomCamping) AS
	SELECT idBungalow, nomBungalow, superficieBungalow, b.idCamping, nomCamping
	FROM Bungalows b
	JOIN Campings c ON b.idCamping =c.idCamping;

-- Impossible d'insérer des lignes simultanéments dans les tables Bungalows et Campings car la table Camping
--n'est pas protégé par sa clé
--Oui il est possible d'ajouter/modifier/supprimer des lignes dans la table Bungalows car elle est protégé par sa clé (clé primaire est préserversé dans la clause de jointure)
--Impossible d'insérer/modifier/supprimer  des lignes dans la table Campings car non protégé par sa clé


INSERT INTO BungalowsEtCampings VALUES ('B13', 'Le Souterrain', 75, 'CAMP10', 'Yellow Shark');

INSERT INTO BungalowsEtCampings(idBungalow, nomBungalow, superficieBungalow) VALUES ('B14', 'Le Dépotoir', 25);

INSERT INTO BungalowsEtCampings (idCamping, nomCamping) VALUES ('CAMP11', 'Apelsin Mollusk');

UPDATE BungalowsEtCampings SET superficieBungalow = 99 WHERE nomBungalow ='Le Palace';

UPDATE BungalowsEtCampings SET nomCamping = 'Le Majestique Blanc' WHERE nomCamping = 'The White Majestic';

--7

CREATE VIEW CampingsPalavas (idCamping, nomCamping, villeCamping, nbEtoilesCamping) AS
	SELECT idCamping, nomCamping, villeCamping, nbEtoilesCamping
	FROM Campings
	WHERE villeCamping = 'Palavas'
	

--Possible dans les deux cas, quand le camping n'est pas dans la ville Palavas, l'ajout se fait dans le table Campings et non dans la vue

INSERT INTO CampingsPalavas VALUES ('CAMP4', 'El Delfin Azul', 'Carnon', 3);


--Modification de la vue pour qu'on ne puisse insérer que des campings qui se trouvent dans la ville Palavas

CREATE OR REPLACE VIEW CampingsPalavas (idCamping, nomCamping, villeCamping, nbEtoilesCamping) AS
	SELECT idCamping, nomCamping, villeCamping, nbEtoilesCamping
	FROM Campings
	WHERE villeCamping = 'Palavas'
	WITH CHECK OPTION;

	INSERT INTO CampingsPalavas VALUES ('CAMP5', 'CamCamPing', 'Montpellier', 3);
	INSERT INTO CampingsPalavas VALUES ('CAMP5', 'CamCamPing', 'Palavas', 3);

--Modification de la vue pour qu'elle soit non modifiable

CREATE OR REPLACE VIEW CampingsPalavas (idCamping, nomCamping, villeCamping, nbEtoilesCamping) AS
	SELECT idCamping, nomCamping, villeCamping, nbEtoilesCamping
	FROM Campings
	WHERE villeCamping = 'Palavas'
	WITH READ ONLY;

--8

--

GRANT SELECT
ON Clients
TO PUBLIC;

SELECT * FROM abatm.Clients;

INSERT INTO Clients VALUES ('C3PO', 'Chie', 'Jean', '14/08/1995', 'Paris');

CREATE SYNONYM ClientsDeMael FOR abatm.Clients;

REVOKE SELECT ON Clients FROM PUBLIC;

CREATE VIEW ClientsMtp AS
	SELECT *
	FROM Clients
	WHERE villeClient = 'Montpellier';

GRANT SELECT
ON ClientsMtp
TO abatm;

SELECT * FROM abatm.ClientsMtp;

GRANT INSERT
ON ClientsMtp
to abatm;

INSERT INTO abatm.Clients VALUES ('TUPL', 'Sinsere', 'DansMael', '18/03/1999', 'Montpellier');

--9

CREATE VIEW LocationsJuillet (idLocation, idClient, nomClient, prenomClient, idBungalow, nomBungalow, nomCamping, dateDebut, dateFin, montantLocation) AS
	SELECT idLocation, l.idClient, nomClient, prenomClient, l.idBungalow, nomBungalow, nomCamping, dateDebut, dateFin, montantLocation
	FROM Locations l
	JOIN Bungalows b ON l.idBungalow = b.idBungalow
	JOIN Clients c ON l.idClient = c.idClient
	JOIN Campings c ON b.idCamping = c.idCamping
		WHERE dateDebut <= '31/07/2021'
		AND dateFin >= '01/07/2021';

GRANT SELECT
ON LocationsJuillet
to abatm;

GRANT INSERT
ON LocationsJuillet
to abatm;


INSERT INTO abatm.LocationsJuillet VALUES ('L53', 'C20', 'Konté', 'Bakari', 'B974', '46K Sport', 'Kemar', '14/08/2021', '28/08/2021', 2000);

-- Impossible d'insérer car table mutlivue

--Partie 4

--R22

CREATE VIEW EmployesLFB (idEmploye, nomEmploye, prenomEmploye, salaireEmploye) AS
	SELECT idEmploye, nomEmploye, prenomEmploye, salaireEmploye
	FROM Employes e
	JOIN Campings c ON e.idCamping = c.idCamping
	WHERE nomCamping = 'Les Flots Bleus';


SELECT *
FROM EmployesLFB
WHERE salaireEmploye = (SELECT MIN(salaireEmploye)FROM EmployesLFB);

--Requete à l'origine

SELECT nomEmploye, prenomEmploye 
	FROM Employes e
	JOIN Campings camp ON e.idCamping = camp.idCamping
	WHERE nomCamping ='Les Flots Bleus'
		AND salaireEmploye = (SELECT MIN(salaireEmploye) FROM Employes e
									JOIN Campings camp ON e.idCamping = camp.idCamping
										WHERE nomCamping = 'Les Flots Bleus');

--R87

CREATE VIEW EmployesParCamping (nomCamping, nbEmployes) AS
	SELECT nomCamping, COUNT(idEmploye)
	FROM Employes e
	JOIN Campings c ON e.idCamping = c.idCamping
	GROUP BY nomCamping;



SELECT nomCamping
FROM EmployesParCamping
WHERE nbEmployes = (SELECT MAX(COUNT(nbEmployes))
GROUP BY nomCamping;

--Requete a l'origine

SELECT nomCamping
FROM Campings c
JOIN Employes e ON e.idCamping = c.idCamping
GROUP BY c.idCamping, nomCamping
HAVING COUNT(*) = (SELECT MAX(COUNT(*)
FROM Employes
GROUP BY idCamping);





INSERT INTO abatm.LocationsJuillet VALUES ('L69', 'S3XE', 'Siffredi', 'Rocco', '8IID', 'Brazzers', 'Le Cheval Bien Monté', '14/07/2021', '28/07/2021', 1000);