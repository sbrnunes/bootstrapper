#!/usr/bin/env bash

scriptName="$(basename "$0")";
bootstrapper="$(basename "$(dirname "$0")")"

init_logger() {
  local cols=$(tput cols);
  local len=${#1};
  local prefixLen=${#prefix};
  prefix="$(tput setaf 13)[./bootstrappers/${bootstrapper}/${scriptName}]$(tput sgr0)"
}

info() {
  echo "$prefix $1";
}

main() {
  init_logger
  info "This bootstrapper is going to download and install Command Line Tools for Xcode.";

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