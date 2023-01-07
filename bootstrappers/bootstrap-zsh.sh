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
  init_logger
  info "This bootstrapper is going to install Zsh and Oh My Zsh via Homebrew."; # -------------------------------------------------------------------------
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

          info "Installing Zsh..."; # -------------------------------------------------------------------------
          brew install zsh

          info "Installing Oh My Zsh..."; # -------------------------------------------------------------------------
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

          info "Installing plugins..."; # -------------------------------------------------------------------------
          /bin/bash -c "$(git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting)"
          /bin/bash -c "$(git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions)"
          /bin/bash -c "$(git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions)"

          info "Making sure the proper shell is being used..."; # -------------------------------------------------------------------------
          chsh -s $(which zsh)

          info "Applying .zhrc from ../templates"; # -------------------------------------------------------------------------
          cp ./templates/.zshrc.sample $HOME/.zshrc

          if grep -q "source $HOME/env.sh" "$HOME/.zshrc"
          then
            info "Already sourcing $HOME/env.sh"
          else
            echo source $HOME/env.sh >> $HOME/.zshrc
          fi

          echo "export ZSH_THEME=pygmalion" >> $HOME/env.sh
          echo "autoload -U compinit && compinit" >> $HOME/env.sh

          source $HOME/.zshrc
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