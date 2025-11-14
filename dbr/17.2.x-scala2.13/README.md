# Python constraints for 17.2

Constraint files to match your local Python environment to 17.2 (includes Apache Spark 4.0.0, Scala 2.13).

## Files included

- **`pyproject.toml`** - A complete pyproject.toml file with constraints and project metadata
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

We **strongly recommend using [`uv`](https://docs.astral.sh/uv/)** for managing your Python environment with these constraints. `uv` works out of the box with the provided `pyproject.toml` file, automatically respecting all constraints.

### Why `uv`?

- **Out-of-the-box support**: The `pyproject.toml` file is configured specifically for `uv`
- **Fast dependency resolution**: `uv`'s resolver is significantly faster than pip
- **Automatic constraint handling**: `uv` automatically applies constraints when resolving dependencies

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
- **Total Constraints**: 217 packages

## Notes

- The constraints in these files represent the exact package versions available in 17.2 (includes Apache Spark 4.0.0, Scala 2.13)
- When installing new packages, always use the constraints to ensure compatibility
