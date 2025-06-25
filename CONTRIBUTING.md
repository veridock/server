# Contributing to Veridock Server

Thank you for your interest in contributing to Veridock Server! We welcome contributions from the community to help improve this project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Style](#code-style)
- [Testing](#testing)
- [Documentation](#documentation)
- [Pull Request Process](#pull-request-process)
- [Reporting Issues](#reporting-issues)
- [Feature Requests](#feature-requests)

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/your-username/server.git
   cd server
   ```
3. **Set up the development environment**:
   ```bash
   make dev
   ```
4. **Create a branch** for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Workflow

1. **Make your changes** following the code style guidelines
2. **Run tests** to ensure nothing is broken:
   ```bash
   make test
   ```
3. **Format and lint** your code:
   ```bash
   make format
   make lint
   ```
4. **Commit your changes** with a descriptive message:
   ```bash
   git commit -m "Add feature: brief description of changes"
   ```
5. **Push to your fork** and create a pull request

## Code Style

- Follow [PEP 8](https://www.python.org/dev/peps/pep-0008/) for Python code
- Use [Google-style docstrings](https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings)
- Keep lines under 88 characters (Black's default)
- Use type hints for all function parameters and return values

### Python

We use [Black](https://github.com/psf/black) for code formatting and [isort](https://pycqa.github.io/isort/) for import sorting. These will be run automatically when you commit.

### JavaScript/TypeScript

- Follow [StandardJS](https://standardjs.com/) style
- Use ES6+ features where appropriate
- Include JSDoc comments for all functions

## Testing

- Write tests for all new features and bug fixes
- Ensure all tests pass before submitting a PR
- Run tests with:
  ```bash
  make test
  ```

### Test Coverage

We aim to maintain high test coverage. You can check the coverage with:

```bash
make test-cov
```

## Documentation

- Update documentation for any new features or changes
- Follow the existing documentation style
- Ensure all new features are properly documented

Documentation is written in Markdown and built with [MkDocs](https://www.mkdocs.org/). To preview the documentation locally:

```bash
make docs-serve
```

## Pull Request Process

1. Ensure any install or build dependencies are removed before the end of the layer when doing a build
2. Update the README.md with details of changes to the interface, including new environment variables, exposed ports, useful file locations, and container parameters
3. Increase the version numbers in any examples and the README.md to the new version that this Pull Request would represent. The versioning scheme we use is [SemVer](http://semver.org/)
4. You may merge the Pull Request in once you have the sign-off of two other developers, or if you do not have permission to do that, you may request the second reviewer to merge it for you

## Reporting Issues

When [reporting issues](https://github.com/veridock/server/issues), please include:

- A clear, descriptive title
- Steps to reproduce the issue
- Expected behavior
- Actual behavior
- Environment details (OS, Python version, etc.)
- Any relevant error messages or logs

## Feature Requests

We welcome feature requests! Please open an issue and use the "Feature Request" template to describe:

1. The problem you're trying to solve
2. Your proposed solution
3. Any alternative solutions you've considered

## Code Review Process

1. A maintainer will review your PR and provide feedback
2. Once all feedback has been addressed, your PR will be merged
3. The maintainer will handle versioning and releasing

## Getting Help

If you have questions about contributing, please open an issue or join our community chat.

Thank you for contributing to Veridock Server!
