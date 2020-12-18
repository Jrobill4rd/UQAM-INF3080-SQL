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
-- TEST Trigger TRG_bloquerInsertionStock
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
-- Création d'un usager
INSERT INTO Usager VALUES (0000000000000000004, 'hiver2021', 'Client');
-- Création d'un client 
INSERT INTO Client VALUES (0000000000000000004, 0000000000000000004, 'Peter', 'Griffin', '1-999-9999', 'drole', 001, 'Spooner Street', 'Quahog', 'USA', '010010');
-- Création d'une livraison
INSERT INTO Livraison VALUES (0000000000000000004, 0000000000000000004, '2020-12-10');
-- Création d'une facture
INSERT INTO Facture VALUES (0000000000000000004, 2500, 347.38, '2021-12-01');
-- Création d'un paiement
INSERT INTO Paiement VALUES (0000000000000000004, 0000000000000000001, '2020-12-18', 2000);
INSERT INTO Paiement VALUES (0000000000000000004, 0000000000000000002, '2020-12-20', 1500);

--=====================================
-- TEST Fonction fQteDejaLivree
--=====================================
-- Créer plusieurs produits
INSERT INTO Produit VALUES (0000000000000000004, '0000000000000000004');
INSERT INTO Produit VALUES (0000000000000000005, '0000000000000000005');
INSERT INTO Produit VALUES (0000000000000000006, '0000000000000000006');
-- Créer une commande avec le client 0000000000000000004
INSERT INTO Commande VALUES (0000000000000000005, 0000000000000000004, '2020-11-11', 'Payee');
-- Créer plusieurs lignes de commandes avec différents produits
INSERT INTO LigneCommande VALUES (0000000000000000005, 0000000000000000004, 10);
INSERT INTO LigneCommande VALUES (0000000000000000005, 0000000000000000005, 12);
INSERT INTO LigneCommande VALUES (0000000000000000005, 0000000000000000006, 8);
-- Créer une livraison
INSERT INTO Livraison VALUES (0000000000000000005, 0000000000000000004, '2020-12-15');
-- Créer plusieurs lignes de livraisons avec les produits commandés
INSERT INTO LigneLivraison VALUES (0000000000000000005, 0000000000000000004, 0000000000000000005, 8);
INSERT INTO LigneLivraison VALUES (0000000000000000005, 0000000000000000005, 0000000000000000005, 12);
INSERT INTO LigneLivraison VALUES (0000000000000000005, 0000000000000000006, 0000000000000000005, 4);
-- Appeler la fonction avec le numéro de produit '0000000000000000004' et la commande '0000000000000000005'
SELECT fQteDejaLivree(0000000000000000004, 0000000000000000005) FROM dual;

--=====================================
-- TEST Fonction fTotalFacture
--=====================================
-- Avec la livraison 0000000000000000004 d'un montant sous-total de 2500 et d'un montant de taxes de 347.38 
-- Appeler la fonction total facture (voir test TRG_bloquerPaiement)
SELECT fTotalFacture(0000000000000000004) FROM dual;

--=====================================
-- TEST Procedure p_PreparerLivraison
--=====================================
-- Avec la commande '0000000000000000005' et la livraison '0000000000000000005' utilisée au test fQteDejaLivree
-- Appeler la procedure p_PreparerLivraison
EXECUTE p_PreparerLivraison(0000000000000000005, 0000000000000000005);

--=====================================
-- TEST Procedure p_PreparerFacture
--=====================================
-- Créer une description pour les produits + prix
INSERT INTO TypeProduit VALUES (0000000000000000004, 'Tour ordinateur', 5, 50);
INSERT INTO ProduitPrix VALUES (0000000000000000004, '2020-01-01', 300);

INSERT INTO TypeProduit VALUES (0000000000000000005, 'Carte graphique', 5, 15);
INSERT INTO ProduitPrix VALUES (0000000000000000005, '2020-01-01', 100);

INSERT INTO TypeProduit VALUES (0000000000000000006, 'Cable alimentation', 5, 30);
INSERT INTO ProduitPrix VALUES (0000000000000000006, '2020-01-01', 10);
-- Avec le client 0000000000000000004, créer une nouvelle commande
INSERT INTO Commande VALUES (0000000000000000006, 0000000000000000004, '2020-11-11', 'Livree');
-- Créer plusieurs ligne de commande
INSERT INTO LigneCommande VALUES (0000000000000000006, 0000000000000000004, 10);
INSERT INTO LigneCommande VALUES (0000000000000000006, 0000000000000000005, 12);
INSERT INTO LigneCommande VALUES (0000000000000000006, 0000000000000000006, 8);
-- Créer une livraison
INSERT INTO Livraison VALUES (0000000000000000006, 0000000000000000004, '2020-12-12')
-- Créer des lignes livraisons
INSERT INTO LigneLivraison VALUES (0000000000000000006, 0000000000000000004, 0000000000000000006, 10);
INSERT INTO LigneLivraison VALUES (0000000000000000006, 0000000000000000005, 0000000000000000006, 12);
INSERT INTO LigneLivraison VALUES (0000000000000000006, 0000000000000000006, 0000000000000000006, 8);
-- Créer une facture
INSERT INTO Facture VALUES (0000000000000000006, 4300, 643.93, '2021-12-01');
-- Exécuter la procédure
EXECUTE p_PreparerLivraison(0000000000000000006, '2021-12-01');
