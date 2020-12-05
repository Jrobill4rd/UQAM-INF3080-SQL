SET ECHO ON
-- Script Oracle SQL*plus de creation du schema Micro-Info
-- Version sans accents

-- Creation des fonctions
SET ECHO ON

CREATE FUNCTION fQuantiteDejaLivree
(unNoProduit LigneLivraison.noProduit%TYPE, unNoCommande LigneLivraison.noCommande%TYPE)
RETURN  Commande.quantiteDejaLivree%TYPE IS 

    uneQuantiteDejalivree LigneLivraison.quantiteDejaLivree%TYPE
BEGIN 
   SELECT   SUM(quantiteLivre)
   INTO     uneQuantitelivree
   FROM     LigneLivraison
   WHERE    (noProduit = unNoProduit) AND (noCommande = unNoCommande)
   RETURN   uneQuantiteDejaLivree;
END fQuantiteDejaLivree;

/
CREATE FUNCTION fTotalFacture
(unNoLivraison Facture.noLivraison%TYPE)
RETURN Facture.montantTotalFacture%TYPE

    unMontantTotalFacture Facture.montantTotalFacture%TYPE
BEGIN
    SELECT  SUM(montantSousTotal + montantTaxes)
    INTO    unMontantTotalFacture
    FROM    Facture
    WHERE   noLivraison = unNoLivraison;
    RETURN  unMontantTotalFacture;
END fTotalFacture
/