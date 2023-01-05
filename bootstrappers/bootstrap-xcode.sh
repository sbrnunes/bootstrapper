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
  info "Checking Command Line Tools for Xcode"

  # Only run if the tools are not installed yet
  # To check that try to print the SDK path
  xcode-select -p &> /dev/null
  if [ $? -ne 0 ]; then
    info "Command Line Tools for Xcode not found."
    xcode-select --install
  else
    info "Command Line Tools for Xcode have been installed."
  fi
}

main "$@";