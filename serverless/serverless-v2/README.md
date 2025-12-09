# Python constraints for Databricks Serverless environment version 2

Constraint files to match your local Python environment to Databricks Serverless environment version 2.

## Files included

- **`pyproject.toml`** - A complete pyproject.toml file with constraints, databricks-connect dev dependency, and project metadata
- **`constraints.txt`** - A standard constraints file compatible with pip and other tools

## Quick start

### Using pyproject.toml

1. Copy the `pyproject.toml` file to your project directory
2. Modify the `name` field in the `[project]` section to match your project name
3. Start using it with `uv`:

```bash
uv sync
```

`uv` will automatically use the constraints defined in `pyproject.toml` to ensure all dependencies match the Databricks runtime versions, and will install databricks-connect for local development.

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
requires-python = "==3.11.*"

[tool.uv]
constraint-dependencies = [
    # Copy the constraint-dependencies array from this file
]
```

## Environment details

- **Python Version**: 3.11
- **Total Constraints**: 186 packages
- **Databricks Connect**: 15.4 (available as dev dependency)
- **Omitted Packages**: 2 packages (google-api-core, mlflow-skinny) - these packages are pre-installed in the Databricks environment but cannot be compiled locally due to build dependencies or version conflicts

## Notes

- The constraints in these files represent the exact package versions available in Databricks Serverless environment version 2
- When installing new packages, always use the constraints to ensure compatibility
- databricks-connect is included as a dev dependency and installed automatically with `uv sync`
- Omitted packages are pre-installed in the Databricks environment. If you need them locally, install them separately without constraints: `uv add <package> --no-sync` or `pip install <package> --no-deps`
