#!/usr/bin/env bash

function set_release_version {
  RELEASE_VERSION=$(git-cliff --bumped-version)
}

function create_tag {
  echo "Checking out production branch..."
  git checkout production

  git remote -v
  echo "Pulling latest changes..."
  git pull

  echo "Determining release version..."
  set_release_version
  echo "Next release version is: $RELEASE_VERSION"

  echo "Configuring git..."
  git config user.name "github-actions[bot]"
  git config user.email "github-actions[bot]@users.noreply.github.com"

  echo "Creating and pushing tag: $RELEASE_VERSION"
  git tag -a "${RELEASE_VERSION}" -m "Release version ${RELEASE_VERSION}"
  git push origin "${RELEASE_VERSION}"

  echo "Tag created and pushed successfully!"
}

function set_change_log_text {
  CHANGELOG_TEXT=$(git-cliff --bump --unreleased)
}

function append_changelog_text {
  set_changelog_text
  {
    head -n 2 CHANGELOG.md
    echo "$CHANGELOG_TEXT"
    echo
    tail -n +3 CHANGELOG.md
  } >CHANGELOG.tmp && mv CHANGELOG.tmp CHANGELOG.md
}
