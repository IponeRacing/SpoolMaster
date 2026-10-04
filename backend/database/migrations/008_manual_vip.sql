-- 008 : VIP manuel distinct du cache d'abonnement
--
-- Avant : user_preferences.is_vip servait à la fois aux VIP accordés à la main
-- (support, gestes commerciaux) et de cache des abonnements. Le cron
-- d'expiration et les webhooks le remettaient à 0 dès qu'aucun abonnement
-- n'était actif → VIP manuels effacés.
--
-- vip_manual = 1 : accordé à la main, jamais modifié par le code automatique
-- tant qu'il est actif (vip_expires_at NULL = à vie, ou date future).
--
-- Pour accorder un VIP à la main désormais :
--   INSERT INTO user_preferences (user_id, is_vip, vip_expires_at, vip_manual, subscription_type)
--   VALUES ('USER_ID', 1, '2027-12-31 23:59:59', 1, 'yearly')
--   ON DUPLICATE KEY UPDATE is_vip = 1, vip_expires_at = VALUES(vip_expires_at), vip_manual = 1,
--                           subscription_type = VALUES(subscription_type);

ALTER TABLE user_preferences
    ADD COLUMN vip_manual TINYINT(1) NOT NULL DEFAULT 0 AFTER vip_expires_at;

-- Reprise de l'existant : un is_vip = 1 est un cache d'abonnement si l'un des
-- abonnements de l'utilisateur a la même échéance (± 26 h : le code PHP et
-- MySQL n'écrivaient pas forcément dans le même fuseau). Sinon c'est un VIP
-- manuel. Dans le doute, on garde le VIP (personne ne perd son premium).
UPDATE user_preferences up
   SET up.vip_manual = 1
 WHERE up.is_vip = 1
   AND (
        (up.vip_expires_at IS NOT NULL AND NOT EXISTS (
            SELECT 1 FROM subscriptions s
             WHERE s.user_id = up.user_id
               AND s.expires_date IS NOT NULL
               AND ABS(TIMESTAMPDIFF(HOUR, s.expires_date, up.vip_expires_at)) <= 26))
     OR (up.vip_expires_at IS NULL AND NOT EXISTS (
            SELECT 1 FROM subscriptions s
             WHERE s.user_id = up.user_id
               AND s.expires_date IS NULL))
   );

-- Les abonnements Google Play étaient enregistrés sans plateforme (valeur
-- par défaut) : identifiant d'origine « gp_… » = Google Play.
UPDATE subscriptions SET platform = 'android' WHERE original_transaction_id LIKE 'gp\_%';
