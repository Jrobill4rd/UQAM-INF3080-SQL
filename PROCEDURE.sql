-- procédure pour créer une facture


-- 1. prendre un numéro de livraison et la date limite du paiement

-- 2. insérer les données à la base de donnée

-- 3. Affichage des information sur la facture à la de PACKAGE PL/SQL DBMS_OUTPUT

-- informations
--numéro client
--son nom, prénom, adresse
--no livraison (qui est aussi no facture)
--date livraison
--liste détaillée des produits livrés

CREATE OR REPLACE PROCEDURE DetailFacture ( no_livraison NUMBER ) IS

DECLARE

l_facture_no_livraison Facture.noLivraison%TYPE;
l_facture_date_livraison Livraison.dateLivraison%TYPE;
l_facture_no_commande Commande.noCommande%TYPE;
l_facture_no_client Commande.noClient%TYPE;
l_facture_no_produit LigneCommande.noProduit%TYPE;
l_facture_quantite LigneCommande.quantite%TYPE;
l_facture_prix_produit ProduitPrix.prix%TYPE
l_facture_description_produit TypeProduit.description%TYPE;
l_facture_prenom_client Client.prenom%TYPE;
l_facture_nom_client Client.nom%TYPE;
l_facture_telephone_client Client.telephone%TYPE;
l_facture_noCivique_client Client.noCivique%TYPE;
l_facture_rue_client Client.rue%TYPE;
l_facture_ville_client Client.ville%TYPE;
l_facture_pays_client Client.pays%TYPE;
l_facture_codepostal_client Client.codePostal%TYPE;

CURSOR detailscommande IS
         SELECT
                Facture.noLivraison,
                Livraison.dateLivraison,
                Commande.noCommande,
                Commande.noClient,
                LigneCommande.noProduit,
                LigneCommande.quantite,
                ProduitPrix.prix,
                TypeProduit.description,
                Client.prenom,
                Client.nom,
                Client.telephone,
                Client.noCivique,
                Client.rue,
                Client.ville,
                Client.pays,
                Client.codePostal

        FROM Facture
                INNER JOIN Livraison
                        ON Facture.noLivraison = Livraison.noLivraison
                INNER JOIN LigneLivraison
                        ON Livraison.noLivraison = LigneLivraison.noLivraison
                INNER JOIN Commande
                        ON LigneLivraison.noCommande = Commande.noCommande
                INNER JOIN LigneCommande
                        ON Commande.noCommande = LigneCommande.noCommande
                INNER JOIN TypeProduit
                        ON LigneCommande.noProduit = TypeProduit.noProduit
                INNER JOIN ProduitPrix
                        ON TypeProduit.noProduit = ProduitPrix.noProduit
                INNER JOIN Client
                        ON Commande.noClient = Client.noClient

        WHERE
                noLivraison_facture = Facture.noLivraison;

BEGIN

        OPEN detailscommande;
        FETCH detailscommande INTO
                l_facture_no_livraison,
                l_facture_date_livraison,
                l_facture_no_commande,
                l_facture_no_client,
                l_facture_no_produit,
                l_facture_quantite,
                l_facture_prix_produit,
                l_facture_description_produit,
                l_facture_prenom_client,
                l_facture_nom_client,
                l_facture_telephone_client,
                l_facture_noCivique_client,
                l_facture_rue_client,
                l_facture_ville_client,
                l_facture_pays_client,
                l_facture_codepostal_client;

        DBMS_OUTPUT.PUT_LINE('No Client: ' || l_facture_no_client);
        DBMS_OUTPUT.PUT_LINE('No Facture: ' || Facture.noLivraison);
        DBMS_OUTPUT.PUT_LINE('No Livraison: ' || l_facture_no_livraison);
        DBMS_OUTPUT.PUT_LINE('Date de la livraison: ' || l_facture_date_livraison);
        DBMS_OUTPUT.PUT_LINE('Livrée à cette addresse: ');
        DBMS_OUTPUT.PUT_LINE(l_facture_nom_client);
        DBMS_OUTPUT.PUT_LINE(l_facture_prenom_client);
        DBMS_OUTPUT.PUT_LINE(l_facture_noCivique_client);
        DBMS_OUTPUT.PUT_LINE(l_facture_rue_client);
        DBMS_OUTPUT.PUT_LINE(l_facture_ville_client);
        DBMS_OUTPUT.PUT_LINE(l_facture_pays_client);
        DBMS_OUTPUT.PUT_LINE(l_facture_codepostal_client);
        DBMS_OUTPUT.PUT_LINE('Voici la liste détaillée de la commande ' || l_facture_no_commande);
        DBMS_OUTPUT.PUT_LINE(l_facture_quantite || 'No produit: ' || l_facture_no_produit || ', prix du produit : ' || l_facture_prix_produit);
        DBMS_OUTPUT.PUT_LINE('Description du produit: ' || l_facture_description_produit);

        COMMIT;
        CLOSE detailscommande;

END;



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

                SELECT des



        END LOOP;
        CLOSE cur_produits_commandee;
END;
/
