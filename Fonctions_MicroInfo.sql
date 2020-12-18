--===========================================
--@Auteur: Jeffrey Robillard
--Code Permanent: ROBJ20039301
--@Auteur: Angélie Ménard
--Code Permanent:
--Date de création: 2020-12-23
--Description: MENA16569906
--Script de Supression des Tables
-- ===========================================

SET ECHO ON
--===========================================
--Creation des fonctions
--===========================================
SET ECHO ON

--===============================================
--Fonction: fTotalFacture
--Description:
--Calculer la quantitée déja livrée
--IN (Entier): Un numéro de Livraison
--IN (Entier): Un numéro de Commande
--OUT (FLOAT): La quantité déja livré d'un produit
--=================================================
CREATE OR REPLACE FUNCTION fQteDejaLivree
(unNoProduit LigneLivraison.noProduit%TYPE, unNoCommande LigneLivraison.noCommande%TYPE)
RETURN  LigneLivraison.quantiteLivree%TYPE IS 

    quantiteDejalivree LigneLivraison.quantiteLivree%TYPE;
BEGIN 
   SELECT   SUM(quantiteLivree)
   INTO     quantiteDejalivree
   FROM     LigneLivraison
   WHERE    noProduit = unNoProduit AND noCommande = unNoCommande;
   RETURN   quantiteDejalivree;
END fQteDejaLivree;
/
SHOW ERRORS
--===============================================
--Fonction: fTotalFacture
--Description:
--Calculer le total d'une Facture
--IN (Entier): Un numéro de Livraison
--OUT (FLOAT): Le total d'une facture 
--===============================================
CREATE OR REPLACE FUNCTION fTotalFacture
(unNoLivraison Facture.noLivraison%TYPE)
RETURN Facture.montantSousTotal%TYPE IS

    MontTotalFacture Facture.montantSousTotal%TYPE;
BEGIN
    SELECT  SUM(montantSousTotal + montantTaxes)
    INTO    MontTotalFacture
    FROM    Facture
    WHERE   noLivraison = unNoLivraison;
    RETURN  MontTotalFacture;
END fTotalFacture;
/
SHOW ERRORS
--==============================
-- Création des Procedures
--==============================

--=================================================================
--Procédure: p_PreparerLivraison
--Description:
--Afficher un Bond de Livraison détaillé
--Créer une Ligne dans la table Livraison
--IN (Entier): Un numéro de Commande. 
--IN (Date)  : Une date limite de Livraison choisi par l'Utilisateur.
--===================================================================

CREATE OR REPLACE PROCEDURE p_PreparerLivraison
        (numCommande Commande.noCommande%TYPE, date_livraison Livraison.dateLivraison%TYPE) IS

        ---Déclaration de variables des informations client
        l_num_client Commande.noClient%TYPE;
        l_client Client%ROWTYPE;
        --Déclaration de variables des informations pour chaque produit
        l_num_produit   TypeProduit.noProduit%TYPE;     --le numéro de produit.
        l_desc_prod     TypeProduit.description%TYPE;   --la description du produit.
        l_code_zebre    Produit.codeZebre%TYPE;         --le code zebre du produit.
        l_qte_a_livrer  LigneCommande.quantite%TYPE;    --la quantité à livrer.
        
        --Déclaration de la variable pour le nouveau noLivraison.
        num_Livraison   Livraison.noLivraison%TYPE;     --le numéro de livraison de la commande.

        --Déclaration d'un curseur sur les produits de la commande.
        CURSOR cur_produits_commandee IS
                SELECT noProduit
                FROM   LigneCommande
                WHERE  LigneCommande.noCommande = numCommande;

BEGIN
        --Select pour obtenir le numéro de client pour la commande
        SELECT  noClient
	INTO	l_num_client
        FROM    Commande
        WHERE   Commande.noCommande = numCommande;

        --Select des informations du client
        SELECT prenom,nom,telephone,qualite,noCivique,rue,ville,pays,codePostal
        INTO   l_client.prenom, l_client.nom,l_client.telephone,l_client.qualite,l_client.noCivique,l_client.rue,l_client.ville,l_client.pays,l_client.codePostal
	FROM	Client
        WHERE   Client.noClient = l_num_client;

        --Affichage du bon de livraison.
        DBMS_OUTPUT.PUT_LINE('Numéro de commande:' || numCommande);
        DBMS_OUTPUT.PUT_LINE('NoClient:' || l_num_client);
        DBMS_OUTPUT.PUT_LINE('Prenom:' || l_client.prenom);
        DBMS_OUTPUT.PUT_LINE('Nom:' || l_client.nom);
        DBMS_OUTPUT.PUT_LINE('Telephone:' || l_client.telephone);
        DBMS_OUTPUT.PUT_LINE('Adresse:' || l_client.noCivique || ' ' || l_client.rue 
                        || ' ' || l_client.ville || ', ' || l_client.codePostal|| ', ' || l_client.pays);
        
        DBMS_OUTPUT.PUT_LINE('NoProduit | CodeZebre | description | quantite');
        DBMS_OUTPUT.PUT_LINE('==============================================');
        OPEN cur_produits_commandee;
        --Boucle sur les produits de la commande.
        LOOP
                FETCH cur_produits_commandee INTO l_num_produit; --ajout du produit courant à la variable.
                EXIT WHEN cur_produits_commandee%NOTFOUND;

                SELECT codeZebre
                INTO    l_code_zebre
                FROM   Produit
                WHERE  Produit.noProduit = l_num_produit;

                SELECT description
                INTO    l_desc_prod
                FROM    TypeProduit
                WHERE  TypeProduit.noProduit = l_num_produit;

                SELECT quantite
                INTO   l_qte_a_livrer
                FROM    LigneCommande
                WHERE  LigneCommande.noProduit = l_num_produit;

                DBMS_OUTPUT.PUT_LINE(l_num_produit || l_code_zebre || l_desc_prod || l_qte_a_livrer);

        END LOOP;
        CLOSE cur_produits_commandee;

        --Select pour obtenir le dernier numéro de livraison.
        SELECT MAX(noLivraison)
        INTO   num_Livraison
        FROM   Livraison;

        --Incrément du numéro de livraison
        IF num_Livraison == %NOTFOUND THEN
                num_Livraison == 0000000000000000001
        ELSE
                num_Livraison:= num_Livraison + 1;
        ENDIF;
         --Création de la livraison.
        INSERT INTO Livraison VALUES(num_Livraison,l_num_client,date_livraison);
END;
/
SHOW ERRORS
--=================================================================
--Procédure: p_PreparerFacture
--Description:
--Afficher une Facture détaillé
--Créer une Ligne dans la table Facture
--IN (Entier): Un numéro de Livraison. 
--IN (Date)  : Une date limite de Paiement choisi par l'Utilisateur.
--===================================================================
CREATE OR REPLACE PROCEDURE p_PreparerFacture
        (num_Livraison Livraison.noLivraison%TYPE, date_limite_paiement Facture.dateLimitePaiment%TYPE) IS

        --Déclaration de variables des informations client
        l_num_client            Commande.noClient%TYPE;
        l_client                Client%ROWTYPE;

        --Déclaration de variables des informations pour chaque produit
        l_num_produit     TypeProduit.noProduit%TYPE;   -- le numéro de produit
        l_desc_prod       TypeProduit.description%TYPE; --la description du produit
        l_qte_commande    LigneCommande.quantite%TYPE;  --la quantité à livrer
        l_prix_uni_prod   ProduitPrix.prix%TYPE;        --le prix de l'article unitaire
        l_prix_total_prod ProduitPrix.prix%TYPE;        --le prix de l'article total

        --Déclaration des variables des totaux factures.
        mont_sous_total Facture.montantSousTotal%TYPE;
        mont_taxes      Facture.montantTaxes%TYPE;
        mont_total      Facture.montantSousTotal%TYPE;

        --Déclaration d'un curseur sur les produits de la commande.
        CURSOR cur_produits_commandee IS
                SELECT noProduit
                FROM   LigneLivraison
                WHERE  LigneLivraison.noLivraison = num_Livraison;

BEGIN
        SELECT  noClient
	INTO	l_num_client
        FROM    Livraison
        WHERE   Livraison.noLivraison = num_Livraison;
        
        --Select des informations du client.
        SELECT prenom,nom,telephone,qualite,noCivique,rue,ville,pays,codePostal
        INTO   l_client.prenom, l_client.nom,l_client.telephone,l_client.qualite,l_client.noCivique,l_client.rue,l_client.ville,l_client.pays,l_client.codePostal
	FROM	Client
        WHERE   Client.noClient = l_num_client;
        
        --Affichage de la facture
        DBMS_OUTPUT.PUT_LINE('Numéro de Facture:' || num_Livraison);
        DBMS_OUTPUT.PUT_LINE('NoClient:' || l_num_client);
        DBMS_OUTPUT.PUT_LINE('Prenom:' || l_client.prenom);
        DBMS_OUTPUT.PUT_LINE('Nom:' || l_client.nom);
        DBMS_OUTPUT.PUT_LINE('Telephone:' || l_client.telephone);
        DBMS_OUTPUT.PUT_LINE('Adresse:' || l_client.noCivique || ' ' || l_client.rue 
                || ' ' || l_client.ville || ', ' || l_client.codePostal|| ', ' || l_client.pays);
        
        DBMS_OUTPUT.PUT_LINE('NoProduit | description | quantite | Prix Unitaire | Total |');
        DBMS_OUTPUT.PUT_LINE('==============================================================');

        OPEN cur_produits_commandee;
        LOOP
                FETCH cur_produits_commandee INTO l_num_produit;
                EXIT WHEN cur_produits_commandee%NOTFOUND;

                SELECT description
                INTO    l_desc_prod
                FROM    TypeProduit
                WHERE   TypeProduit.noProduit = l_num_produit;

                SELECT quantite
                INTO   l_qte_commande
                FROM    LigneCommande
                WHERE  LigneCommande.noProduit = l_num_produit;
               

                SELECT prix
                INTO    l_prix_uni_prod
                FROM    ProduitPrix
                WHERE   ProduitPrix.noProduit = l_num_produit;

                l_prix_total_prod := l_qte_commande * l_prix_uni_prod;

                DBMS_OUTPUT.PUT_LINE(l_num_produit || l_desc_prod || l_qte_commande || l_prix_uni_prod || l_prix_total_prod);

                mont_sous_total := mont_sous_total + l_prix_total_prod;
        END LOOP;

        mont_taxes := mont_sous_total * 0.15;
        mont_total := mont_sous_total + mont_taxes;
        DBMS_OUTPUT.PUT_LINE('Sous-total : ' || mont_sous_total);    
        DBMS_OUTPUT.PUT_LINE('Taxes :' || mont_taxes );
        DBMS_OUTPUT.PUT_LINE('Total : ' || mont_total);

         --Création de la Facture.
        INSERT INTO Facture VALUES(num_Livraison,mont_sous_total,mont_taxes,date_limite_paiement);
        CLOSE cur_produits_commandee;
END;
/
SHOW ERRORS
