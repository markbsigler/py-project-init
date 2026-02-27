# py-project-init

Modern Python project using `uv` and `src/` layout.

## Installation

```bash
# Clone the repository
git clone <repository-url>
cd py-project-init

# Initialize the project
make init
```

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

```
py-project-init/
├── src/
│   └── py_project_init/       # Main package
├── tests/                # Test files
├── pyproject.toml        # Project configuration
└── Makefile             # Development commands
```

## License

MIT License - see LICENSE file for details.
