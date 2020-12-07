SET SERVEROUTPUT ON

-- test check type usager
/* TEST QUI FONCTIONNE == VRAI */
/* Creation d'un usager */

INSERT INTO Usager VALUES (001, 'INF3080', 'Client');

/* TEST QUI NE FONCTIONNE PAS == FAUX */
/* Creation d'un usager */

INSERT INTO Usager VALUES (002, 'Banane3', 'Rongeur');

-- test type de commande "status"
/* TEST QUI FONCTIONNE == VRAI */
/* Creation d'une commande */

INSERT INTO Client VALUES (01,001, 'John', 'Doe', '0-000-0000', 'Sociable', 000, 'des oiseaux', 'Montreal', 'Canada', 'H0H0H0');

INSERT INTO Commande VALUES(0001, 01, '2020-12-06', 'Payee');

/* TEST QUI NE FONCTIONNE PAS == FAUX */
/* Creation d'une commande */

INSERT INTO Usager VALUES (002, 'Banane3', 'Client');

INSERT INTO Client VALUES (02,002, 'John', 'Doe', '0-000-0000', 'Sociable', 000, 'des oiseaux', 'Montreal', 'Canada', 'H0H0H0');

INSERT INTO Commande VALUES(0002, 02, '2020-12-06', 'Au depanneur');

-- test check quantitee commandee
/* TEST QUI FONCTIONNE == VRAI */
/* Creation d'une ligne de commande */

INSERT INTO Produit VALUES (01,'000000000001');

INSERT INTO LigneCommande VALUES(0001, 01, 12);

/* TEST QUI NE FONCTIONNE PAS == FAUX */
/* Creation d'une ligne de commande */

INSERT INTO Produit VALUES (02,'000000000002');

INSERT INTO Commande VALUES (0002, 02, '2020-12-16', 'Payee');

INSERT INTO LigneCommande VALUES (0002, 02, -1);

-- test check type de carte de credit
/* TEST QUI FONCTIONNE == VRAI */
/* Creation d'un paiement par carte */

INSERT INTO Livraison VALUES (0001, 01, '2021-01-01');

INSERT INTO Paiement VALUES (0001, 0001, '2020-12-16', 2000 );

INSERT INTO PaiementCarteCredit VALUES (0001, '0000 0000 0000' , 'Visa', '2025-01-01');

/* TEST QUI NE FONCTIONNE PAS == FAUX */
/* Creation d'un paiement par carte */

INSERT INTO Livraison VALUES (0002, 02, '2021-01-01');

INSERT INTO Paiement VALUES (0002, 0002, '2020-12-16', 2000 );

INSERT INTO PaiementCarteCredit VALUES (0002, '0000 0000 0000' , 'Capital One', '2021-05-16');

-- test trigger quantite en stock
/* TEST QUE LE TRIGGER FONCTIONNE == VRAI */

INSERT INTO TypeProduit VALUES (01, 'Disque Dur', 20, 50);

SELECT quantiteEnStock
FROM TypeProduit;

INSERT INTO LigneLivraison VALUES (0001, 01, 0001, 15);

SELECT quantiteEnStock
FROM TypeProduit;

-- test trigger bloquer la livraison dun article > que la quantite en stock
/* TEST QUI FONCTIONNE == VRAI */

INSERT INTO LigneLivraison VALUES (0002, 01, 0002, 55)

-- test trigger bloquer la livraison article > ce qui est deja livree
/* TEST QUI FONCTIONNE == VRAI */



-- test trigger paiement total
/* TEST QUI FONCTIONNE == VRAI */



-- test fonction quantite deja livree
/* TEST QUI FONCTIONNE == VRAI */



-- test total facture
/* TEST QUI FONCTIONNE == VRAI */
