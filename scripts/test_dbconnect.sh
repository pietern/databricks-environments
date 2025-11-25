#!/bin/bash
set -euo pipefail

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# WORK_DIR is the constraint_output directory (parent of scripts/)
WORK_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Source common functions
source "$SCRIPT_DIR/test_dbconnect_common.sh"

# Parse arguments
TEST_MODE="${1:-add}"  # Default to "add" mode
PARALLEL="${2:-1}"     # Number of parallel tests (default: 1 for CI safety)

# Validate test mode
if [[ "$TEST_MODE" != "add" && "$TEST_MODE" != "sync-dev" ]]; then
    echo "Usage: $0 <test_mode> [parallel_jobs]"
    echo "  test_mode: 'add' (uv add) or 'sync-dev' (uv sync --extra dev)"
    echo "  parallel_jobs: number of parallel tests (default: 1)"
    exit 1
fi

# Change to working directory (constraint_output/)
cd "$WORK_DIR"

# Find all environment paths (looking in dbr/ and serverless/ subdirectories)
ENVS=$(find dbr serverless -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort || true)

if [ -z "$ENVS" ]; then
    echo "Error: No environments found in dbr/ or serverless/"
    exit 1
fi

# Create output directory for results
if [ "$TEST_MODE" = "add" ]; then
    MODE_NAME="uv-add"
else
    MODE_NAME="uv-sync-dev"
fi

RESULTS_DIR="$WORK_DIR/tmp/dbconnect-test-${MODE_NAME}-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$RESULTS_DIR"

echo "Testing databricks-connect installation for all environments"
echo "Test mode: $TEST_MODE"
echo "Results directory: $RESULTS_DIR"
echo ""

TOTAL=$(echo "$ENVS" | wc -l)
COUNT=0
SUCCESS=0
FAILED=0
FAILED_ENVS=""

# Run tests
for env_path in $ENVS; do
    COUNT=$((COUNT + 1))
    ENV_NAME=$(basename "$env_path")

    if [ -z "${CI:-}" ]; then
        echo "[$COUNT/$TOTAL] Testing: $env_path"
    else
        # In CI, use GitHub Actions log grouping
        echo "::group::[$COUNT/$TOTAL] Testing: $env_path"
    fi

    # Create test directory
    TEST_DIR="$WORK_DIR/tmp/dbconnect-test-${MODE_NAME}-${ENV_NAME}"
    rm -rf "$TEST_DIR"
    mkdir -p "$TEST_DIR"

    # Copy pyproject.toml
    if ! cp "$WORK_DIR/$env_path/pyproject.toml" "$TEST_DIR/"; then
        echo "  ❌ FAILED: Could not copy pyproject.toml"
        FAILED=$((FAILED + 1))
        FAILED_ENVS="${FAILED_ENVS}${env_path}\n"
        [ -n "${CI:-}" ] && echo "::endgroup::"
        continue
    fi

    # Run test
    RESULT_FILE="$RESULTS_DIR/${env_path//\//_}.txt"

    if test_environment "$env_path" "$TEST_MODE" "$TEST_DIR" "$RESULT_FILE" "$WORK_DIR"; then
        echo "  ✅ SUCCESS"
        SUCCESS=$((SUCCESS + 1))
    else
        echo "  ❌ FAILED"
        FAILED=$((FAILED + 1))
        FAILED_ENVS="${FAILED_ENVS}${env_path}\n"

        # In CI, print the error details
        if [ -n "${CI:-}" ]; then
            echo "::error::Failed to install databricks-connect for $env_path"
            tail -20 "$RESULT_FILE"
        fi
    fi

    [ -n "${CI:-}" ] && echo "::endgroup::"
    echo ""
done

# Generate summary report
SUMMARY_FILE="$RESULTS_DIR/SUMMARY.txt"
{
    echo "=== Test Summary: $MODE_NAME ==="
    echo ""
    echo "Total environments tested: $TOTAL"
    echo "Successful: $SUCCESS"
    echo "Failed: $FAILED"
    echo ""
    if [ "$FAILED" -gt 0 ]; then
        echo "Failed environments:"
        echo -e "$FAILED_ENVS"
    fi
    echo "Detailed results in: $RESULTS_DIR"
} > "$SUMMARY_FILE"

# Print summary
print_summary "$MODE_NAME" "$TOTAL" "$SUCCESS" "$FAILED" "$RESULTS_DIR"

# Exit with error if any tests failed
if [ "$FAILED" -gt 0 ]; then
    echo ""
    echo "Some tests failed. See details in $RESULTS_DIR"
    exit 1
fi

echo ""
echo "All tests passed!"
exit 0
