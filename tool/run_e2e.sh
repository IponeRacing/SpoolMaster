#!/usr/bin/env bash
# Lance le test E2E Stock sur un appareil et range log + captures.
# Usage : tool/run_e2e.sh <device_id> <nom_court>
#
# ⚠️ `flutter drive` DÉSINSTALLE l'app en fin de run par défaut
# (FlutterDriverService.stop → uninstallApp), ce qui efface ses données
# locales. Incident du 04.10.2026 : stock invité perdu sur un téléphone
# personnel. D'où :
#   - --keep-app-running systématique (l'app n'est jamais désinstallée) ;
#   - appareil physique refusé sauf E2E_ALLOW_PHYSICAL=1 ;
#   - sauvegarde des données de l'app avant tout run sur appareil physique.
set -uo pipefail
cd "$(dirname "$0")/.."
DEVICE_ID="$1"; NAME="$2"
ANDROID_PKG=com.engagengine.nfc_anycubic
IOS_BUNDLE=com.engageengine.nfcfilament
ADB="${ANDROID_HOME:-$HOME/Library/Android/sdk}/platform-tools/adb"
mkdir -p build/e2e_logs build/e2e_screenshots build/e2e_backups

# --- Appareil physique ? ---------------------------------------------------
physical=""
if "$ADB" devices 2>/dev/null | grep -q "^$DEVICE_ID[[:space:]]"; then
  [ "$("$ADB" -s "$DEVICE_ID" shell getprop ro.kernel.qemu 2>/dev/null | tr -d '\r')" = "1" ] || physical=android
elif ! xcrun simctl list devices 2>/dev/null | grep -q "$DEVICE_ID"; then
  physical=ios
fi

if [ -n "$physical" ]; then
  if [ "${E2E_ALLOW_PHYSICAL:-}" != "1" ]; then
    echo "❌ $DEVICE_ID est un appareil PHYSIQUE ($physical) : refusé."
    echo "   Relancer avec E2E_ALLOW_PHYSICAL=1 (sauvegarde auto + app jamais désinstallée)."
    exit 2
  fi
  STAMP=$(date +%Y%m%d-%H%M%S)
  if [ "$physical" = android ]; then
    OUT="build/e2e_backups/${NAME}_${STAMP}_FlutterSharedPreferences.xml"
    if "$ADB" -s "$DEVICE_ID" exec-out run-as "$ANDROID_PKG" cat shared_prefs/FlutterSharedPreferences.xml > "$OUT" 2>/dev/null && [ -s "$OUT" ]; then
      echo "💾 Sauvegarde Android : $OUT"
    elif "$ADB" -s "$DEVICE_ID" shell pm list packages 2>/dev/null | grep -q "$ANDROID_PKG"; then
      echo "❌ App installée mais sauvegarde impossible (build non debuggable ?) : arrêt."
      rm -f "$OUT"; exit 3
    else
      rm -f "$OUT"; echo "ℹ️ App absente de l'appareil : rien à sauvegarder."
    fi
  else
    OUT="build/e2e_backups/${NAME}_${STAMP}_ios_container"
    if xcrun devicectl device info apps --device "$DEVICE_ID" 2>/dev/null | grep -q "$IOS_BUNDLE"; then
      if xcrun devicectl device copy from --device "$DEVICE_ID" \
          --domain-type appDataContainer --domain-identifier "$IOS_BUNDLE" \
          --source Library --destination "$OUT" >/dev/null 2>&1; then
        echo "💾 Sauvegarde iOS : $OUT"
      else
        echo "❌ App installée mais sauvegarde impossible : arrêt."; exit 3
      fi
    else
      echo "ℹ️ App absente de l'appareil : rien à sauvegarder."
    fi
  fi
fi

E2E_SHOTS=build/e2e_screenshots fvm flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/stock_features_e2e_test.dart \
  --keep-app-running \
  --dart-define=E2E_MODE=true --dart-define=E2E_DEVICE="$NAME" \
  -d "$DEVICE_ID" > "build/e2e_logs/$NAME.log" 2>&1
CODE=$?
echo "EXIT $CODE" >> "build/e2e_logs/$NAME.log"
grep -E "📐|All tests passed|Some tests failed|Expected:|Actual:" "build/e2e_logs/$NAME.log" | sed "s/^/[$NAME] /"
exit $CODE
