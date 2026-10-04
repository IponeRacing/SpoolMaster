-- ============================================
-- Migration 007 : couleurs ARGB + préférences explicites
-- ============================================
-- 1. color_rgb : INT signé → BIGINT. L'app envoie des couleurs ARGB
--    0xFFrrggbb (> 2^31-1). En sql_mode non strict, MariaDB les tronquait en
--    silence à 2147483647 : 31 bobines actives touchées en prod (04.10.2026),
--    rendues ensuite en blanc translucide au pull.
-- 2. user_preferences.prefs_explicit : 1 quand l'app a envoyé ses préférences
--    (PUT /user/profile). Sinon GET /user/profile renvoie null pour langue,
--    devise, unités et seuil : les valeurs par défaut de la table (fr / CHF /
--    100) n'écrasent plus les réglages du téléphone à la connexion.
-- Additif et rejouable. À exécuter AVANT de déployer UserController.php.
-- ============================================

ALTER TABLE spools MODIFY color_rgb BIGINT NULL;
ALTER TABLE shopping_list MODIFY color_rgb BIGINT NULL;
ALTER TABLE spool_usage MODIFY color_rgb BIGINT NULL;

ALTER TABLE user_preferences
    ADD COLUMN IF NOT EXISTS prefs_explicit TINYINT(1) NOT NULL DEFAULT 0
    COMMENT '1 = préférences envoyées par l''app (sinon non renvoyées)';
