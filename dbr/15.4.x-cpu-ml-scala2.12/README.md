# Python constraints for 15.4 LTS ML (includes Apache Spark 3.5.0, Scala 2.12)

These are Python environment constraint files that you can use to mirror the set of Python packages and the Python version used in 15.4 LTS ML (includes Apache Spark 3.5.0, Scala 2.12).

## Overview

This directory contains constraint files that ensure your local Python environment matches the packages and versions available in the Databricks runtime or serverless environment. By using these constraints, you can develop and test locally with the exact same package versions that will be used in your Databricks environment.

## Files included

- **`pyproject.toml`** - A complete pyproject.toml file with constraints and project metadata
- **`uv.toml`** - `uv`-specific configuration file with constraints and PyTorch index settings (if applicable)
- **`constraints.txt`** - A standard constraints file compatible with pip and other tools

## Quick start

### Using pyproject.toml

1. Copy the `pyproject.toml` file to your project directory
2. Modify the `name` field in the `[project]` section to match your project name
3. Start using it with `uv`:

```bash
uv sync
```

`uv` will automatically use the constraints defined in `pyproject.toml` to ensure all dependencies match the Databricks runtime versions.

### Using constraints.txt with pip

If you prefer to use pip, you can use the `constraints.txt` file:

```bash
pip install --constraint constraints.txt <your-package>
```

For example, to install a new package while respecting the constraints:

```bash
pip install --constraint constraints.txt requests
```

This ensures that `requests` and all its dependencies will be installed at versions compatible with the Databricks runtime environment.

## Recommended: Using `uv`

We **strongly recommend using [`uv`](https://docs.astral.sh/uv/)** for managing your Python environment with these constraints. `uv` works out of the box with the provided `pyproject.toml` and `uv.toml` files, automatically respecting all constraints and PyTorch index configurations.

### Why `uv`?

- **Out-of-the-box support**: The `pyproject.toml` and `uv.toml` files are configured specifically for `uv`
- **Fast dependency resolution**: `uv`'s resolver is significantly faster than pip
- **Automatic constraint handling**: `uv` automatically applies constraints when resolving dependencies
- **PyTorch support**: If this environment includes PyTorch packages, the PyTorch index configuration is already set up in `uv.toml`

### Basic `uv` usage

```bash
# Sync your environment with the constraints
uv sync

# Add a new dependency (`uv` will respect constraints automatically)
uv add <package-name>

# Run a command in the constrained environment
uv run python your_script.py
```

## Using uv.toml with your existing pyproject.toml

If you already have a `pyproject.toml` file in your project, you can use the `uv.toml` file alongside it:

1. Copy the `uv.toml` file to your project root (same directory as your `pyproject.toml`)
2. `uv` will automatically merge the configuration from both files
3. The constraints from `uv.toml` will be applied to your project

The `uv.toml` file contains:
- Constraint dependencies (all package versions)
- PyTorch index configuration (if applicable)

**Important**: When using `uv.toml` with your existing `pyproject.toml`, you must manually set the Python version in your `pyproject.toml`:

```toml
[project]
requires-python = "==3.11.*"
```

You can keep your existing `pyproject.toml` for project metadata and dependencies, while using `uv.toml` to ensure compatibility with the Databricks runtime.

### Example: Using both files

```bash
# Your project structure:
# my-project/
#   ├── pyproject.toml  (your existing project file)
#   ├── uv.toml         (copied from this directory)
#   └── src/

# `uv` will use both files
uv sync  # Respects constraints from uv.toml and dependencies from pyproject.toml
```

## Environment details

- **Python Version**: 3.11
- **Total Constraints**: 356 packages
- **PyTorch Index**: Configured for cpu builds

## Notes

- The constraints in these files represent the exact package versions available in 15.4 LTS ML (includes Apache Spark 3.5.0, Scala 2.12)
- When installing new packages, always use the constraints to ensure compatibility
