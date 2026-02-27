# Project Variables
PYTHON_VERSION := 3.12
SCRIPTS_DIR := scripts
# Get the current directory name as the project name
PROJ_NAME := $(notdir $(CURDIR))
# Derive the Python package name (replace hyphens with underscores)
# This ensures consistency with our init.sh logic
PKG_NAME := $(subst -,_,$(PROJ_NAME))

.PHONY: help init install sync check test fix clean run

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

init: ## Completely re-initialize the project structure and environment
	@echo "🚀 Initializing project..."
	@./$(SCRIPTS_DIR)/init.sh .
	@echo "✅ Bootstrap complete. You are ready to code."

install: ## Setup virtualenv and install dependencies
	uv venv --python $(PYTHON_VERSION)
	uv sync --group dev

sync: ## Sync dependencies with pyproject.toml
	uv sync

check: ## Run linting, type checking, and formatting checks
	uv run ruff check .
	uv run ruff format --check .
	uv run mypy src/

fix: ## Auto-fix linting issues and reformat code
	uv run ruff check --fix .
	uv run ruff format .

test: ## Run tests with coverage
	uv run pytest -v

run: ## Run the main entry point
	uv run start

clean: ## Remove build artifacts and caches
	rm -rf .venv/
	rm -rf .ruff_cache/
	rm -rf .pytest_cache/
	rm -rf .mypy_cache/
	rm -rf .coverage
	rm -rf htmlcov/
	rm -rf dist/
	find . -type d -name "__pycache__" -exec rm -rf {} +
