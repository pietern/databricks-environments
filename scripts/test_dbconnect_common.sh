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
# Args: $1=env_path, $2=test_mode (add|sync-dev), $3=test_dir, $4=result_file
test_environment() {
    local env_path="$1"
    local test_mode="$2"
    local test_dir="$3"
    local result_file="$4"
    local work_dir="$5"

    (
        cd "$test_dir"
        echo "=== Environment: $env_path ===" > "$result_file"
        echo "=== Test mode: $test_mode ===" >> "$result_file"
        echo "" >> "$result_file"

        if [ "$test_mode" = "add" ]; then
            # Test mode 1: uv sync then uv add databricks-connect
            echo "Running uv sync..." >> "$result_file"
            if ! uv sync >> "$result_file" 2>&1; then
                echo "❌ uv sync failed" >> "$result_file"
                exit 1
            fi
            echo "✅ uv sync succeeded" >> "$result_file"
            echo "" >> "$result_file"

            echo "Adding databricks-connect..." >> "$result_file"
            if ! uv add databricks-connect >> "$result_file" 2>&1; then
                echo "❌ Failed to add databricks-connect" >> "$result_file"
                exit 1
            fi
            echo "✅ databricks-connect added successfully" >> "$result_file"

        elif [ "$test_mode" = "sync-dev" ]; then
            # Test mode 2: uv sync --extra dev (databricks-connect already in dev deps)
            echo "Running uv sync --extra dev..." >> "$result_file"
            if ! uv sync --extra dev >> "$result_file" 2>&1; then
                echo "❌ uv sync --extra dev failed" >> "$result_file"
                exit 1
            fi
            echo "✅ uv sync --extra dev succeeded" >> "$result_file"
        fi

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
