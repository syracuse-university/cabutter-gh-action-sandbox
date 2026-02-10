#!/usr/bin/env bash

# add functions
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${SCRIPT_DIR}/utils.bash"

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
  local release_version=get_release_version
  log_info "Next release version is: $release_version"

  log_info "Configuring git..."
  git config user.name "github-actions[bot]"
  git config user.email "github-actions[bot]@users.noreply.github.com"

  log_info "Creating and pushing tag: $release_version"
  git tag -a "${release_version}" -m "Release version ${release_version}"
  git push origin "${release_version}"

  log_success "Tag created and pushed successfully!"
}

function get_changelog_text {
  git-cliff --bump --unreleased
}

function append_changelog_text {
  local changelog_text=get_changelog_text
  {
    head -n 2 CHANGELOG.md
    echo "$changelog_text"
    echo
    tail -n +3 CHANGELOG.md
  } >CHANGELOG.tmp && mv CHANGELOG.tmp CHANGELOG.md
}

function stage_and_commit_release_files {
  local release_version=set_release_version 
  git add CHANGELOG.md
  git commit -m "ci: Update changelog"
  git push https://${{ secrets.GITHUB_TOKEN }}@github.com/${GITHUB_REPOSITORY}.git ${{ env.BRANCH_NAME }}

}

# Only run when executed directly, not when sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  time "${@}"
fi
