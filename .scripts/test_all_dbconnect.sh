#!/bin/bash
set -euo pipefail

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "========================================"
echo "Testing databricks-connect Installation"
echo "========================================"
echo ""
echo "This script runs two test modes:"
echo "1. Manual addition (uv add databricks-connect)"
echo "2. Dev dependencies (uv sync --extra dev)"
echo ""

# Test 1: Manual addition
echo "Starting Test 1: Manual addition (uv add databricks-connect)"
echo "----------------------------------------------------------------"
if ! "$SCRIPT_DIR/test_dbconnect.sh" add; then
    echo ""
    echo "❌ Test 1 FAILED"
    exit 1
fi
echo ""
echo "✅ Test 1 PASSED"
echo ""

# Test 2: Dev dependencies
echo "Starting Test 2: Dev dependencies (uv sync --extra dev)"
echo "----------------------------------------------------------------"
if ! "$SCRIPT_DIR/test_dbconnect.sh" sync-dev; then
    echo ""
    echo "❌ Test 2 FAILED"
    exit 1
fi
echo ""
echo "✅ Test 2 PASSED"
echo ""

echo "========================================"
echo "✅ All tests passed!"
echo "========================================"
