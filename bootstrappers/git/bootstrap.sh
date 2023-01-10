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
  info "Running '$bootstrapper' for group '$group'"
  info "This bootstrapper is going to install Git and setup the authentication.";
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

          info "Installing Git...";
          brew install git

          info "Setting global configuration...";
          read -p "$prefix Enter your name (to be displayed in commits): " name
          read -p "$prefix Enter your email (to be used with your commits): " email

          git config --global user.name $name
          git config --global user.email $email

          info "Create a personal access token in https://github.com/settings/tokens with the following scopes and paste it below:"
          echo "$(cat <<- EOM
  - repo
    - repo:status
    - repo_deployment
    - public_repo
    - repo:invite
    - security_events
  - admin:org
    - read:org
  - admin:repo_hook
    - write:repo_hook
    - read:repo_hook
  - admin:org_hook
  - user
    - user:email
EOM
          )"

          read -s -p "$prefix Token: " token

          grep -q "GITHUB_TOKEN" "$HOME/env.sh"
          if [ $? != 0 ]
          then
            echo "### GitHub Token for GitHub API" >> $HOME/env.sh
            echo "export GITHUB_TOKEN=$token" >> $HOME/env.sh
          else
            sed -i "s/export.*GITHUB_TOKEN.*/export GITHUB_TOKEN=$token/" $HOME/env.sh
          fi

          grep -q "HOMEBREW_GITHUB_API_TOKEN" "$HOME/env.sh"
          if [ $? != 0 ]
          then
            echo "### GitHub Token for Homebrew" >> $HOME/env.sh
            echo "export HOMEBREW_GITHUB_API_TOKEN=$token" >> $HOME/env.sh
          else
            sed -i "s/export.*HOMEBREW_GITHUB_API_TOKEN.*/export HOMEBREW_GITHUB_API_TOKEN=$token/" $HOME/env.sh
          fi

          grep -q "BUNDLE_GITHUB__COM" "$HOME/env.sh"
          if [ $? != 0 ]
          then
            echo "### GitHub Token for bundler / asdf" >> $HOME/env.sh
            echo "export BUNDLE_GITHUB__COM=$token" >> $HOME/env.sh
          else
            sed -i "s/export.*BUNDLE_GITHUB__COM.*/export BUNDLE_GITHUB__COM=$token/" $HOME/env.sh
          fi
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