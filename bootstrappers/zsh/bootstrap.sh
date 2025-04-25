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
  info "This bootstrapper is going to install Zsh and Oh My Zsh via Homebrew.";
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

          info "Installing Zsh...";
          brew install zsh

          info "Installing Oh My Zsh...";

          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

          info "Installing plugins...";
          /bin/bash -c "$(git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting)"
          /bin/bash -c "$(git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions)"
          /bin/bash -c "$(git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions)"

          info "Making sure the proper shell is being used...";
          
          grep -q "$(which zsh)" "/etc/shells"
          if [ $? != 0 ]
          then
            info "Registering $(which zsh) in /etc/shells..."
            sudo sh -c "echo $(which zsh) >> /etc/shells"
          fi
          
          chsh -s $(which zsh)

          info "Copying .zhrc from ./templates";
          cp ./templates/.zshrc.sample $HOME/.zshrc

          info "Copying env.sh from ./templates";
          cp ./templates/env.sh.sample $HOME/env.sh

          grep -q "autoload -U compinit && compinit" "$HOME/.zshrc"
          if [ $? != 0 ]
          then
            echo "autoload -U compinit && compinit" >> $HOME/.zshrc
          fi

          grep -q "source $HOME/env.sh" "$HOME/.zshrc"
          if [ $? != 0 ]
          then
            echo source $HOME/env.sh >> $HOME/.zshrc
          fi

          grep -q "export ZSH_THEME=pygmalion" "$HOME/env.sh"
          if [ $? != 0 ]
          then
            echo "export ZSH_THEME=pygmalion" >> $HOME/env.sh
          fi

          info "Installing fuzzy finder...";
          brew install fzf

          info "Installing fuzzy finder auto completion and key bindings...";
          $(brew --prefix)/opt/fzf/install

          info "Restart the terminal to loah Zsh."
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
