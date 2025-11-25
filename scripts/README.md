# Test Scripts for Databricks Connect Installation

This directory contains scripts to validate that `databricks-connect` can be successfully installed across all environment constraint files.

## Directory Structure

```
.
├── dbr/                    # DBR environment constraint files
├── serverless/             # Serverless environment constraint files
├── scripts/                # Test scripts (this directory)
│   ├── test_dbconnect.sh           # Main test script
│   ├── test_all_dbconnect.sh       # Wrapper to run all tests
│   └── test_dbconnect_common.sh    # Shared functions
└── .github/
    └── workflows/
        └── test-databricks-connect.yml  # CI workflow
```

## Scripts

### `test_dbconnect.sh`

Main test script that validates databricks-connect installation for all environments.

**Usage:**
```bash
# From the repository root
./scripts/test_dbconnect.sh <test_mode> [parallel_jobs]
```

**Arguments:**
- `test_mode`: Either `add` or `sync-dev`
  - `add`: Test manual addition with `uv add databricks-connect`
  - `sync-dev`: Test dev dependency installation with `uv sync --extra dev`
- `parallel_jobs`: Number of parallel tests (default: 1, useful for local testing)

**Examples:**
```bash
# Test manual addition
./scripts/test_dbconnect.sh add

# Test dev dependencies
./scripts/test_dbconnect.sh sync-dev

# Run 4 tests in parallel (faster for local development)
./scripts/test_dbconnect.sh add 4
```

### `test_all_dbconnect.sh`

Wrapper script that runs both test modes sequentially.

**Usage:**
```bash
# From the repository root
./scripts/test_all_dbconnect.sh
```

This runs:
1. Manual addition test (`uv add databricks-connect`)
2. Dev dependencies test (`uv sync --extra dev`)

### `test_dbconnect_common.sh`

Shared functions and utilities used by the test scripts. Not meant to be run directly.

## Test Results

Test results are saved to `tmp/dbconnect-test-<mode>-<timestamp>/`:

- Individual environment results: `tmp/dbconnect-test-<mode>-<timestamp>/<env_name>.txt`
- Summary report: `tmp/dbconnect-test-<mode>-<timestamp>/SUMMARY.txt`

## GitHub Actions

The `.github/workflows/test-databricks-connect.yml` workflow automatically runs these tests on:

- Push to `main` branch (when constraint files or test scripts change)
- Pull requests to `main`
- Manual workflow dispatch

The workflow runs both test modes in parallel and uploads test results as artifacts.

## Exit Codes

- `0`: All tests passed
- `1`: One or more tests failed

## CI Environment

The scripts automatically detect when running in CI (via `$CI` environment variable) and:
- Disable color output
- Use GitHub Actions log grouping
- Report errors using GitHub Actions annotations
- Skip interactive prompts

## Local Development

For faster local testing, you can:

1. Test a specific mode:
   ```bash
   ./scripts/test_dbconnect.sh add
   ```

2. Run tests in parallel (use with caution, may consume significant CPU/memory):
   ```bash
   ./scripts/test_dbconnect.sh add 4
   ```

3. Inspect detailed results:
   ```bash
   cat tmp/dbconnect-test-uv-add-*/SUMMARY.txt
   ls tmp/dbconnect-test-uv-add-*/*.txt
   ```

## What Gets Tested

For each environment in `dbr/` and `serverless/`:

1. **Manual Addition Test** (`add` mode):
   - Runs `uv sync` to install base dependencies
   - Runs `uv add databricks-connect` to add as a regular dependency
   - Verifies databricks-connect was installed successfully
   - Checks the installed version

2. **Dev Dependencies Test** (`sync-dev` mode):
   - Runs `uv sync --extra dev` to install with dev dependencies
   - Verifies databricks-connect was installed as a dev dependency
   - Checks the installed version

Both tests verify that:
- The constraint files properly mask incompatible packages (py4j, pyspark, etc.)
- The appropriate version of databricks-connect is installed for each environment
- No dependency conflicts occur
