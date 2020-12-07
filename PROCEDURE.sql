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


CREATE OR REPLACE PROCEDURE DetailFacture(noLivraison_facture IN CHAR) IS

FactureNoLivraison CHAR;

BEGIN
SELECT Facture.noLivraison, Livraison.dateLivraison, Commande.noCommande, Commande.noClient, noProduit, LigneCommande.quantite, ProduitPrix.prix, TypeProduit.description, Client.prenom, Client.nom, Client.telephone, Client.noCivique, Client.rue, Client.ville, Client.pays, Client.codePostal
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
WHERE noLivraison_facture = Facture.noLivraison;

FOR ROW IN Facture
LOOP
        DBMS_OUTPUT.PUT_LINE('No Client: ' || Commande.noClient);
        DBMS_OUTPUT.PUT_LINE('No Facture: ' || Facture.noLivraison);
        DBMS_OUTPUT.PUT_LINE('No Livraison: ' || Facture.noLivraison);
        DBMS_OUTPUT.PUT_LINE('Date de la livraison: ' || Livraison.dateLivraison);
        DBMS_OUTPUT.PUT_LINE('Livrée à cette addresse: ');
        DBMS_OUTPUT.PUT_LINE(Client.nom);
        DBMS_OUTPUT.PUT_LINE(Client.prenomnom);
        DBMS_OUTPUT.PUT_LINE(Client.noCivique);
        DBMS_OUTPUT.PUT_LINE(Client.rue);
        DBMS_OUTPUT.PUT_LINE(Client.ville);
        DBMS_OUTPUT.PUT_LINE(Client.pays);
        DBMS_OUTPUT.PUT_LINE(Client.codePostal);
        DBMS_OUTPUT.PUT_LINE('Voici la liste détaillée de la commande ' || Commande.noCommande);
        DBMS_OUTPUT.PUT_LINE('No Commande: ' || Commande.noCommande);
        DBMS_OUTPUT.PUT_LINE('No Commande: ' || Commande.noCommande);
        DBMS_OUTPUT.PUT_LINE('No Commande: ' || Commande.noCommande);
        DBMS_OUTPUT.PUT_LINE('No Commande: ' || Commande.noCommande);

