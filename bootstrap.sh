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
  shopt -u nullglob

  init_logger
  info "Bootstrapping this machine";
  info "Would you like to continue?"
  while true; do
    read -p "$prefix Enter [y|n]: " answer
    case $answer in
      [Yy])
        bootstrappers=$(cat config)
        for bootstrapper in $bootstrappers
        do
           /bin/bash -c ./bootstrappers/bootstrap-$bootstrapper.sh;
        done
        break;
      ;;
      [Nn])
        info "Skipping...";
        break;
      ;;
      *)
        info "Would you like to continue?";
      ;;
    esac
  done

  shopt -u nullglob
}

main "$@";