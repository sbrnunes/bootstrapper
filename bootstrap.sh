#!/usr/bin/env bash

scriptName="$(basename "$0")";

info() {
  >&2 echo "$(tput setaf 190)[${scriptName}]$(tput op) $*";
}

main() {
  info "Bootstrapping this machine";
  /bin/bash -c ./bootstrappers/bootstrap-xcode.sh;
  /bin/bash -c ./bootstrappers/bootstrap-iterm.sh;
  /bin/bash -c ./bootstrappers/bootstrap-homebrew.sh;
  /bin/bash -c ./bootstrappers/bootstrap-zsh.sh;
}

main "$@";