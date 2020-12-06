SET ECHO ON
SPOOL ./Schema_Output.txt
-- Script Oracle SQL*plus de creation du schema Micro-Info
-- Version sans accents

-- drop table
DROP TABLE usager CASCADE CONSTRAINTS;
DROP TABLE Fournisseur CASCADE CONSTRAINTS;
DROP TABLE Produit CASCADE CONSTRAINTS;
DROP TABLE PrioriteFournisseur CASCADE CONSTRAINTS;
DROP TABLE Client CASCADE CONSTRAINTS;
DROP TABLE TypeProduit CASCADE CONSTRAINTS;
DROP TABLE ProduitPrix CASCADE CONSTRAINTS;
DROP TABLE Commande CASCADE CONSTRAINTS;
DROP TABLE LigneCommande CASCADE CONSTRAINTS;
DROP TABLE Livraison CASCADE CONSTRAINTS;
DROP TABLE LigneLivraison CASCADE CONSTRAINTS;
DROP TABLE Facture CASCADE CONSTRAINTS;
DROP TABLE Paiement CASCADE CONSTRAINTS;
DROP TABLE PaiementCheque CASCADE CONSTRAINTS;
DROP TABLE PaiementCarteCredit CASCADE CONSTRAINTS;

-- Creation des tables
CREATE TABLE Usager
(noUsager               NUMBER(19)              NOT NULL,
 motDePasse             VARCHAR(25)             NOT NULL,
 typeUsager     VARCHAR(15)
 CHECK(typeUsager IN('Client', 'Fournisseur', 'Commis')),
 PRIMARY KEY    (noUsager)
)
/
CREATE TABLE Fournisseur
(noUsager               NUMBER(19)              NOT NULL,
 noFournisseur  NUMBER(19)              NOT NULL        UNIQUE,
 telephone              CHAR(10)                NOT NULL,
 raisonSociale  VARCHAR(50)             NOT NULL,
 noCivique              NUMBER(19)              NOT NULL,
 rue                    VARCHAR(50)             NOT NULL,
 ville                  VARCHAR(50)             NOT NULL,
 pays                   VARCHAR(50)             NOT NULL,
 codePostal             VARCHAR(6)              NOT NULL,
 FOREIGN KEY    (noUsager) REFERENCES Usager
)
/
CREATE TABLE Produit
(produitId              NUMBER(19)      NOT NULL,
 noProduit              NUMBER(19)      NOT NULL,
 codeZebre              CHAR(12)        NOT NULL,
 PRIMARY KEY    (produitId)
)
/
CREATE TABLE PrioriteFournisseur
(noFournisseur  NUMBER(19)              NOT NULL,
 noProduit              NUMBER(19)      NOT NULL,
 priorite               NUMBER(19)      NOT NULL,
 PRIMARY KEY    (noFournisseur),
 FOREIGN KEY    (noFournisseur)         REFERENCES Fournisseur,
 FOREIGN KEY    (noProduit)             REFERENCES Produit
)
/
CREATE TABLE Client
(noClient           NUMBER(19)          NOT NULL,
 noUsager           NUMBER(19)          NOT NULL,
 prenom             VARCHAR(50)         NOT NULL,
 nom                VARCHAR(50)         NOT NULL,
 telephone          CHAR(10)            NOT NULL,
 qualite            VARCHAR(25)         NOT NULL,
 noCivique          NUMBER(19)          NOT NULL,
 rue                VARCHAR(50)         NOT NULL,
 ville              VARCHAR(50)         NOT NULL,
 pays               VARCHAR(50)         NOT NULL,
 codePostal         CHAR(6)             NOT NULL,
 PRIMARY KEY (noClient),
 FOREIGN KEY (noUsager) REFERENCES Usager
)
/
CREATE TABLE TypeProduit
(noProduit                      NUMBER(19)              NOT NULL        UNIQUE,
 description            VARCHAR(250)    NOT NULL,
 minimumEnStock         NUMBER(19)      NOT NULL,
 quantiteEnStock        NUMBER(19)      NOT NULL,
 FOREIGN KEY (noProduit) REFERENCES Produit
)
/

CREATE TABLE ProduitPrix
(noProduit                      NUMBER(19)              NOT NULL,
 dateEnVigueur          DATE                NOT NULL,
 prix                           NUMBER(19,4)    NOT NULL,
 PRIMARY KEY (noProduit),
 FOREIGN KEY (noProduit) REFERENCES Produit
)
/
CREATE TABLE Commande
(noCommande             NUMBER(19)              NOT NULL,
 noClient               NUMBER(19)              NOT NULL,
 dateCommande   DATE            NOT NULL,
 typeStatusCommande VARCHAR(15)
 CHECK(typeStatusCommande IN ('Annulee','Livree','Payee','En Attente')),
 PRIMARY KEY (noCommande),
 FOREIGN KEY (noClient) REFERENCES Client
)
/
CREATE TABLE LigneCommande
(noCommande             NUMBER(19)              NOT NULL,
 noProduit              NUMBER(19)              NOT NULL,
 quantite               NUMBER(19)              NOT NULL,
 CHECK (quantite > 0),
 PRIMARY KEY (noCommande, noProduit),
 FOREIGN KEY (noCommande) REFERENCES Commande,
 FOREIGN KEY (noProduit)  REFERENCES Produit
)
/
CREATE TABLE Livraison
(noLivraison            NUMBER(19)              NOT NULL,
 noClient                       NUMBER(19)              NOT NULL,
 dateLivraison          DATE                    NOT NULL,
 PRIMARY KEY (noLivraison),
 FOREIGN KEY (noClient) REFERENCES Client
)
/
CREATE TABLE LigneLivraison
(noLivraison            NUMBER(19)              NOT NULL,
 noProduit                      NUMBER(19)              NOT NULL,
 noCommande                     NUMBER(19)              NOT NULL,
 quantiteLivree     NUMBER(19)      NOT NULL,
 PRIMARY KEY (noLivraison),
 FOREIGN KEY (noLivraison) REFERENCES Livraison,
 FOREIGN KEY (noProduit)   REFERENCES Produit,
 FOREIGN KEY (noCommande)  REFERENCES Commande
)
/

CREATE TABLE Facture
(noLivraison            NUMBER(19)              NOT NULL,
 montantSousTotal       NUMBER(19,4)    NOT NULL,
 montantTaxes           NUMBER(19,4)    NOT NULL,
 PRIMARY KEY (noLivraison),
 FOREIGN KEY (noLivraison) REFERENCES Livraison
 )
/
CREATE TABLE Paiement
(noLivraison            NUMBER(19)              NOT NULL,
 noPaiement             NUMBER(19)              NOT NULL,
 datePaiement           DATE                    NOT NULL,
 montant                        FLOAT(4)        NOT NULL,
 PRIMARY KEY (noPaiement),
 FOREIGN KEY (noLivraison) REFERENCES Livraison
)
/
CREATE TABLE PaiementCheque
( noPaiement            NUMBER(19)              NOT NULL,
  noBanque                  NUMBER(19)          NOT NULL,
  noCompte                  NUMBER(19)          NOT NULL,
  PRIMARY KEY (noPaiement),
  FOREIGN KEY (noPaiement) REFERENCES Paiement(noPaiement)
)
/
CREATE TABLE PaiementCarteCredit
(noPaiement             NUMBER(19)      NOT NULL,
 noCarte                        VARCHAR(25)     NOT NULL,
 typeCarteCredit    VARCHAR(15)
 CHECK (typeCarteCredit IN('Visa','MasterCard','AmericanExpress')),
 dateExpiration     DATE                        NOT NULL,
 PRIMARY KEY (noPaiement),
 FOREIGN KEY (noPaiement) REFERENCES Paiement(noPaiement)
)
/
-- Triggers

-- Réduire la quantité en stock d'un article en fonction de la quantité LIVRÉE
CREATE TRIGGER AjusterQteEnStock
AFTER INSERT ON LigneLivraison
REFERENCING
        NEW AS Achat
FOR EACH ROW
BEGIN
        UPDATE TypeProduit
        SET TypeProduit.quantiteEnStock = TypeProduit.quantiteEnStock - :Achat.quantiteLivree
        WHERE TypeProduit.noProduit = :Achat.noProduit;
END;
/
-- Bloquer l'insertion d'une livraison d'un article lorsque la quantité livrée dépasse la quantité en stock
CREATE OR REPLACE TRIGGER bloquerInsertionStock
BEFORE INSERT
        ON LigneLivraison
REFERENCING
        NEW AS LivraisonStock
FOR EACH ROW

DECLARE quantiteStock INTEGER;

BEGIN
        SELECT quantiteEnStock
        INTO quantiteStock
        FROM TypeProduit
        WHERE TypeProduit.noProduit = :LivraisonStock.noProduit;

        IF :LivraisonStock.quantiteLivree > quantiteStock THEN 
		raise_application_error(-20100, 'La quantite livree ne peut depasser la quantite en stock');
        END IF;
END;
/

SHOW ERRORS
-- Bloquer l'insertion d'une livraison d'un article  lorsque la quantité totale livrée dépasse la quantité commandée de la commande
CREATE OR REPLACE TRIGGER bloquerInsertionCommande
BEFORE INSERT
        ON LigneLivraison
REFERENCING
	NEW AS NouvelleLivraison
FOR EACH ROW
	DECLARE
		qteLivree	NUMBER(19);
		qteCommandee	NUMBER(19);
BEGIN	
	SELECT	SUM(quantiteLivree)
	INTO	qteLivree
	FROM	LigneLivraison
	WHERE	LigneLivraison.noProduit = :NouvelleLivraison.noProduit;

	SELECT	quantite
	INTO	qteCommandee
	FROM	LigneCommande
	WHERE	LigneCommande.noProduit = :NouvelleLivraison.noProduit;

        IF :NouvelleLivraison.quantiteLivree + qteLivree > qteCommandee THEN 
		raise_application_error(-20100, 'La quantite a livrer est trop elevee');
        END IF;
END;
/
show errors
--Bloquer l'insertion d'un paiement qui dépasse le montant qui reste à payer
CREATE OR REPLACE TRIGGER bloquerPaiement
BEFORE INSERT
        ON Paiement
REFERENCING
        NEW AS NouveauPaiement
FOR EACH ROW
	DECLARE
		totalPaiement NUMBER(19,4);
		totalFacture  NUMBER(19,4); 
BEGIN
	SELECT  SUM(Facture.montantSousTotal + Facture.montantTaxes)
	INTO 	totalFacture
	FROM	Facture
	WHERE	Facture.noLivraison = :NouveauPaiement.noLivraison;
	
	SELECT	SUM(montant)
	INTO	totalPaiement
	FROM	Paiement
	WHERE	Paiement.noLivraison = :NouveauPaiement.noLivraison;
	        
        IF :NouveauPaiement.montant > (totalFacture - totalPaiement) THEN 
        	raise_application_error(-20300, 'Le montant a payer ne doit pas depasser le montant du');
        END IF;
END;
/
show errors
