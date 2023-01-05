#!/usr/bin/env bash

scriptName="$(basename "$0")";

info() {
  local cols=$(tput cols);
  local len=${#1};
  local prefix="[${scriptName}]";
  local prefixLen=${#prefix};
  local rem=$((${cols:-79}-len-prefixLen-2)); # 2 => spaces.
  local rhs="$(printf "%${rem}s" '' | tr ' ' '=')";
  # 13 is bright yellow green.
  echo "$(tput setaf 13)${prefix}$(tput sgr0) $1 $(tput setaf 13)${rhs}$(tput sgr0)";
}


main() {
  info "Installing Ruby"; # --------------------------------------------------------------------------
  brew install rbenv ruby-build rbenv-default-gems rbenv-gemset
  echo 'eval "$(rbenv init -)"' >> ~/.env.sh
  source ~/.zshrc # Apply changes
}

main "$@";