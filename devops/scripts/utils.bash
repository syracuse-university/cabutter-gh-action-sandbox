#!/usr/bin/env bash

# Color codes (only define if not already set)
if [[ -z "${COLOR_RED:-}" ]]; then
  readonly COLOR_RED='\033[0;31m'
  readonly COLOR_GREEN='\033[0;32m'
  readonly COLOR_YELLOW='\033[1;33m'
  readonly COLOR_BLUE='\033[0;34m'
  readonly COLOR_GRAY='\033[0;90m'
  readonly COLOR_RESET='\033[0m'
fi

# Logging functions
function log_info {
  echo -e "${COLOR_BLUE}ℹ${COLOR_RESET} $*"
}

function log_success {
  echo -e "${COLOR_GREEN}✓${COLOR_RESET} $*"
}

function log_error {
  echo -e "${COLOR_RED}✗${COLOR_RESET} $*" >&2
}

function log_warn {
  echo -e "${COLOR_YELLOW}⚠${COLOR_RESET} $*"
}

function log_debug {
  echo -e "${COLOR_GRAY}◆${COLOR_RESET} $*"
}

# Source - https://stackoverflow.com/a/29436423
# Posted by Tiago Lopo, modified by community. See post 'Timeline' for change history
# Retrieved 2026-02-06, License - CC BY-SA 3.0
# Usage:
# to exit completely
# yes_or_no "$message" || exit 1
# to only execute this command if yes
# yes_or_no "$message" && echo "do this!"
function yes_or_no {
  while true; do
    local yn
    read -rp "$* [y/n]: " yn
    case $yn in
    [Yy]*) return 0 ;;
    [Nn]*)
      echo -e "${COLOR_RED}Aborted${COLOR_RESET}"
      return 1
      ;;
    esac
  done
}
