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
  info "Installing Ruby"; # --------------------------------------------------------------------------
  brew install rbenv ruby-build rbenv-default-gems rbenv-gemset
  echo 'eval "$(rbenv init -)"' >> ~/.env.sh
  source ~/.zshrc # Apply changes
}

main "$@";