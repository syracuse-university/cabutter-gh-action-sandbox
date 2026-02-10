#!/usr/bin/env bash

set -euo pipefail

# add functions
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${SCRIPT_DIR}/utils.bash"

# Set git author for commits (supports local and CI environments)
export GIT_AUTHOR_NAME="${GIT_AUTHOR_NAME:-github-actions[bot]}"
export GIT_AUTHOR_EMAIL="${GIT_AUTHOR_EMAIL:-github-actions[bot]@users.noreply.github.com}"

function get_release_version {
  git-cliff --bumped-version
}

function create_tag {
  echo "Checking out production branch..."
  git checkout production

  git remote -v
  log_info "Pulling latest changes..."
  git pull

  log_info "Determining release version..."
  local release_version=$(get_release_version)
  log_info "Next release version is: $release_version"

  log_info "Configuring git..."
  git config user.name "${GIT_AUTHOR_NAME}"
  git config user.email "${GIT_AUTHOR_EMAIL}"

  log_info "Creating and pushing tag: $release_version"
  git tag -a "${release_version}" -m "Release version ${release_version}"
  git push origin "${release_version}"

  log_success "Tag created and pushed successfully!"
}

function get_changelog_text {
  git-cliff --bump --unreleased
}

function append_changelog_text {
  local changelog_text=$(get_changelog_text)
  {
    head -n 2 CHANGELOG.md
    echo "$changelog_text"
    echo
    tail -n +3 CHANGELOG.md
  } >CHANGELOG.tmp && mv CHANGELOG.tmp CHANGELOG.md
}

function stage_and_commit_release_files {
  git add CHANGELOG.md
  git commit -m "ci: Update changelog"
  git push origin HEAD:${BRANCH_NAME:-$(git rev-parse --abbrev-ref HEAD)}
}

# Only run when executed directly, not when sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  time "${@}"
fi
