# Python constraints for 16.4 LTS CPU ML

Constraint files to match your local Python environment to 16.4 LTS ML (includes Apache Spark 3.5.2, Scala 2.12).

## Files included

- **`pyproject.toml`** - A complete pyproject.toml file with constraints, databricks-connect dev dependency, and project metadata
- **`constraints.txt`** - A standard constraints file compatible with pip and other tools

## Quick start

### Using pyproject.toml

1. Copy the `pyproject.toml` file to your project directory
2. Modify the `name` field in the `[project]` section to match your project name
3. Start using it with `uv`:

```bash
uv sync --extra dev
```

`uv` will automatically use the constraints defined in `pyproject.toml` to ensure all dependencies match the Databricks runtime versions. Installing with `--extra dev` will also install databricks-connect for local development.

### Using pyproject.toml with uv

Add a package to your project (constraints are automatically applied):

```bash
uv add requests
```

### Using constraints.txt with pip

```bash
pip install --constraint constraints.txt requests
```

## Recommended: Using `uv`

We **strongly recommend using [`uv`](https://docs.astral.sh/uv/)** for managing your Python environment with these constraints. `uv` works out of the box with the provided `pyproject.toml` file, automatically respecting all constraints and PyTorch index configurations.

### Why `uv`?

- **Out-of-the-box support**: The `pyproject.toml` file is configured specifically for `uv`
- **Fast dependency resolution**: `uv`'s resolver is significantly faster than pip
- **Automatic constraint handling**: `uv` automatically applies constraints when resolving dependencies
- **PyTorch support**: If this environment includes PyTorch packages, the PyTorch index configuration is already set up in `pyproject.toml`

### Basic `uv` usage

```bash
# Sync your environment with the constraints
uv sync

# Add a new dependency (`uv` will respect constraints automatically)
uv add <package-name>

# Run a command in the constrained environment
uv run python your_script.py
```

## Using with your existing project

If you already have a `pyproject.toml` file in your project, you can copy the `constraint-dependencies` section from this file's `[tool.uv]` section into your own `pyproject.toml`. You must also set the Python version to match the Databricks environment:

```toml
[project]
requires-python = "==3.12.*"

[tool.uv]
constraint-dependencies = [
    # Copy the constraint-dependencies array from this file
]
```

## Environment details

- **Python Version**: 3.12
- **Total Constraints**: 403 packages
- **Databricks Connect**: 16.4 (available as dev dependency)
- **Incompatible Packages**: 1 packages (databricks-sdk) - these packages conflict with databricks-connect and have been masked to allow local development
- **PyTorch Index**: Configured for cpu builds

## Notes

- The constraints in these files represent the exact package versions available in 16.4 LTS ML (includes Apache Spark 3.5.2, Scala 2.12)
- When installing new packages, always use the constraints to ensure compatibility
- To use databricks-connect for local development, install with: `uv sync --extra dev`
- Incompatible packages (databricks-sdk) have been masked because they conflict with databricks-connect. These are pre-installed in the Databricks runtime
