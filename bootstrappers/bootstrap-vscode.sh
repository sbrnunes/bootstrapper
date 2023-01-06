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
  if ! type -t brew; then
    info "Install Homebrew first!"
    exit 1
  fi;

  info "Downloading and updating brew"; # -------------------------------------------------------------
  brew install --cask visual-studio-code
}

main "$@";