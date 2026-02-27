#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: ./scripts/init.sh <project_path>"
    exit 1
fi

TARGET_DIR="$1"
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR" || exit
ABS_PATH=$(pwd)

PROJ_NAME=$(basename "$ABS_PATH")
# Ensure the package name uses underscores
PKG_NAME=$(echo "$PROJ_NAME" | tr '-' '_')

echo "🛠️  Scaffolding: $PROJ_NAME (Package: $PKG_NAME)"

# 1. Nuclear Clean
rm -rf .venv uv.lock pyproject.toml src tests .vscode .gitignore LICENSE .python-version CHANGELOG.md
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

# Run tests
make test
\`\`\`

## Project Structure

\`\`\`
$PROJ_NAME/
├── src/
│   └── $PKG_NAME/       # Main package
├── tests/                # Test files
├── pyproject.toml        # Project configuration
└── Makefile             # Development commands
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
    "pytest>=9.0.0",
    "pytest-cov>=6.0.0",
    "ruff>=0.3.0",
    "mypy>=1.8.0",
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
select = ["E", "F", "I", "N", "UP", "B", "C4", "SIM"]
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
addopts = "--cov=src --cov-report=term-missing --cov-report=html"

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
cat <<EOF > .gitignore
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
EOF

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
# 11. Support Artifacts
cat <<EOF > AGENTS.md
# Agent Instructions

- **Manager**: \`uv\` 
- **Layout**: \`src/\` layout.
- **Package**: \`$PKG_NAME\`
- **Run**: \`uv run start\`

## Project Structure

- Source code: \`src/$PKG_NAME/\`
- Tests: \`tests/\`
- Configuration: \`pyproject.toml\`
- Build backend: hatchling
- Linter/Formatter: ruff
- Type checker: mypy
- Test framework: pytest with coverage

## Development Commands

- \`make init\` - Initialize project
- \`make sync\` - Sync dependencies
- \`make check\` - Run all checks
- \`make fix\` - Auto-fix issues
- \`make test\` - Run tests with coverage
- \`make run\` - Run the application
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
echo "   - .python-version"
echo "   - CHANGELOG.md"
echo "   - AGENTS.md"
echo "   - .vscode/settings.json"

