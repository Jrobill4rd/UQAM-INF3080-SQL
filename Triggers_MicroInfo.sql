SET ECHO ON
-- Script Oracle SQL*plus de creation du schema Micro-Info
-- Version sans accents

-- ???? Suppression des tables
SET ECHO ON

-- Réduire la quantité en stock d'un article en fonction de la quantité LIVRÉE 
CREATE TRIGGER reduireQteEnStock
AFTER INSERT 
    ON LigneCommande FOR EACH ROW

BEGIN

UPDATE Iventaire /*trouver nom tableau */
SET Inventaire.Quantite = Inventaire.Quantite - LigneCommande.quantite
WHERE Inventaire.IDProduit = LigneCommande.IDProduit

END;	


-- Bloquer l'insertion d'une livraison d'un article lorsque la quantité livrée dépasse la quantité en stock
CREATE TRIGGER bloquerInsertionStock
BEFORE INSERT
FOR EACH ROW


-- Bloquer l'insertion d'un article lorsque la quantité totale livrée dépasse la quantité commandée de la commande
CREATE TRIGGER bloquerInsertionCommande
BEFORE INSERT 
FOR EACH ROW


--Bloquer l'insertion d'un paiement qui dépasse le montant qui reste à payer
CREATE TRIGGER bloquerPaiementDepassantMontant
BEFORE INSERT 
FOR EACH ROW
