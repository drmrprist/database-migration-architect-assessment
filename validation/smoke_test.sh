#!/usr/bin/env bash
APP_URL=${APP_URL:-http://localhost:8080}
REPORT="smoke-test-report-$(date +%Y%m%d_%H%M%S).txt"
PASS=0
FAIL=0

check() {
    local desc=$1 url=$2 expected=$3
    code=$(curl -s -o /dev/null -w "%{http_code}" "$url" --max-time 15 2>/dev/null || echo "000")
    if [ "$code" = "$expected" ]; then
        echo "[PASS] $desc ($code)" | tee -a "$REPORT"
        PASS=$((PASS+1))
    else
        echo "[FAIL] $desc expected=$expected got=$code" | tee -a "$REPORT"
        FAIL=$((FAIL+1))
    fi
}

echo "=== Smoke Test: $APP_URL ===" | tee "$REPORT"
check "Catalog home page" "$APP_URL/" "200"
check "Login page" "$APP_URL/Identity/Account/Login" "200"
check "Basket page" "$APP_URL/Basket" "200"
echo "=== Results: PASS=$PASS FAIL=$FAIL ===" | tee -a "$REPORT"
if [ $FAIL -eq 0 ]; then exit 0; else exit 1; fi
