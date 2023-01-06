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
  info "Downloading and updating brew"; # -------------------------------------------------------------

  if ! type -t brew; then
    >&2 echo "Downloading and installing Homebrew";
    chsh -s "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi;

  echo 'PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile

  brew update;

  brew install --cask visual-studio-code
}

main "$@";