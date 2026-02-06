#!/usr/bin/env bash

# add functions
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${SCRIPT_DIR}/utils.bash"
source "${SCRIPT_DIR}/release_utils.bash"

append_changelog_text

log_info "The changelog has been updated. Please look it over..."
yes_or_no "Do you want to commit it?"
result=$?

if [[ $result -gt 0 ]]; then
  exit 1
fi

create_tag
