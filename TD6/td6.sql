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

INSERT INTO EmployesSansCamping (idEmploye, nomEmploye, prenomEmploye, salaireEmploye) VALUES (E100, Stiko, Judas, 3000);

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
	FROM