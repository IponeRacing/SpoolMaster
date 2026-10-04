-- ============================================
-- Migration: jeton Sign in with Apple (révocation à la suppression du compte)
-- ============================================
-- Apple exige (Guideline 5.1.1(v)) la révocation des jetons Sign in with
-- Apple quand l'utilisateur supprime son compte. Le refresh_token Apple est
-- obtenu au login en échangeant l'authorizationCode envoyé par l'app.
-- Additif, rejouable. À exécuter AVANT de déployer AuthController /
-- UserController / AccountPurgeService.
-- ============================================

ALTER TABLE users
    ADD COLUMN IF NOT EXISTS apple_refresh_token TEXT NULL AFTER refresh_token;
