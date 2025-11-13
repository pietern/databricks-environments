# Databricks Python Constraint Files

Python package constraint files for Databricks Runtime (DBR) and Databricks Serverless environments. These constraints ensure your local Python environment matches the exact package versions available in Databricks.

## What Are These Constraint Files?

Each Databricks environment comes with a specific set of pre-installed Python packages. These constraint files capture those exact versions, allowing you to:

- **Develop locally** with the same package versions used in production
- **Avoid surprises** when deploying code to Databricks
- **Reproduce issues** locally with matching dependencies
- **Test code** in an environment identical to your Databricks cluster or serverless compute

## Repository Structure

```
.
├── dbr/                         # Databricks Runtime environments
│   ├── 12.2.x-cpu-ml-scala2.12/ # Example: DBR 12.2 LTS ML
│   ├── 17.3.x-cpu-ml-scala2.13/ # Example: DBR 17.3 LTS ML
│   └── ...                       # 36 DBR versions total
└── serverless/                  # Databricks Serverless environments
    ├── serverless-v1/
    ├── serverless-v2/
    └── ...                       # 4 serverless versions total
```

Each environment directory contains:
- **README.md** - Detailed usage instructions
- **pyproject.toml** - Complete project template with constraints
- **uv.toml** - UV-specific configuration (works alongside existing pyproject.toml)
- **constraints.txt** - Standard pip constraints file

## Quick Start

### Option 1: Using UV (Recommended)

Copy the `uv.toml` file to your project directory:

```bash
# Copy uv.toml for your target DBR version
cp dbr/17.3.x-cpu-ml-scala2.13/uv.toml my-project/

# Sync your environment
cd my-project
uv sync
```

UV will automatically apply the constraints when installing dependencies.

### Option 2: Using pyproject.toml

Copy the entire `pyproject.toml` as a starting point:

```bash
# Copy pyproject.toml
cp dbr/17.3.x-cpu-ml-scala2.13/pyproject.toml my-project/

# Edit the project name
# Then sync with UV
cd my-project
uv sync
```

### Option 3: Using pip constraints

Use the constraints.txt file with pip:

```bash
# Install packages with constraints
pip install --constraint dbr/17.3.x-cpu-ml-scala2.13/constraints.txt your-package

# Or add to requirements
pip install -r requirements.txt --constraint dbr/17.3.x-cpu-ml-scala2.13/constraints.txt
```

## Choosing the Right Environment

### DBR (Databricks Runtime)

Match your cluster's Databricks Runtime version:

- **Standard DBR**: `12.2.x-scala2.12`, `17.3.x-scala2.13`, etc.
- **ML Runtime (CPU)**: `17.3.x-cpu-ml-scala2.13`, etc.
- **ML Runtime (GPU)**: `17.3.x-gpu-ml-scala2.13`, etc.

Find your cluster's DBR version in the Databricks UI under **Compute** → **Configuration** → **Databricks Runtime Version**.

### Serverless

For Databricks Serverless compute, use the corresponding serverless version:

- `serverless-v1`, `serverless-v2`, `serverless-v3`, `serverless-v4`

Check your workspace's serverless version in the Databricks documentation or workspace settings.

## Coverage

**DBR Versions**: 36 environments
- Versions 12.2.x through 17.3.x
- Standard, CPU-ML, and GPU-ML variants
- Scala 2.12 and 2.13 versions

**Serverless Versions**: 4 environments
- serverless-v1 through serverless-v4

## Notes

### Omitted Packages

Some environments may have a few packages omitted from constraints due to version conflicts with the local environment. These packages are pre-installed in Databricks and work correctly there. See the README in each environment directory for specifics.

### PyTorch Packages

ML environments include PyTorch-specific index configurations in `uv.toml` and `pyproject.toml` to ensure correct PyTorch variants (CPU vs CUDA) are installed.

### Updates

These constraint files are generated from actual Databricks environments and updated periodically. Check individual environment READMEs for Python version and package count details.

## Support

For issues or questions about using these constraint files, please refer to the individual environment READMEs which contain detailed usage examples and troubleshooting guidance.

## License

These constraint files represent the package versions available in Databricks environments and are provided as-is for development convenience.
