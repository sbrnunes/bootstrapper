#!/usr/bin/env bash
#
# bootstrap.sh
#
# Public laptop bootstrap launcher.
#

scriptName="$(basename "$0")";

echo() {
  >&2 echo "$(tput setaf 190)[${scriptName}]$(tput op) $*";
}

main() {
  mkdir -p "${HOME}/bootstrap" && cd "${HOME}/bootstrap" && true;

  notify "Bootstrapping this machine";
  /bin/bash -c bootstrap-xcode.sh;
  /bin/bash -c bootstrap-iterm.sh;
  /bin/bash -c bootstrap-homebrew.sh;
  /bin/bash -c bootstrap-zsh.sh;


  # shellcheck disable=SC2034
  read -r -p "Login to Dropbox, press Enter/Return when synchronization is complete." response;

  # Exec the ~/Dropbox/bootstrap-private script (private work stuff).
  "${HOME}/Dropbox/bootstrap/bootstrap-private";
}

main "$@";