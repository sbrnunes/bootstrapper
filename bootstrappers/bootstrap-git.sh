#!/usr/bin/env bash

scriptName="$(basename "$0")";

init_logger() {
  local cols=$(tput cols);
  local len=${#1};
  local prefixLen=${#prefix};
  prefix="$(tput setaf 13)[${scriptName}]$(tput sgr0)"
}

info() {
  echo "$prefix $1";
}

main() {
  init_logger
  info "Installing Git"; # -------------------------------------------------------------------------

  brew install git

  git config --global user.name "Sergio Nunes"
  git config --global user.email "sergio.nunes@talkdesk.com"

}

main "$@";