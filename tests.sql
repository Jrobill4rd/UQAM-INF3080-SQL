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
INSERT INTO Usager VALUES (1, 'INF3080', 'Client');

---------------------[NON-VALIDE]-----------------------
--Création d'un usager
INSERT INTO Usager VALUES (2, 'Banane3', 'Rongeur');


--================================
-- TEST Check Type statusCommande
--================================

---------------------[VALIDE]-----------------------
--Création d'un Client
INSERT INTO Client VALUES (1, 1, 'John', 'Doe', '0-000-0000', 'Sociable', 000, 'des oiseaux', 'Montreal', 'Canada', 'H0H0H0');
--Création d'une commande
INSERT INTO Commande VALUES(1, 1, '2020-12-06', 'Payee');

---------------------[NON-VALIDE]-----------------------
--Création d'un usager
INSERT INTO Usager VALUES (2, 'Banane3', 'Client');
--Création d'un Client
INSERT INTO Client VALUES (2, 2, 'Jean', 'Horace', '0-000-0000', 'Ponctuel', 123, 'Jeanne-Mance', 'Montreal', 'Canada', 'H0H0H0');
--Création d'une commande
INSERT INTO Commande VALUES(2, 2, '2020-12-06', 'Au depanneur');

--================================
-- TEST Check quantitee commandee
--================================

---------------------[VALIDE]-----------------------
--Création d'un produit
INSERT INTO Produit VALUES (1,'000000000001');
--Création d'un LigneCommande
INSERT INTO LigneCommande VALUES(1, 1, 12);

---------------------[NON-VALIDE]-----------------------
--Création d'un produit
INSERT INTO Produit VALUES (2,'000000000002');
--Création d'une commande
INSERT INTO Commande VALUES (2, 2, '2020-12-16', 'Payee');
--Création d'une LigneCommande
INSERT INTO LigneCommande VALUES (2, 2, -1);

--================================
-- TEST Check Mode de Paiement
--================================

---------------------[VALIDE]-----------------------
--Création d'une Livraison.
INSERT INTO Livraison VALUES (1, 1, '2021-01-01');
--Création d'un paiement
INSERT INTO Paiement VALUES (1, 1, '2020-12-16', 2000 );
--Création d'un paiement par carte de crédit
INSERT INTO PaiementCarteCredit VALUES (1, '0000 0000 0000' , 'Visa', '2025-01-01');

---------------------[NON-VALIDE]-----------------------
--Création d'une Livraison.
INSERT INTO Livraison VALUES (2, 2, '2021-01-01');
--Création d'un paiement
INSERT INTO Paiement VALUES (2, 2, '2020-12-16', 2000 );
--Création d'un paiement par carte de crédit
INSERT INTO PaiementCarteCredit VALUES (2, '0000 0000 0000' , 'Capital One', '2021-05-16');

--================================
-- TEST Trigger AjusterQteEnStock
--================================

--Création d'un type de produit
INSERT INTO TypeProduit VALUES (1, 'Disque Dur', 20, 50);
--Vérification de la quantité avant la trigger
SELECT quantiteEnStock
FROM TypeProduit;
--Création d'une LigneLivraison
INSERT INTO LigneLivraison VALUES (1, 1, 1, 12);

--Vérification de la quantité après la livraison.
SELECT quantiteEnStock
FROM TypeProduit;

--=====================================
-- TEST Trigger TRG_bloquerInsertionStock
--=====================================
SELECT quantiteEnStock
FROM TypeProduit;
-- Création d'une ligne commande pour la commande 2
INSERT INTO LigneCommande VALUES (2,1,10);

INSERT INTO LigneLivraison VALUES (2, 1, 2, 55);

--=====================================
-- TEST Trigger TRG_bloquerInsertionCommande
--=====================================
--Création d'un produit
INSERT INTO Produit VALUES (3,'000000000002');
--Création d'une commande
INSERT INTO TypeProduit VALUES (3, 'LAPTOP', 20, 50);
INSERT INTO Commande VALUES (3, 2, '2020-12-16', 'Payee');
--Création d'une LigneCommande
INSERT INTO LigneCommande VALUES (3, 3, 55);

--=====================================
-- TEST Trigger TRG_bloquerPaiement
--=====================================
-- Création d'un usager
INSERT INTO Usager VALUES (4, 'hiver2021', 'Client');
-- Création d'un client
INSERT INTO Client VALUES (4, 4, 'Peter', 'Griffin', '1-999-9999', 'drole', 001, 'Spooner Street', 'Quahog', 'USA', '010010');
-- Création d'une livraison
INSERT INTO Livraison VALUES (4, 4, '2020-12-10');
-- Création d'une facture
INSERT INTO Facture VALUES (4, 2500, 347.38, '2021-12-01');

-- Création d'un paiement
INSERT INTO Paiement VALUES (4, 3, '2020-12-18', 2000);
INSERT INTO Paiement VALUES (4, 4, '2020-12-20', 1500);

--=====================================
-- TEST Fonction fQteDejaLivree
--=====================================
-- Création des produit
INSERT INTO Produit VALUES (4, '0000000000000000004');
INSERT INTO Produit VALUES (5, '0000000000000000005');
INSERT INTO Produit VALUES (6, '0000000000000000006');

INSERT INTO TypeProduit VALUES (4, 'Tour ordinateur', 5, 70);
INSERT INTO ProduitPrix VALUES (4, '2020-01-01', 300);

INSERT INTO TypeProduit VALUES (5, 'Carte graphique', 5, 50);
INSERT INTO ProduitPrix VALUES (5, '2020-01-01', 100);

INSERT INTO TypeProduit VALUES (6, 'Cable alimentation', 5, 75);
INSERT INTO ProduitPrix VALUES (6, '2020-01-01', 10);
-- Créer une commande avec le client 4
INSERT INTO Commande VALUES (5, 4, '2020-11-11', 'Payee');
-- Créer plusieurs lignes de commandes avec différents produits
INSERT INTO LigneCommande VALUES (5, 4, 10);
INSERT INTO LigneCommande VALUES (5, 5, 12);
INSERT INTO LigneCommande VALUES (5, 6, 8);
-- Créer une livraison
INSERT INTO Livraison VALUES (5, 4, '2020-12-15');
-- Créer plusieurs lignes de livraisons avec les produits commandés
INSERT INTO LigneLivraison VALUES (5, 4, 5, 8);
INSERT INTO LigneLivraison VALUES (5, 5, 5, 12);
INSERT INTO LigneLivraison VALUES (5, 6, 5, 4);
-- Appeler la fonction avec le numéro de produit 4 et la commande 5
SELECT fQteDejaLivree(4, 5) FROM dual;

--=====================================
-- TEST Fonction fTotalFacture
--=====================================
-- Avec la livraison 4 d'un montant sous-total de 2500 et d'un montant de taxes de 347.38
-- Appeler la fonction total facture (voir test TRG_bloquerPaiement)
SELECT fTotalFacture(4) FROM dual;

--=====================================
-- TEST Procedure p_PreparerLivraison
--=====================================
-- Avec la commande 5 et la livraison 5 utilisée au test fQteDejaLivree
-- Appeler la procedure p_PreparerLivraison
EXECUTE p_PreparerLivraison(5, 5);

--=====================================
-- TEST Procedure p_PreparerFacture
--=====================================
-- Avec le client 4, créer une nouvelle commande
INSERT INTO Commande VALUES (6, 4, '2020-11-11', 'Livree');
-- Créer plusieurs ligne de commande
INSERT INTO LigneCommande VALUES (6, 4, 10);
INSERT INTO LigneCommande VALUES (6, 5, 12);
INSERT INTO LigneCommande VALUES (6, 6, 8);
-- Créer une livraison
INSERT INTO Livraison VALUES (6, 4, '2020-12-12')
-- Créer des lignes livraisons
INSERT INTO LigneLivraison VALUES (6, 4, 6, 10);
INSERT INTO LigneLivraison VALUES (6, 5, 6, 12);
INSERT INTO LigneLivraison VALUES (6, 6, 6, 8);
-- Créer une facture
INSERT INTO Facture VALUES (6, 4300, 643.93, '2021-12-01');
-- Exécuter la procédure
EXECUTE p_PreparerLivraison(6, '2021-12-01');
