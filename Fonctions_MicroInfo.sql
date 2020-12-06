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

CREATE OR REPLACE PROCEDURE p_ProduireFacture
(unNoLivraison Facture.NoLivraison%TYPE , uneDateLimite Facture.dateLimitePaiement%TYPE) 

DECLARE
unMontantTotal Facture.montantSousTotal%TYPE

BEGIN

END;
/