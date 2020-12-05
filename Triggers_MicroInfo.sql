SET ECHO ON
-- Script Oracle SQL*plus de creation du schema Micro-Info
-- Version sans accents

-- Suppression des tables
SET ECHO ON
CREATE TRIGGER reduireQteEnStock
AFTER UPDATE ON LigneCommande
FOR EACH ROW

CREATE TRIGGER bloquerInsertionStock
BEFORE INSERT
FOR EACH ROW

CREATE TRIGGER bloquerInsertionCommande
BEFORE INSERT 
FOR EACH ROW

CREATE TRIGGER bloquerPaiementDepassantMontant
BEFORE INSERT 
FOR EACH ROW
