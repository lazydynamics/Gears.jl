# PkgName

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://username.github.io/PkgName.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://username.github.io/PkgName.jl/dev/)
[![Build Status](https://github.com/username/PkgName.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/username/PkgName.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/username/PkgName.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/username/PkgName.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

## About

This is a template for creating new Julia packages. When you create a repository from this template, a GitHub action will automatically:

1. Update the package name to match your repository name
2. Generate a new UUID for your package
3. Replace placeholder values with appropriate defaults
4. Rename source files to match your package name

## Features

- Comprehensive CI setup with GitHub Actions
- Documentation generation with Documenter.jl
- Test suite with TestItemRunner.jl and Aqua.jl
- Code quality checks with JET.jl
- Benchmarking setup
- Standardized project structure

## How to Use

1. Click "Use this template" to create a new repository
2. Create a Personal Access Token (PAT) and add it to your repository (see section below)
3. Wait for the initialization workflow to complete
4. Clone your new repository
5. Start developing your package!

## Required: Personal Access Token Setup

For the initialization workflow to work properly, you need to set up a Personal Access Token (PAT):

1. Create a Personal Access Token:
   - Go to your GitHub account → Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Click "Generate new token" (classic)
   - Give it a descriptive name (e.g., "Package Template Initialize")
   - Set an appropriate expiration
   - Select the `repo` and `workflow` scopes (full control of repositories and workflows)
   - Click "Generate token"
   - Copy the generated token (you won't see it again!)

2. Add the token to your repository:
   - Go to your newly created repository
   - Go to Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `PAT_TOKEN`
   - Value: paste your copied token
   - Click "Add secret"

This token allows the initialization workflow to commit changes to workflow files in your repository.

## Custom Configuration

After creating your repository, you may want to:

- Update author information in `Project.toml`
- Modify documentation settings in `docs/make.jl`
- Adjust CI settings in `.github/workflows/`
- Edit or extend the test suite in `test/`

## License

This template is licensed under MIT (see the LICENSE file). You are free to choose a different license for your own package.
