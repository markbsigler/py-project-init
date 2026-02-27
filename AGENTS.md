# Agent Instructions

> **This is a template repository.** Changes to `scripts/init.sh` affect all projects bootstrapped from this template. Be mindful of this when editing generated files vs. template logic.

- **Manager**: `uv`
- **Layout**: `src/` layout
- **Package**: `py_project_init`
- **Run**: `uv run start`

## Project Structure

- Source code: `src/py_project_init/`
- Tests: `tests/`
- Configuration: `pyproject.toml`
- Build backend: hatchling
- Linter/Formatter: ruff
- Type checker: mypy (strict)
- Test framework: pytest with coverage
- CI: GitHub Actions (`.github/workflows/ci.yml`)

## Development Commands

- `make init` - Initialize project (scaffolds everything via `scripts/init.sh`)
- `make sync` - Sync dependencies
- `make check` - Run all checks (must pass before committing)
- `make fix` - Auto-fix issues
- `make test` - Run tests with coverage
- `make run` - Run the application
- `make clean` - Remove build artifacts and caches

## Coding Conventions

- **Type annotations**: Required on all functions (`-> None`, `-> str`, etc.). Strict mypy is enabled.
- **Docstrings**: Required on all public modules, classes, and functions.
- **Naming**: snake_case for functions/variables, PascalCase for classes, UPPER_CASE for constants.
- **Imports**: Sorted by ruff (isort rules). First-party package: `py_project_init`.
- **Line length**: 88 characters max.
- **Formatting**: Handled by ruff. Run `make fix` before committing.

## Testing Guidelines

- Test files go in `tests/` with `test_` prefix (e.g., `tests/test_feature.py`).
- Test functions use `test_` prefix and must have `-> None` return type.
- Add docstrings to test functions describing what they verify.
- Minimum coverage target: maintain 100% on core modules.
- Run `make test` to execute tests with coverage report.

## Dependency Management

- Add runtime deps: `uv add <package>`
- Add dev deps: `uv add --group dev <package>`
- Pin upper bounds on dev tools (e.g., `"ruff>=0.3.0,<1"`).
- After adding deps, run `make sync` and verify with `make check`.

## Quality Gates

Before committing, ensure all gates pass:

1. `make check` — ruff lint, ruff format, mypy strict
2. `make test` — all tests pass with coverage

## File Creation Patterns

When adding new modules:

```text
src/py_project_init/
├── __init__.py          # Package init with __version__
├── py.typed             # PEP 561 marker
├── main.py              # Entry point
└── new_module.py        # New module here

tests/
├── __init__.py
├── test_main.py
└── test_new_module.py   # Corresponding test
```

## Git Workflow

- **Commit messages**: Use imperative mood (e.g., "Add feature" not "Added feature").
- **Format**: Short summary line, blank line, bullet-point details.
- **Branch**: `main` is the default branch.
- **CI**: All pushes and PRs to `main` trigger GitHub Actions checks.
