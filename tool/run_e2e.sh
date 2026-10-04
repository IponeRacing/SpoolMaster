#!/usr/bin/env bash
# Lance le test E2E Stock sur un appareil et range log + captures.
# Usage : tool/run_e2e.sh <device_id> <nom_court>
set -uo pipefail
cd "$(dirname "$0")/.."
DEVICE_ID="$1"; NAME="$2"
mkdir -p build/e2e_logs build/e2e_screenshots
E2E_SHOTS=build/e2e_screenshots fvm flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/stock_features_e2e_test.dart \
  --dart-define=E2E_MODE=true --dart-define=E2E_DEVICE="$NAME" \
  -d "$DEVICE_ID" > "build/e2e_logs/$NAME.log" 2>&1
CODE=$?
echo "EXIT $CODE" >> "build/e2e_logs/$NAME.log"
grep -E "📐|All tests passed|Some tests failed|Expected:|Actual:" "build/e2e_logs/$NAME.log" | sed "s/^/[$NAME] /"
exit $CODE
