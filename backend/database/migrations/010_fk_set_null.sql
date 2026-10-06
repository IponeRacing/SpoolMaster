-- 010 : clés étrangères ON DELETE SET NULL prévues par la migration 003,
-- absentes de la prod (constat du 06.10.2026) : apple_notifications existait
-- déjà (migration 001), son CREATE TABLE IF NOT EXISTS n'a rien fait ; idem
-- pour subscription_events. Sans elles, la suppression d'un compte laissait
-- son user_id sur ces lignes (la purge les détache maintenant aussi en PHP).
--
-- Idempotente : orphelins détachés d'abord, clés ajoutées si absentes.

UPDATE subscription_events e LEFT JOIN users u ON u.user_id = e.user_id
   SET e.user_id = NULL
 WHERE e.user_id IS NOT NULL AND u.user_id IS NULL;

UPDATE subscription_events e LEFT JOIN subscriptions s ON s.id = e.subscription_id
   SET e.subscription_id = NULL
 WHERE e.subscription_id IS NOT NULL AND s.id IS NULL;

UPDATE apple_notifications n LEFT JOIN users u ON u.user_id = n.user_id
   SET n.user_id = NULL
 WHERE n.user_id IS NOT NULL AND u.user_id IS NULL;

ALTER TABLE apple_notifications
    ADD CONSTRAINT fk_apple_notif_user FOREIGN KEY IF NOT EXISTS (user_id)
        REFERENCES users(user_id) ON DELETE SET NULL;

ALTER TABLE subscription_events
    ADD CONSTRAINT fk_sub_event_subscription FOREIGN KEY IF NOT EXISTS (subscription_id)
        REFERENCES subscriptions(id) ON DELETE SET NULL,
    ADD CONSTRAINT fk_sub_event_user FOREIGN KEY IF NOT EXISTS (user_id)
        REFERENCES users(user_id) ON DELETE SET NULL;
