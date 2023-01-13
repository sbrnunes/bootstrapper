#!/usr/bin/env bash

scriptName="$(basename "$0")";
bootstrapper="$(basename "$(dirname "$0")")"
group="$1"

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
  info "This bootstrapper is going to install a python ecosystem";
  info "Would you like to continue?"
  while true; do
    read -p "$prefix Enter [y|n]:" answer
    case $answer in
      [Yy])
        if [[ $(type -t brew) = "" ]] && [ ! -f /opt/homebrew/bin/brew ]
        then
            info "Cannot run this bootstrapper. Install required dependency first: Homebrew."
        else
          eval "$(/opt/homebrew/bin/brew shellenv)"

          info "Installing python..."
          brew install python

          info "Installing virtualenverapper..."
          pip3 install virtualenvwrapper

          info "Setting up virtualenvwrapper..."
          echo "# Python virtualenvwrapper" >> $HOME/env.sh
          echo 'export WORKON_HOME=~/.virtualenvs' >> $HOME/env.sh
          echo 'export VIRTUALENVWRAPPER_PYTHON=$(which python3)' >> $HOME/env.sh
          echo 'source /opt/homebrew/bin/virtualenvwrapper.sh' >> $HOME/env.sh

          grep -q "Python virtualenvwrapper" "$HOME/env.sh"
          if [ $? != 0 ]
          then
            grep -q "WORKON_HOME" "$HOME/env.sh"
            if [ $? != 0 ]
            then
              echo 'export WORKON_HOME=~/.virtualenvs' >> $HOME/env.sh
            else
              sed -i '' -e "s/export.*WORKON_HOME.*/export WORKON_HOME=~\/.virtualenvs/g" $HOME/env.sh
            fi

            grep -q "VIRTUALENVWRAPPER_PYTHON" "$HOME/env.sh"
            if [ $? != 0 ]
            then
              echo 'export VIRTUALENVWRAPPER_PYTHON=$(which python3)' >> $HOME/env.sh
            else
              sed -i '' -e "s/export.*VIRTUALENVWRAPPER_PYTHON.*/export VIRTUALENVWRAPPER_PYTHON=$(which python3)/g" $HOME/env.sh
            fi

            grep -q "source /opt/homebrew/bin/virtualenvwrapper.sh" "$HOME/env.sh"
            if [ $? != 0 ]
            then
              echo 'source /opt/homebrew/bin/virtualenvwrapper.sh' >> $HOME/env.sh
            fi
          fi

          info "Sourcing ~/env.sh..."
          source $HOME/env.sh
        fi
        break;
      ;;
      [Nn]) 
        info "Skipping...";
        break;
      ;;
    esac
  done
}

main "$@";