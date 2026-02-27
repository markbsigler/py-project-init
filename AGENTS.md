# Agent Instructions

- **Manager**: `uv` 
- **Layout**: `src/` layout.
- **Package**: `py_project_init`
- **Run**: `uv run start`

## Project Structure

- Source code: `src/py_project_init/`
- Tests: `tests/`
- Configuration: `pyproject.toml`
- Build backend: hatchling
- Linter/Formatter: ruff
- Type checker: mypy
- Test framework: pytest with coverage

## Development Commands

- `make init` - Initialize project
- `make sync` - Sync dependencies
- `make check` - Run all checks
- `make fix` - Auto-fix issues
- `make test` - Run tests with coverage
- `make run` - Run the application
