#!/usr/bin/env bash

set -uo pipefail

NAMESPACE="identity"
POSTGRES_APP="keycloak-postgresql"
PVC_NAME="keycloak-postgresql-data"

PASSED=0
FAILED=0

pass() {
    echo "PASS: $1"
    PASSED=$((PASSED + 1))
}

fail() {
    echo "FAIL: $1"
    FAILED=$((FAILED + 1))
}

echo "========================================"
echo " Keycloak Persistence Test"
echo "========================================"
echo

echo "[1] Checking PostgreSQL pod"
POSTGRES_POD=$(kubectl get pods \
    -n "$NAMESPACE" \
    -l "app=$POSTGRES_APP" \
    -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

if [[ -n "$POSTGRES_POD" ]]; then
    STATUS=$(kubectl get pod "$POSTGRES_POD" \
        -n "$NAMESPACE" \
        -o jsonpath='{.status.phase}')

    if [[ "$STATUS" == "Running" ]]; then
        pass "PostgreSQL pod is Running"
    else
        fail "PostgreSQL pod is not Running"
    fi
else
    fail "PostgreSQL pod not found"
fi

echo
echo "[2] Checking PostgreSQL PVC"

PVC_STATUS=$(kubectl get pvc "$PVC_NAME" \
    -n "$NAMESPACE" \
    -o jsonpath='{.status.phase}' 2>/dev/null)

if [[ "$PVC_STATUS" == "Bound" ]]; then
    pass "PostgreSQL PVC is Bound"
else
    fail "PostgreSQL PVC is not Bound"
fi

echo
echo "[3] Checking Keycloak database schema"

TABLE_COUNT=$(kubectl exec \
    -n "$NAMESPACE" \
    "$POSTGRES_POD" \
    -- psql -U keycloak -d keycloak -tAc \
    "SELECT count(*) FROM information_schema.tables WHERE table_schema='public';" \
    2>/dev/null)

if [[ "$TABLE_COUNT" =~ ^[0-9]+$ ]] && [[ "$TABLE_COUNT" -gt 0 ]]; then
    pass "Keycloak database contains $TABLE_COUNT tables"
else
    fail "Keycloak database schema is empty or unavailable"
fi

echo
echo "========================================"
echo " Test Summary"
echo "========================================"
echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo "Total : $((PASSED + FAILED))"
echo

if [[ "$FAILED" -eq 0 ]]; then
    echo "RESULT: KEYCLOAK PERSISTENCE CHECK PASSED"
    exit 0
else
    echo "RESULT: KEYCLOAK PERSISTENCE CHECK FAILED"
    exit 1
fi