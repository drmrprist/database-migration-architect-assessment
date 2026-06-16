#!/usr/bin/env bash
set -euo pipefail
APP_URL=${APP_URL:-http://localhost:8080}
REPORT="smoke-test-report-$(date +%Y%m%d_%H%M%S).txt"
PASS=0; FAIL=0

check() {
    local desc=$1 url=$2 expected=$3
    code=$(curl -s -o /dev/null -w "%{http_code}" "$url" --max-time 10 2>/dev/null || echo "000")
    if [[ "$code" == "$expected" ]]; then
        echo "[PASS] $desc ($code)" | tee -a "$REPORT"; ((PASS++))
    else
        echo "[FAIL] $desc expected=$expected got=$code" | tee -a "$REPORT"; ((FAIL++))
    fi
}

echo "=== Smoke Test: $APP_URL ===" | tee "$REPORT"
check "Health endpoint"   "$APP_URL/health" "200"
check "Catalog page"      "$APP_URL/"        "200"
check "API catalog items" "$APP_URL/api/catalog/items?pageSize=5" "200"
echo "=== Results: PASS=$PASS FAIL=$FAIL ===" | tee -a "$REPORT"
[[ $FAIL -eq 0 ]] && exit 0 || exit 1
