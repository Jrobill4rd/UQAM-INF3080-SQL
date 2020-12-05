SET ECHO ON
-- Script Oracle SQL*plus de creation du schema Micro-Info
-- Version sans accents

-- Creation des fonctions
SET ECHO ON

CREATE OR REPLACE FUNCTION fQteDejaLivree
(unNoProduit LigneLivraison.noProduit%TYPE, unNoCommande LigneLivraison.noCommande%TYPE)
RETURN  LigneLivraison.quantiteLivree%TYPE IS 

    uneQuantiteDejalivree LigneLivraison.quantiteLivree%TYPE;
BEGIN 
   SELECT   SUM(quantiteLivre)
   INTO     uneQuantitelivree
   FROM     LigneLivraison
   WHERE    (noProduit = unNoProduit) AND (noCommande = unNoCommande);
   RETURN   uneQuantiteDejaLivree;
END fQuantiteDejaLivree;
/

CREATE OR REPLACE FUNCTION fTotalFacture
(unNoLivraison Facture.noLivraison%TYPE)
RETURN Facture.montantSousTotal%TYPE IS

    unMontTotalFacture Facture.montantSousTotal%TYPE;
BEGIN
    SELECT  SUM(montantSousTotal + montantTaxes)
    INTO    unMontantTotalFacture
    FROM    Facture
    WHERE   noLivraison = unNoLivraison;
    RETURN  unMontTotalFacture;
END fTotalFacture;
/