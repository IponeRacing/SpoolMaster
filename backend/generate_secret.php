<?php
/**
 * Générateur de clé secrète JWT
 * Exécuter une seule fois : php generate_secret.php
 */

echo "=== NFC Anycubic - JWT Secret Generator ===\n\n";

$secret = bin2hex(random_bytes(32));

echo "Votre clé secrète JWT (64 caractères) :\n";
echo $secret . "\n\n";

echo "Copiez cette clé dans config/app.php à la ligne 'jwt_secret'\n\n";

echo "Exemple :\n";
echo "'jwt_secret' => '{$secret}',\n\n";

echo "⚠️  IMPORTANT : Ne partagez JAMAIS cette clé !\n";
echo "⚠️  Gardez-la privée et sécurisée.\n\n";
