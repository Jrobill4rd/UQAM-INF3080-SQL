--===========================================
--@Auteur: Jeffrey Robillard
--Code Permanent: ROBJ20039301
--@Auteur: Angélie Ménard
--Code Permanent:
--Date de création: 2020-12-23
--Description: MENA16569906
--Script de Supression des Tables
-- ===========================================
SET ECHO ON

--==============================
-- Suppression des tables
--==============================

SET ECHO ON
DROP TABLE usager CASCADE CONSTRAINTS;
DROP TABLE Fournisseur CASCADE CONSTRAINTS;
DROP TABLE Produit CASCADE CONSTRAINTS;
DROP TABLE PrioriteFournisseur CASCADE CONSTRAINTS;
DROP TABLE Client CASCADE CONSTRAINTS;
DROP TABLE TypeProduit CASCADE CONSTRAINTS;
DROP TABLE ProduitPrix CASCADE CONSTRAINTS;
DROP TABLE Commande CASCADE CONSTRAINTS;
DROP TABLE LigneCommande CASCADE CONSTRAINTS;
DROP TABLE Livraison CASCADE CONSTRAINTS;
DROP TABLE LigneLivraison CASCADE CONSTRAINTS;
DROP TABLE Facture CASCADE CONSTRAINTS;
DROP TABLE Paiement CASCADE CONSTRAINTS;
DROP TABLE PaiementCheque CASCADE CONSTRAINTS;
DROP TABLE PaiementCarteCredit CASCADE CONSTRAINTS;
