SET ECHO ON
-- Script Oracle SQL*plus de creation du schema Micro-Info
-- Version sans accents

-- Creation des tables
SET ECHO ON
CREATE TABLE Usager
(noUsager		NUMBER(19)		NOT NULL,
 motDePasse		VARCHAR(25)		NOT NULL,
 typeUsager 	VARCHAR(15) 
 CHECK(typeUsager IN('Client', 'Fournisseur', 'Commis')),
 PRIMARY KEY	(noUsager)	
) 
/
CREATE TABLE Fournisseur
(noUsager		NUMBER(19)		NOT NULL,
 noFournisseur	NUMBER(19)		NOT NULL,
 telephone		CHAR(10)		NOT NULL,
 raisonSociale	VARCHAR(50)		NOT NULL,
 noCivique		NUMBER(19)		NOT NULL,
 rue			VARCHAR(50)		NOT NULL,
 ville			VARCHAR(50)		NOT NULL,
 pays			VARCHAR(50)		NOT NULL,
 codePostal		VARCHAR(6)		NOT NULL,
 PRIMARY KEY	(noFournisseur),
 FOREIGN KEY	(noUsager) REFERENCES Usager
)
/
CREATE TABLE Produit
(produitId		NUMBER(19)		NOT NULL,
 noProduit		NUMBER(19)		NOT NULL,
 codeZebre		CHAR(12)		NOT NULL,
 PRIMARY KEY	(produitId)
)
/ 
CREATE TABLE PrioriteFournisseur
(noFournisseur	NUMBER(19)		NOT NULL,
 noProduit		NUMBER(19)		NOT NULL,
 priorite 		NUMBER(19)		NOT NULL,
 PRIMARY KEY	(noFournisseur),
 FOREIGN KEY	(noFournisseur) REFERENCES Fournisseur,
 FOREIGN KEY    (noProduit)		REFERENCES Produit
)
/
CREATE TABLE Client
(noClient		NUMBER(19)		NOT NULL,
 noUsager		NUMBER(19)		NOT NULL,
 prenom		    VARCHAR(50)		NOT NULL,
 nom		    VARCHAR(50)		NOT NULL,
 telephone		CHAR(10)		NOT NULL,
 qualite	    VARCHAR(25)		NOT NULL,
 noCivique		NUMBER(19)		NOT NULL,
 rue		    VARCHAR(50)		NOT NULL,
 ville		    VARCHAR(50)		NOT NULL,
 pays		    VARCHAR(50)		NOT NULL,
 codePostal		CHAR(6)			NOT NULL,
 PRIMARY KEY (noClient),
 FOREIGN KEY (noUsager) REFERENCES Usager
)
/ 
CREATE TABLE TypeProduit
(noProduit			NUMBER(19)		NOT NULL,
 description		VARCHAR(250)	NOT NULL,
 minimumEnStock		NUMBER(19)		NOT NULL,
 quantiteEnStock	NUMBER(19)		NOT NULL,
 PRIMARY KEY (noProduit),
 FOREIGN KEY (noProduit) REFERENCES Produit 
) 
/
 
CREATE TABLE ProduitPrix
(noProduit			NUMBER(19)		NOT NULL,
 dateEnVigueur		DATE 			NOT NULL,
 prix 				NUMBER(19,4)    NOT NULL,
 PRIMARY KEY (noProduit),
 FOREIGN KEY (noProduit) REFERENCES Produit
)
/
CREATE TABLE Commande
(noCommande		NUMBER(19)			NOT NULL,
 noClient		NUMBER(19)			NOT NULL,
 dateCommande	DATE	     		NOT NULL,
 typeStatusCommande VARCHAR(15) 
 CHECK(typeStatusCommande IN ('Annulee','Livree','Payee','En Attente')),
 PRIMARY KEY (noCommande),
 FOREIGN KEY (noClient) REFERENCES Client
)
/ 
CREATE TABLE LigneCommande
(noCommande		NUMBER(19)			NOT NULL,
 noProduit		NUMBER(19)			NOT NULL,
 quantite 		NUMBER(19)			NOT NULL,
 CHECK (quantite > 0),
 PRIMARY KEY (noCommande, noProduit),
 FOREIGN KEY (noCommande) REFERENCES Commande,
 FOREIGN KEY (noProduit)  REFERENCES Produit
)
/
CREATE TABLE Livraison
(noLivraison 		NUMBER(19)			NOT NULL,
 noClient			NUMBER(19)			NOT NULL,
 dateLivraison		DATE 				NOT NULL,
 PRIMARY KEY (noLivraison),
 FOREIGN KEY (noClient) REFERENCES Client
)micrSch
/
CREATE TABLE LigneLivraison
(noLivraison 		NUMBER(19)			NOT NULL,
 produitId			NUMBER(19)			NOT NULL,
 noCommande			NUMBER(19)			NOT NULL,
 PRIMARY KEY (noLivraison),
 FOREIGN KEY (noLivraison) REFERENCES Livraison,
 FOREIGN KEY (produitId)   REFERENCES Produit,
 FOREIGN KEY (noCommande)  REFERENCES Commande
)
/

CREATE TABLE Facture
(noLivraison 		NUMBER(19)			NOT NULL,
 montantSousTotal	NUMBER(19,4)		NOT NULL,
 montantTaxes 		NUMBER(19,4)		NOT NULL,
 PRIMARY KEY (noLivraison),
 FOREIGN KEY (noLivraison) REFERENCES Livraison
 )
/
CREATE TABLE Paiement
(noLivraison 		NUMBER(19)			NOT NULL,
 noPaiement 		NUMBER(19)			NOT NULL,
 datePaiement		DATE 				NOT NULL,
 montant 			FLOAT(4)			NOT NULL,
 PRIMARY KEY (noLivraison, noPaiement),
 FOREIGN KEY (noLivraison) REFERENCES Livraison
)
/
CREATE TABLE PaiementCheque
( noPaiement 		NUMBER(19)			NOT NULL,
  noBanque 		    NUMBER(19)			NOT NULL,
  noCompte 		    NUMBER(19)			NOT NULL,
  PRIMARY KEY (noPaiement),
  FOREIGN KEY (noPaiement) REFERENCES Paiement(noPaiement)
)
/
CREATE TABLE PaiementCarteCredit
(noPaiement 		NUMBER(19)			NOT NULL,
 noCarte			VARCHAR(25)			NOT NULL,
 typeCarteCredit    VARCHAR(15) 
 CHECK (typeCarteCredit IN('Visa','MasterCard','AmericanExpress')),
 dateExpiration	    DATE  				NOT NULL,
 PRIMARY KEY (noPaiement),
 FOREIGN KEY (noPaiement) REFERENCES Paiement(noPaiement)
)
/
