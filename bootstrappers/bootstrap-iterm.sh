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
  if ! type -t brew; then
    info "Install Homebrew first!"
    exit 1
  fi;

  info "Installing iterm2"; # -------------------------------------------------------------------------
  brew install --cask iterm2
  brew tap homebrew/cask-fonts
  brew install --cask font-source-code-pro
}

main "$@";