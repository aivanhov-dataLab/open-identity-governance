#!/usr/bin/env bash

set -euo pipefail

NAMESPACE="workloads"

assert_permission() {
    local identity="$1"
    local resource="$2"
    local verb="$3"
    local expected="$4"

    result=$(kubectl auth can-i "$verb" "$resource" \
        --as="system:serviceaccount:${NAMESPACE}:${identity}" \
        -n "$NAMESPACE")

    if [[ "$result" != "$expected" ]]; then
        echo "FAIL: ${identity} ${verb} ${resource} -> expected ${expected}, got ${result}"
        exit 1
    fi

    echo "PASS: ${identity} ${verb} ${resource} -> ${result}"
}

echo "Running Kubernetes RBAC tests..."
echo

# Developer
assert_permission developer pods get yes
assert_permission developer deployments create yes
assert_permission developer secrets get no
assert_permission developer pods delete no

# Analyst
assert_permission analyst pods get yes
assert_permission analyst deployments get yes
assert_permission analyst deployments create no
assert_permission analyst secrets get no

# Administrator
assert_permission administrator secrets get yes
assert_permission administrator deployments delete yes

echo
echo "All RBAC tests passed."
