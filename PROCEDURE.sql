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

l_facture_livraison LigneCommande%ROWTYPE;

CURSOR produitscommande IS
         SELECT        
                  LigneCommande.noProduit produit,
                  LigneCommande.quantite quantite,
                  ProduitPrix.prix prix,
                  TypeProduit.description description
         FROM LigneCommande, ProduitPrix, TypeProduit
         WHERE no_livraison = LigneLivraison.noLivraison AND LigneLivraison.noCommande = LigneCommande.noCommande
         AND LigneCommande.noProduit = ProduitPrix.noProduit AND LigneCommande.noProduit = TypeProduit.noProduit ;
                  
 
 l_facture_curseur produitscommande%ROWTYPE;
 l_facture_prixtotal ProduitPrix.prix%TYPE;
 
 BEGIN
      OPEN produitscommande;
      FETCH produitscommande INTO l_facture_curseur;
      CLOSE produitscommande
     
         SELECT
                Facture.noLivraison nolivraison,
                Livraison.dateLivraison datelivraison,
                Commande.noCommande nocommande,
                Commande.noClient noclient,
                Client.prenom prenom,
                Client.nom nom,
                Client.telephone telephone,
                Client.noCivique nocivique,
                Client.rue rue,
                Client.ville ville,
                Client.pays pays,
                Client.codePostal codepostal
        INTO
                l_facture_livraison
               
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
                noLivraison_facture = nolivraison;

        DBMS_OUTPUT.PUT_LINE('No Client: ' || l_facture_livraison.noclient);
        DBMS_OUTPUT.PUT_LINE('No Facture: ' || l_facture_livraison.noLivraison);
        DBMS_OUTPUT.PUT_LINE('No Livraison: ' || l_facture_livraison.livraison);
        DBMS_OUTPUT.PUT_LINE('Date de la livraison: ' || l_facture_livraison.datelivraison);
        DBMS_OUTPUT.PUT_LINE('Livrée à cette addresse: ');
        DBMS_OUTPUT.PUT_LINE(l_facture_livraison.nom);
        DBMS_OUTPUT.PUT_LINE(l_facture_livraison.prenom);
        DBMS_OUTPUT.PUT_LINE(l_facture_livraison.nocivique);
        DBMS_OUTPUT.PUT_LINE(l_facture_livraison.rue);
        DBMS_OUTPUT.PUT_LINE(l_facture_livraison.ville);
        DBMS_OUTPUT.PUT_LINE(l_facture_livraison.pays);
        DBMS_OUTPUT.PUT_LINE(l_facture_livraison.codepostal);
        DBMS_OUTPUT.PUT_LINE('Voici la liste détaillée de la commande ' || l_facture_curseur);

END;
