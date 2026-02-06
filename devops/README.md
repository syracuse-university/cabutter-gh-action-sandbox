# Release Tag Tool

Docker-based tool to create release tags locally, extracted from `.github/workflows/git-tag.yml`.

## Files

- `Dockerfile` - Container image with git-cliff and dependencies
- `scripts/create-tag.sh` - Main script that runs inside the container
- `scripts/run-local.sh` - Wrapper script to build and run the Docker container

## Usage

Run from the repository root:

```bash
./devops/scripts/run-local.sh /path/to/repo
```

Or from the devops directory:

```bash
./scripts/run-local.sh ..
```

The script will:
1. Checkout the production branch
2. Pull latest changes
3. Determine the next release version using `git-cliff`
4. Create an annotated git tag
5. Push the tag to origin

## Requirements

- Docker installed and running
- Git credentials configured (or GITHUB_TOKEN environment variable set)
- Permission to push tags to the repository

## Environment Variables

- `GITHUB_TOKEN` - (Optional) GitHub token for authentication
