#!/usr/bin/env bash
set -euo pipefail

FORCE=false
if [ "${1:-}" = "--force" ]; then
    FORCE=true
    shift
fi

if [ -z "${1:-}" ]; then
    echo "Usage: ./scripts/init.sh [--force] <project_path>"
    exit 1
fi

TARGET_DIR="$1"
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR" || exit
ABS_PATH=$(pwd)

PROJ_NAME=$(basename "$ABS_PATH")
# Ensure the package name uses underscores
PKG_NAME=$(echo "$PROJ_NAME" | tr '-' '_')

# Safety check: warn if project already exists
if [ "$FORCE" = false ] && [ -f "pyproject.toml" ]; then
    echo ""
    echo "⚠️  WARNING: An existing project was detected in this directory."
    echo "   This will DELETE and recreate: src/, tests/, pyproject.toml,"
    echo "   .venv/, .gitignore, LICENSE, CHANGELOG.md, AGENTS.md, and more."
    echo ""
    read -rp "   Are you sure you want to re-initialize? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "❌ Aborted. No changes were made."
        exit 0
    fi
    echo ""
fi

echo "🛠️  Scaffolding: $PROJ_NAME (Package: $PKG_NAME)"

# 1. Nuclear Clean
rm -rf .venv uv.lock pyproject.toml src tests .vscode .gitignore LICENSE .python-version CHANGELOG.md .editorconfig
mkdir -p "src/$PKG_NAME" "tests" ".vscode"

# 2. Create Source Files
cat <<EOF > "src/$PKG_NAME/__init__.py"
"""$PROJ_NAME package."""

__version__ = "0.1.0"
EOF

# Create py.typed marker for PEP 561 compliance
touch "src/$PKG_NAME/py.typed"

cat <<EOF > "src/$PKG_NAME/main.py"
from loguru import logger


def main() -> None:
    """Main entry point for the application."""
    logger.success("✅ SUCCESS: The src-layout is correctly linked and running!")


if __name__ == "__main__":
    main()
EOF

# 3. Create Test Files
touch "tests/__init__.py"
cat <<EOF > "tests/test_main.py"
"""Tests for the main module."""

from $PKG_NAME.main import main


def test_main() -> None:
    """Test that main() runs without errors."""
    main()
EOF

# 4. Create Enhanced README
cat <<EOF > README.md
# $PROJ_NAME

Modern Python project using \`uv\` and \`src/\` layout.

## Installation

\`\`\`bash
# Clone the repository
git clone <repository-url>
cd $PROJ_NAME

# Initialize the project
make init
\`\`\`

## Usage

\`\`\`bash
# Run the application
make run
# or
uv run start
\`\`\`

## Development

\`\`\`bash
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
\`\`\`

## Project Structure

\`\`\`text
$PROJ_NAME/
├── src/
│   └── $PKG_NAME/        # Main package
├── tests/                 # Test files
├── .github/workflows/     # CI pipeline
├── pyproject.toml         # Project configuration
├── Makefile               # Development commands
└── AGENTS.md              # AI agent instructions
\`\`\`

## License

MIT License - see LICENSE file for details.
EOF

# 5. Explicit Hatchling + UV Source Mapping with Enhanced Configuration
cat <<EOF > pyproject.toml
[project]
name = "$PROJ_NAME"
version = "0.1.0"
description = "Modern Python Scaffolding"
readme = "README.md"
requires-python = ">=3.12"
license = { text = "MIT" }
dependencies = [
    "loguru>=0.7.2",
    "pydantic>=2.6.1",
]

[dependency-groups]
dev = [
    "pytest>=9.0.0,<10",
    "pytest-cov>=6.0.0,<7",
    "ruff>=0.3.0,<1",
    "mypy>=1.8.0,<2",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.hatch.build.targets.wheel]
packages = ["src/$PKG_NAME"]

[project.scripts]
start = "$PKG_NAME.main:main"

[tool.ruff]
line-length = 88
target-version = "py312"

[tool.ruff.lint]
select = ["E", "F", "I", "N", "UP", "B", "C4", "SIM", "RUF", "PT", "TCH", "ANN"]
ignore = []

[tool.ruff.lint.isort]
known-first-party = ["$PKG_NAME"]

[tool.mypy]
python_version = "3.12"
strict = true
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true

[tool.pytest.ini_options]
testpaths = ["tests"]
pythonpath = ["src"]
addopts = "-v --cov=src --cov-report=term-missing --cov-report=html"

[tool.coverage.run]
source = ["src"]
omit = ["tests/*"]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "if __name__ == .__main__.:",
    "raise NotImplementedError",
    "pass",
]
EOF

# 6. Clean sync
# We use --reinstall-package to force uv to fix the editable link to src/
uv sync --reinstall-package "$PROJ_NAME"

# 7. Create .gitignore
cat <<'GITIGNORE' > .gitignore
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# Virtual Environments
.venv/
venv/
ENV/
env/

# IDEs
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# Testing
.pytest_cache/
.coverage
htmlcov/
.tox/
.hypothesis/

# Type checking
.mypy_cache/
.dmypy.json
dmypy.json
.pyre/
.pytype/

# Ruff
.ruff_cache/

# UV
uv.lock

# Distribution
*.whl
*.tar.gz
GITIGNORE

# 8. Create MIT LICENSE
YEAR=$(date +%Y)
cat <<EOF > LICENSE
MIT License

Copyright (c) $YEAR

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

# 9. Create .python-version for pyenv
cat <<EOF > .python-version
3.12
EOF

# 10. Create CHANGELOG.md
cat <<EOF > CHANGELOG.md
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project setup
- Core package structure with src/ layout
- Basic test suite
- Development tooling (ruff, mypy, pytest)

## [0.1.0] - $YEAR-$(date +%m-%d)

### Added
- Initial release
EOF

# 11. Support Artifacts
cat <<EOF > AGENTS.md
# Agent Instructions

- **Manager**: \`uv\`
- **Layout**: \`src/\` layout
- **Package**: \`$PKG_NAME\`
- **Run**: \`uv run start\`

## Project Structure

- Source code: \`src/$PKG_NAME/\`
- Tests: \`tests/\`
- Configuration: \`pyproject.toml\`
- Build backend: hatchling
- Linter/Formatter: ruff
- Type checker: mypy (strict)
- Test framework: pytest with coverage
- CI: GitHub Actions (\`.github/workflows/ci.yml\`)

## Development Commands

- \`make init\` - Initialize project
- \`make sync\` - Sync dependencies
- \`make check\` - Run all checks (must pass before committing)
- \`make fix\` - Auto-fix issues
- \`make test\` - Run tests with coverage
- \`make run\` - Run the application
- \`make clean\` - Remove build artifacts and caches

## Coding Conventions

- **Type annotations**: Required on all functions (\`-> None\`, \`-> str\`, etc.). Strict mypy is enabled.
- **Docstrings**: Required on all public modules, classes, and functions.
- **Naming**: snake_case for functions/variables, PascalCase for classes, UPPER_CASE for constants.
- **Imports**: Sorted by ruff (isort rules). First-party package: \`$PKG_NAME\`.
- **Line length**: 88 characters max.
- **Formatting**: Handled by ruff. Run \`make fix\` before committing.

## Testing Guidelines

- Test files go in \`tests/\` with \`test_\` prefix (e.g., \`tests/test_feature.py\`).
- Test functions use \`test_\` prefix and must have \`-> None\` return type.
- Add docstrings to test functions describing what they verify.
- Minimum coverage target: maintain 100% on core modules.
- Run \`make test\` to execute tests with coverage report.

## Dependency Management

- Add runtime deps: \`uv add <package>\`
- Add dev deps: \`uv add --group dev <package>\`
- Pin upper bounds on dev tools (e.g., \`"ruff>=0.3.0,<1"\`).
- After adding deps, run \`make sync\` and verify with \`make check\`.

## Quality Gates

Before committing, ensure all gates pass:

1. \`make check\` — ruff lint, ruff format, mypy strict
2. \`make test\` — all tests pass with coverage

## File Creation Patterns

When adding new modules:

\`\`\`text
src/$PKG_NAME/
├── __init__.py          # Package init with __version__
├── py.typed             # PEP 561 marker
├── main.py              # Entry point
└── new_module.py        # New module here

tests/
├── __init__.py
├── test_main.py
└── test_new_module.py   # Corresponding test
\`\`\`

## Git Workflow

- **Commit messages**: Use imperative mood (e.g., "Add feature" not "Added feature").
- **Format**: Short summary line, blank line, bullet-point details.
- **Branch**: \`main\` is the default branch.
- **CI**: All pushes and PRs to \`main\` trigger GitHub Actions checks.
EOF

cat <<EOF > .vscode/settings.json
{
    "python.analysis.extraPaths": ["./src"],
    "python.testing.pytestEnabled": true,
    "python.testing.pytestArgs": ["-v", "--cov=src"],
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.fixAll.ruff": "always",
        "source.organizeImports.ruff": "always"
    },
    "[python]": {
        "editor.defaultFormatter": "charliermarsh.ruff",
        "editor.formatOnSave": true
    },
    "python.analysis.typeCheckingMode": "strict"
}
EOF

# 12. Create .editorconfig for cross-editor consistency
cat <<EOF > .editorconfig
root = true

[*]
indent_style = space
indent_size = 4
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.md]
trim_trailing_whitespace = false

[Makefile]
indent_style = tab
EOF

# 13. Create GitHub Actions CI workflow
mkdir -p .github/workflows
cat <<EOF > .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v4
        with:
          version: "latest"
      - run: uv python install 3.12
      - run: uv sync
      - run: make check
      - run: make test
EOF

echo "------------------------------------------------"
echo "✅ Scaffolding complete."
echo "🚀 Run: uv run start"
echo "📝 Files created:"
echo "   - src/$PKG_NAME/ (with __init__.py, main.py, py.typed)"
echo "   - tests/test_main.py"
echo "   - pyproject.toml (with enhanced config)"
echo "   - README.md"
echo "   - LICENSE (MIT)"
echo "   - .gitignore"
echo "   - .editorconfig"
echo "   - .python-version"
echo "   - CHANGELOG.md"
echo "   - AGENTS.md"
echo "   - .vscode/settings.json"
echo "   - .github/workflows/ci.yml"

