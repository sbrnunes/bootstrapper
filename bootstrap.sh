#!/usr/bin/env bash

scriptName="$(basename "$0")";

info() {
  >&2 echo "$(tput setaf 190)[${scriptName}]$(tput op) $*";
}

main() {
  info "Bootstrapping this machine";

  while read -r bootstrapper; do
    /bin/bash -c ./bootstrappers/bootstrap-$bootstrapper.sh;
  done < config
}

main "$@";