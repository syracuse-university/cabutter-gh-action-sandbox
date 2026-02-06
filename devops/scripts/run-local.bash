#!/bin/bash
set -e

REPO_PATH="${1:-.}"

if [ ! -d "$REPO_PATH/.git" ]; then
  echo "Error: $REPO_PATH is not a git repository"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEVOPS_DIR="$(dirname "$SCRIPT_DIR")"

echo "Building Docker image..."
docker build -t gh-actions-tag-tool "$DEVOPS_DIR"

echo "Running release tag creation..."
# Configure ssh keys
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
docker run \
  --rm \
  -v "$REPO_PATH:/repo" \
  -v ~/.ssh:/root/.ssh:ro \
  -v ~/.gitconfig:/root/.gitconfig:ro \
  gh-actions-tag-tool

echo "Release tag creation completed!"
