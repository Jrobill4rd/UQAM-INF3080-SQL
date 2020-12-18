SET ECHO ON
-- Script Oracle SQL*plus de creation du schema Micro-Info
-- Version sans accents

-- Creation des fonctions
SET ECHO ON

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



---
---
---
---
---
---
---
CREATE OR REPLACE PROCEDURE p_PreparerLivraison
        (numCommande Commande.noCommande%TYPE, date_livraison Livraison.dateLivraison%TYPE) IS

        ---Déclaration de variables des informations client
        l_num_client Commande.noClient%TYPE;
        l_client Client%ROWTYPE;
        l_codepostal_client Client.codePostal%TYPE;
        --Déclaration de variables des informations pour chaque produit
        l_num_produit     TypeProduit.noProduit%TYPE; -- le numéro de produit
        l_desc_prod TypeProduit.description%TYPE; --la description du produit
        l_code_zebre Produit.codeZebre%TYPE; -- le code zebre du produit
        l_qte_a_livrer Commande.quantite%TYPE; --la quantité à livrer

        num_Livraison Livraison.noLivraison%TYPE; --le numéro de livraison de la commande

        --Déclaration d'un curseur sur les produits de la commande.
        CURSOR cur_produits_commandee IS
                SELECT noProduit
                FROM   LigneCommande
                WHERE  LigneCommande.noCommande = :numCommande;

BEGIN
        DBMS_OUTPUT.PUT_LINE('Numéro de commande:' || numCommande)
        SELECT  noClient
        FROM    Commande
        INTO    l_num_client
        WHERE   Commande.noCommande = :numCommande;

        SELECT prenom,nom, telephone,qualite,noCivique, rue, ville, pays, codePostal
        FROM   Client
        INTO   l_client.prenom, l_client.nom, l_client.telephone, l_client.qualite,l_client.noCivique
                l_client.rue, l_client.ville, l_client.pays, l_client.codePostal
        WHERE   Client.noClient = l_num_client;
        DBMS_OUTPUT.PUT_LINE('NoClient:' || l_num_client);
        DBMS_OUTPUT.PUT_LINE('Prenom:' || l_client.prenom);
        DBMS_OUTPUT.PUT_LINE('Nom:' || l_client.nom);
        DBMS_OUTPUT.PUT_LINE('Telephone:' || l_client.telephone);
        DBMS_OUTPUT.PUT_LINE('Adresse:' || l_client.noCivique || ' ' || l_client.rue 
                || ' ' || l_client.ville || ', ' || l_client.codePostal|| ', ' || l_client.pays);
        

        OPEN cur_produits_commandee;
        LOOP
                FETCH cur_produits_commandee INTO l_num_produit;
                EXIT WHEN cur_produits_commandee%NOTFOUND;

                SELECT codeZebre
                INTO    l_code_zebre
                FROM   Produit
                WHERE  Produit.noProduit = :l_num_produit;

                SELECT description
                INTO    l_desc_prod
                FROM    TypeProduit
                WHERE  Produit.noProduit = :l_num_produit;

                SELECT quantite
                INTO   l_qte_a_livrer;
                FROM    Commande
                WHERE  Produit.noProduit = :l_num_produit;

                DBMS_OUTPUT.PUT_LINE('NoProduit | CodeZebre | description | quantite');
                DBMS_OUTPUT.PUT_LINE('==============================================');
                DBMS_OUTPUT.PUT_LINE(l_num_produit || l_code_zebre || l_desc_prod || l_qte_a_livrer);

        END LOOP;
        CLOSE cur_produits_commandee;
END;
/