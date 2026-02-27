# py-project-init

A modern Python project template for bootstrapping new projects with best practices, using `uv` for dependency management and `src/` layout for package structure.

## Features

- **Fast dependency management** with `uv`
- **src/ layout** for proper package structure
- **Linting & formatting** with `ruff`
- **Testing** with `pytest` and coverage reporting
- **Type checking** with `mypy` (strict mode)
- **CI** with GitHub Actions
- **Pre-configured** with .gitignore, LICENSE, CHANGELOG, .editorconfig, and more

## Quick Start

To create a new project from this template:

```bash
# Clone this repository as your new project name
git clone git@github.com:markbsigler/py-project-init.git your-project-name
cd your-project-name

# Initialize the project (this will scaffold everything for your new project)
make init

# Remove the template's git history and start fresh
rm -rf .git
git init
git add .
git commit -m "Initial commit from py-project-init template"
```

The `make init` command will:

- Create the package structure based on your directory name
- Generate all configuration files
- Set up virtual environment with dependencies
- Create initial test files
- Configure development tools

## Usage

```bash
# Run the application
make run
# or
uv run start
```

## Development

```bash
# Install dependencies
make sync

# Run linting and type checking
make check

# Auto-fix linting issues
make fix

# Run tests with coverage
make test

# Remove build artifacts and caches
make clean
```

## Project Structure

```text
py-project-init/
├── scripts/
│   └── init.sh               # Template scaffolding script
├── src/
│   └── py_project_init/      # Main package
│       ├── __init__.py        # Package init with __version__
│       ├── py.typed           # PEP 561 marker
│       └── main.py            # Entry point
├── tests/                     # Test files
│   ├── __init__.py
│   └── test_main.py
├── .editorconfig              # Cross-editor consistency
├── .github/workflows/ci.yml   # GitHub Actions CI
├── .gitignore                 # Python gitignore
├── .python-version            # Python version for pyenv
├── AGENTS.md                  # AI agent instructions
├── CHANGELOG.md               # Keep a Changelog format
├── LICENSE                    # MIT License
├── Makefile                   # Development commands
├── pyproject.toml             # Project configuration
└── README.md                  # This file
```

## What Gets Generated

When you run `make init`, the template creates:

- **Source Package**: `src/your_project_name/` with `__init__.py`, `main.py`, and `py.typed`
- **Tests**: `tests/test_main.py` with basic test and 100% coverage
- **Configuration Files**:
  - `pyproject.toml` with all dependencies and tool configurations
  - `.gitignore` for Python projects
  - `.python-version` set to Python 3.12
  - `.editorconfig` for cross-editor consistency
  - `.vscode/settings.json` for VS Code integration
- **CI**: `.github/workflows/ci.yml` for GitHub Actions
- **Documentation**:
  - `README.md` with project-specific content
  - `LICENSE` (MIT)
  - `CHANGELOG.md` following Keep a Changelog format
  - `AGENTS.md` with AI agent instructions
- **Virtual Environment**: `.venv/` with all dependencies installed

## License

MIT License - see LICENSE file for details.
