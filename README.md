# py-project-init

A modern Python project template for bootstrapping new projects with best practices, using `uv` for dependency management and `src/` layout for package structure.

## Features

- ⚡️ **Fast dependency management** with `uv`
- 📦 **src/ layout** for proper package structure
- 🔍 **Linting & formatting** with `ruff`
- 🧪 **Testing** with `pytest` and coverage reporting
- 🔒 **Type checking** with `mypy` (strict mode)
- 📝 **Pre-configured** with .gitignore, LICENSE, CHANGELOG, and more

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

# Run tests
make test
```

## Project Structure

```text
py-project-init/
├── src/
│   └── py_project_init/       # Main package
├── tests/                # Test files
├── pyproject.toml        # Project configuration
└── Makefile             # Development commands
```

## What Gets Generated

When you run `make init`, the template creates:

- **Source Package**: `src/your_project_name/` with `__init__.py`, `main.py`, and `py.typed`
- **Tests**: `tests/test_main.py` with basic test and 100% coverage
- **Configuration Files**:
  - `pyproject.toml` with all dependencies and tool configurations
  - `.gitignore` for Python projects
  - `.python-version` set to Python 3.12
  - `.vscode/settings.json` for VS Code integration
- **Documentation**:
  - `README.md` with project-specific content
  - `LICENSE` (MIT)
  - `CHANGELOG.md` following Keep a Changelog format
  - `AGENTS.md` with AI agent instructions
- **Virtual Environment**: `.venv/` with all dependencies installed

## License

MIT License - see LICENSE file for details.
