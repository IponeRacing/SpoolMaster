#!/usr/bin/env bash
# Tests du backend Spool Master, sans réseau ni prod :
#  - MariaDB jetable (port 3399 par défaut), chargée avec database/schema.sql ;
#  - chaîne de certificats « Apple » de test générée ici (rien de secret versionné) ;
#  - chaque tests/test_*.php exécuté en processus (contrôleurs appelés directement).
#
# Usage : backend/tests/run.sh            (tous les fichiers)
#         backend/tests/run.sh privacy    (fichiers dont le nom contient « privacy »)
# Optionnel : APPLE_REAL_JWS_TSV=fichier.tsv (vraies transactions App Store,
# « env<TAB>jws » par ligne, jamais dans le dépôt) pour test_jws_verifier.php.
set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "$HERE")
PORT=${TEST_DB_PORT:-3399}
WORK=$(mktemp -d "${TMPDIR:-/tmp}/spoolmaster-tests.XXXXXX")
DBPID=""

cleanup() {
    if [ -n "$DBPID" ]; then kill "$DBPID" 2>/dev/null || true; wait "$DBPID" 2>/dev/null || true; fi
    rm -rf "$WORK"
}
trap cleanup EXIT

[ -d "$ROOT/vendor" ] || (cd "$ROOT" && composer install --quiet --no-interaction)

# --- Base jetable ---
mariadb-install-db --no-defaults --datadir="$WORK/db" --skip-test-db >"$WORK/install.log" 2>&1
mariadbd --no-defaults --datadir="$WORK/db" --port="$PORT" --bind-address=127.0.0.1 \
    --socket="$WORK/db.sock" >"$WORK/db.log" 2>&1 &
DBPID=$!
# Compte admin créé par mariadb-install-db : l'utilisateur système, par socket
admin() { mariadb --no-defaults --socket="$WORK/db.sock" -u"$(id -un)" "$@"; }
for _ in $(seq 1 50); do
    admin -e "SELECT 1" >/dev/null 2>&1 && break
    sleep 0.2
done
admin -e "CREATE DATABASE nfc_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
          CREATE USER 'sm_test'@'127.0.0.1' IDENTIFIED BY 'sm_test';
          GRANT ALL ON nfc_test.* TO 'sm_test'@'127.0.0.1';"
# Schéma + migrations dans l'ordre = schéma de la prod (comparé le 04.10.2026)
admin nfc_test < "$ROOT/database/schema.sql"
for m in "$ROOT"/database/migrations/*.sql; do
    admin nfc_test < "$m"
done

# --- Chaîne de certificats de test (sujets et extensions d'Apple) ---
PKI="$WORK/pki"; mkdir -p "$PKI"
cat > "$PKI/ext.cnf" <<'EOF'
[req]
distinguished_name=dn
[dn]
[root]
basicConstraints=critical,CA:TRUE
keyUsage=critical,keyCertSign,cRLSign
[inter]
basicConstraints=critical,CA:TRUE
keyUsage=critical,keyCertSign
1.2.840.113635.100.6.2.1=ASN1:NULL
[leaf]
basicConstraints=critical,CA:FALSE
1.2.840.113635.100.6.11.1=ASN1:NULL
[leafnooid]
basicConstraints=critical,CA:FALSE
EOF
# Validité commençant hier : les tests signent des notifications datées du
# passé, qu'un certificat émis à la seconde même rendrait invalides.
NB=$(date -u -v-1d +%Y%m%d%H%M%SZ 2>/dev/null || date -u -d '1 day ago' +%Y%m%d%H%M%SZ)
(
    cd "$PKI"
    for k in root inter leaf; do openssl ecparam -name prime256v1 -genkey -noout -out "$k.key.pem" 2>/dev/null; done
    openssl req -new -x509 -key root.key.pem -subj "/CN=Apple Root CA - G3/O=Apple Inc./C=US" -not_before "$NB" -days 30 \
        -config ext.cnf -extensions root -out root.pem 2>/dev/null
    openssl req -new -key inter.key.pem -subj "/CN=Apple Worldwide Developer Relations/O=Apple Inc." -config ext.cnf -out inter.csr 2>/dev/null
    openssl x509 -req -in inter.csr -CA root.pem -CAkey root.key.pem -CAcreateserial -not_before "$NB" -days 30 \
        -extfile ext.cnf -extensions inter -out inter.pem 2>/dev/null
    openssl req -new -key leaf.key.pem -subj "/CN=Prod ECC Mac App Store/O=Apple Inc." -config ext.cnf -out leaf.csr 2>/dev/null
    for e in leaf leafnooid; do
        openssl x509 -req -in leaf.csr -CA inter.pem -CAkey inter.key.pem -CAcreateserial -not_before "$NB" -days 30 \
            -extfile ext.cnf -extensions "$e" -out "$e.pem" 2>/dev/null
    done
)

# --- Environnement de test (valeurs factices) ---
cat > "$WORK/.env" <<EOF
DB_HOST=127.0.0.1;port=$PORT
DB_DATABASE=nfc_test
DB_USERNAME=sm_test
DB_PASSWORD=sm_test
APP_ENV=testing
APP_DEBUG=false
JWT_SECRET=$(openssl rand -hex 32)
CRON_SECRET=test-cron-secret
ADMIN_SECRET=test-admin-secret
APP_ENCRYPTION_KEY=$(openssl rand -base64 32)
GOOGLE_PUBSUB_AUDIENCE=https://api.test/webhooks/google-play
GOOGLE_PUBSUB_SERVICE_ACCOUNT=rtdn@test.iam.gserviceaccount.com
RATE_LIMIT_ENABLED=false
EOF

export SM_TEST_ENV="$WORK/.env" SM_TEST_PKI="$PKI" SM_TEST_LOG="$WORK/php_test.log"
failed=0
for t in "$HERE"/test_*.php; do
    case "$(basename "$t")" in *"${1:-}"*) ;; *) continue ;; esac
    echo "### $(basename "$t")"
    php "$t" || failed=1
    echo
done
if [ "$failed" -ne 0 ]; then
    echo "ÉCHEC — journal PHP : (supprimé à la sortie)"; tail -20 "$SM_TEST_LOG" 2>/dev/null || true
    exit 1
fi
echo "Tous les fichiers de test sont passés."
