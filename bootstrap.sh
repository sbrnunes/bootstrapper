#!/usr/bin/env bash

scriptName="$(basename "$0")";

info() {
  >&2 echo "$(tput setaf 190)[${scriptName}]$(tput op) $*";
}

main() {
  info "Bootstrapping this machine";
  /bin/bash -c ./boostrappers/bootstrap-xcode.sh;
  /bin/bash -c ./boostrappers/bootstrap-iterm.sh;
  /bin/bash -c ./boostrappers/bootstrap-homebrew.sh;
  /bin/bash -c ./boostrappers/bootstrap-zsh.sh;
}

main "$@";