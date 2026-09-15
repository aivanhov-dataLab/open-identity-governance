#!/usr/bin/env bash

set -uo pipefail

NAMESPACE="workloads"

PASSED=0
FAILED=0

assert_permission() {
    local identity="$1"
    local resource="$2"
    local verb="$3"
    local expected="$4"

    local result

    result=$(kubectl auth can-i "$verb" "$resource" \
        --as="system:serviceaccount:${NAMESPACE}:${identity}" \
        -n "$NAMESPACE" 2>&1) || true

    # kubectl may emit warnings before the actual authorization result.
    # Extract the final yes/no decision.
    result=$(printf '%s\n' "$result" | tail -n 1)

    if [[ "$result" != "yes" && "$result" != "no" ]]; then
        echo "ERROR: ${identity} ${verb} ${resource}"
        echo "       kubectl returned: ${result}"
        FAILED=$((FAILED + 1))
        return
    fi

    if [[ "$result" == "$expected" ]]; then
        echo "PASS: ${identity} ${verb} ${resource} -> ${result}"
        PASSED=$((PASSED + 1))
    else
        echo "FAIL: ${identity} ${verb} ${resource} -> expected ${expected}, got ${result}"
        FAILED=$((FAILED + 1))
    fi
}
echo "========================================"
echo " Kubernetes RBAC Test Suite"
echo "========================================"
echo

echo "[Developer]"
assert_permission developer pods get yes
assert_permission developer deployments create yes
assert_permission developer deployments update yes
assert_permission developer secrets get no
assert_permission developer pods delete no
assert_permission developer roles create no
assert_permission developer rolebindings create no
assert_permission developer clusterrolebindings create no

echo
echo "[Analyst]"
assert_permission analyst pods get yes
assert_permission analyst deployments get yes
assert_permission analyst deployments create no
assert_permission analyst deployments update no
assert_permission analyst secrets get no
assert_permission analyst roles create no
assert_permission analyst rolebindings create no
assert_permission analyst clusterrolebindings create no

echo
echo "[Administrator]"
assert_permission administrator pods get yes
assert_permission administrator deployments create yes
assert_permission administrator deployments delete yes
assert_permission administrator secrets get yes
assert_permission administrator roles create yes
assert_permission administrator rolebindings create yes
assert_permission administrator clusterrolebindings create yes

echo
echo "========================================"
echo " Test Summary"
echo "========================================"
echo "Passed: ${PASSED}"
echo "Failed: ${FAILED}"
echo "Total : $((PASSED + FAILED))"
echo

if [[ "$FAILED" -eq 0 ]]; then
    echo "RESULT: ALL RBAC TESTS PASSED"
    exit 0
else
    echo "RESULT: RBAC TESTS FAILED"
    exit 1
fi