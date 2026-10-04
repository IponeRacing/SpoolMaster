-- 009 : rattrapage du schéma sur la prod
--
-- La valeur 'lifetime' de user_preferences.subscription_type a été ajoutée à
-- la main en prod (VIP « à vie »), sans migration. Le dépôt donnait donc un
-- schéma différent pour une installation neuve.
--
-- DÉJÀ EN PROD au 04.10.2026 : inutile de l'y rejouer (sans effet si on le fait).
--
-- Comparaison complète prod / dépôt faite le 04.10.2026 : mêmes tables, mêmes
-- colonnes. Seule autre différence : les TIMESTAMP sont NOT NULL en prod
-- (MariaDB 10.4, explicit_defaults_for_timestamp=OFF), ce qui dépend du
-- serveur, pas du schéma.

ALTER TABLE user_preferences
    MODIFY subscription_type ENUM('monthly','yearly','lifetime') DEFAULT NULL;
