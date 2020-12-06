BSBaSGpb

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
(produitId              NUMBER(19)              NOT NULL,
 noProduit              NUMBER(19)              NOT NULL,
 codeZebre              CHAR(12)                NOT NULL,
 PRIMARY KEY    (produitId)
)
/
CREATE TABLE PrioriteFournisseur
(noFournisseur  NUMBER(19)              NOT NULL,
 noProduit              NUMBER(19)              NOT NULL,
 priorite               NUMBER(19)              NOT NULL,
 PRIMARY KEY    (noFournisseur),
 FOREIGN KEY    (noFournisseur) REFERENCES Fournisseur,
 FOREIGN KEY    (noProduit)             REFERENCES Produit
)
/
CREATE TABLE Client
(noClient               NUMBER(19)              NOT NULL,
 noUsager               NUMBER(19)              NOT NULL,
 prenom             VARCHAR(50)         NOT NULL,
 nom                VARCHAR(50)         NOT NULL,
 telephone              CHAR(10)                NOT NULL,
 qualite            VARCHAR(25)         NOT NULL,
 noCivique              NUMBER(19)              NOT NULL,
 rue                VARCHAR(50)         NOT NULL,
 ville              VARCHAR(50)         NOT NULL,
 pays               VARCHAR(50)         NOT NULL,
 codePostal             CHAR(6)                 NOT NULL,
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
        NEW AS Commande
FOR EACH ROW
BEGIN
        UPDATE TypeProduit
        SET quantiteEnStock = quantiteEnStock - Commande.quantiteLivree
        WHERE noProduit = Commande.noProduit;
END
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
        WHERE noProduit = :LivraisonStock.noProduit;

        IF :LivraisonStock.quantiteLivre > quantiteStock THEN raise_application_error(-20100, 'La quantite livree ne peut depasser la quantite en stock');
        END IF;
END;
/


-- Bloquer l'insertion d'un article lorsque la quantité totale livrée dépasse la quantité commandée de la commande
CREATE OR REPLACE TRIGGER bloquerInsertionCommande
BEFORE INSERT
        ON LigneLivraison FOR EACH ROW

BEGIN
SELECT SUM(quantiteLivree) AS livraison
FROM LigneLivraison
GROUP BY GROUPING SETS (
        (produitId),
        (noLivraison)
)
WHERE (LigneLivraison.noProduit = TypeProduit.noProduit)
        IF (livraison > LigneCommande.quantite)
                BEGIN
                        ROLLBACK TRANSACTION
                        RAISEERROR ("La quantite livree ne peut pas depasser la quantite commandee", 16, 1)
                END;
        END IF;
END;
TION
                        RAISEERROR ("La quantite livree ne peut depasser la quantite en stock", 16, 1)
                END;
        END IF;
END;
/
--Bloquer l'insertion d'un paiement qui dépasse le montant qui reste à payer
CREATE OR REPLACE TRIGGER bloquerPaiement
BEFORE INSERT
        ON Paiement FOR EACH ROW
BEGIN
SELECT SUM(Paiement.montant) as MontantPaye AND SUM(Facture.montantSousTotal + Facture.montantTaxes) as MontantTotal
GROUP BY noLivraison
WHERE Paiement.noLivraison = Facture.noLivraison
        IF Paiement.MontantPaye > Facture.MontantTotal
                BEGIN
                        ROLLBACK TRANSACTION
                        RAISEERROR ("La quantite paye ne doit pas depasser le montant total du", 16, 1)
                END;
        END IF;
END;
/
