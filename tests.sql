--===========================================
--@Auteur: Jeffrey Robillard
--Code Permanent: ROBJ20039301
--@Auteur: Angélie Ménard
--Code Permanent: MENA16569906
--Date de création: 2020-12-23
--Description:
--Script de Tests de la BD
--===========================================

SET SERVEROUTPUT ON


--============================
-- TEST Check Type Usager
--============================

---------------------[VALIDE]-----------------------
--Création d'un usager
INSERT INTO Usager VALUES (001, 'INF3080', 'Client');

---------------------[NON-VALIDE]-----------------------
--Création d'un usager
INSERT INTO Usager VALUES (002, 'Banane3', 'Rongeur');


--================================
-- TEST Check Type statusCommande
--================================

---------------------[VALIDE]-----------------------
--Création d'un Client
INSERT INTO Client VALUES (0000000000000000001,0000000000000000001, 'John', 'Doe', '0-000-0000', 'Sociable', 000, 'des oiseaux', 'Montreal', 'Canada', 'H0H0H0');
--Création d'une commande
INSERT INTO Commande VALUES(0000000000000000001, 0000000000000000001, '2020-12-06', 'Payee');

---------------------[NON-VALIDE]-----------------------
--Création d'un usager
INSERT INTO Usager VALUES (0000000000000000002, 'Banane3', 'Client');
--Création d'un Client
INSERT INTO Client VALUES (0000000000000000002,0000000000000000002, 'John', 'Doe', '0-000-0000', 'Sociable', 000, 'des oiseaux', 'Montreal', 'Canada', 'H0H0H0');
--Création d'une commande
INSERT INTO Commande VALUES(0000000000000000002, 0000000000000000002, '2020-12-06', 'Au depanneur');

--================================
-- TEST Check quantitee commandee
--================================

---------------------[VALIDE]-----------------------
--Création d'un produit
INSERT INTO Produit VALUES (0000000000000000001,'000000000001');
--Création d'un LigneCommande
INSERT INTO LigneCommande VALUES(0000000000000000001, 0000000000000000001, 12);

---------------------[NON-VALIDE]-----------------------
--Création d'un produit
INSERT INTO Produit VALUES (0000000000000000002,'000000000002');
--Création d'une commande
INSERT INTO Commande VALUES (0000000000000000002, 0000000000000000002, '2020-12-16', 'Payee');
--Création d'une LigneCommande
INSERT INTO LigneCommande VALUES (0000000000000000002, 0000000000000000002, -1);

--================================
-- TEST Check Mode de Paiement
--================================

---------------------[VALIDE]-----------------------
--Création d'une Livraison.
INSERT INTO Livraison VALUES (0000000000000000001, 01, '2021-01-01');
--Création d'un paiement
INSERT INTO Paiement VALUES (0000000000000000001, 0000000000000000001, '2020-12-16', 2000 );
--Création d'un paiement par carte de crédit
INSERT INTO PaiementCarteCredit VALUES (0001, '0000 0000 0000' , 'Visa', '2025-01-01');

---------------------[NON-VALIDE]-----------------------
--Création d'une Livraison.
INSERT INTO Livraison VALUES (0000000000000000002,0000000000000000002, '2021-01-01');
--Création d'un paiement
INSERT INTO Paiement VALUES (0000000000000000002,0000000000000000002, '2020-12-16', 2000 );
--Création d'un paiement par carte de crédit
INSERT INTO PaiementCarteCredit VALUES (0000000000000000002, '0000 0000 0000' , 'Capital One', '2021-05-16');

--================================
-- TEST Trigger AjusterQteEnStock
--================================

--Création d'un type de produit
INSERT INTO TypeProduit VALUES (0000000000000000001, 'Disque Dur', 20, 50);
--Vérification de la quantité avant la trigger
SELECT quantiteEnStock
FROM TypeProduit;
--Création d'une LigneLivraison
INSERT INTO LigneLivraison VALUES (0000000000000000001, 0000000000000000001, 0000000000000000001, 15);

--Vérification de la quantité après la livraison.
SELECT quantiteEnStock
FROM TypeProduit;

--=====================================
-- TEST Trigger TRG_bloquerInsertionLivraison
--=====================================
SELECT quantiteEnStock
FROM TypeProduit;
INSERT INTO LigneLivraison VALUES (0000000000000000002, 0000000000000000001, 0000000000000000002, 55)

--=====================================
-- TEST Trigger TRG_bloquerInsertionCommande
--=====================================
--Création d'un produit
INSERT INTO Produit VALUES (0000000000000000003,'000000000002');
--Création d'une commande
INSERT INTO TypeProduit VALUES (0000000000000000003, 'LAPTOP', 20, 50);
INSERT INTO Commande VALUES (0000000000000000003, 0000000000000000002, '2020-12-16', 'Payee');
--Création d'une LigneCommande
INSERT INTO LigneCommande VALUES (0000000000000000003, 0000000000000000003, 55);

--=====================================
-- TEST Trigger TRG_bloquerPaiement
--=====================================



--=====================================
-- TEST Fonction fQteDejaLivree
--=====================================



--=====================================
-- TEST Fonction fTotalFacture
--=====================================




--=====================================
-- TEST Procedure p_PreparerLivraison
--=====================================


--=====================================
-- TEST Procedure p_PreparerFacturen
--=====================================