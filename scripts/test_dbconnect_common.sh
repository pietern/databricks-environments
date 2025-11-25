#!/bin/bash
# Common functions for databricks-connect testing

# Colors for output (disabled in CI)
if [ -z "${CI:-}" ]; then
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    YELLOW='\033[1;33m'
    NC='\033[0m' # No Color
else
    GREEN=''
    RED=''
    YELLOW=''
    NC=''
fi

# Test a single environment
# Args: $1=env_path, $2=test_dir, $3=result_file, $4=work_dir
test_environment() {
    local env_path="$1"
    local test_dir="$2"
    local result_file="$3"
    local work_dir="$4"

    (
        cd "$test_dir"
        echo "=== Environment: $env_path ===" > "$result_file"
        echo "" >> "$result_file"

        # Run uv sync (dev dependencies are installed by default)
        echo "Running uv sync..."
        echo "Running uv sync..." >> "$result_file"
        if ! uv sync 2>&1 | tee -a "$result_file"; then
            echo "❌ uv sync failed" | tee -a "$result_file"
            exit 1
        fi
        echo "✅ uv sync succeeded" | tee -a "$result_file"

        echo "" >> "$result_file"
        echo "Checking databricks-connect installation..." >> "$result_file"

        # Check if databricks-connect is installed
        DB_CONNECT_VERSION=$(uv pip list 2>/dev/null | grep databricks-connect | awk '{print $2}')
        if [ -n "$DB_CONNECT_VERSION" ]; then
            echo "✅ SUCCESS: databricks-connect installed" >> "$result_file"
            echo "   Version: $DB_CONNECT_VERSION" >> "$result_file"
            exit 0
        else
            echo "❌ FAILED: databricks-connect not found" >> "$result_file"
            exit 1
        fi
    )
    return $?
}

# Print test summary
print_summary() {
    local mode_name="$1"
    local total="$2"
    local success="$3"
    local failed="$4"
    local results_dir="$5"

    echo ""
    echo "========================================"
    echo "Test Summary: $mode_name"
    echo "========================================"
    echo "Total environments: $total"
    echo -e "${GREEN}Successful: $success${NC}"
    if [ "$failed" -gt 0 ]; then
        echo -e "${RED}Failed: $failed${NC}"
    else
        echo "Failed: $failed"
    fi
    echo "Results directory: $results_dir"
    echo "========================================"
}
