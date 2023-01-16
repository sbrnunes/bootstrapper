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
  info "This bootstrapper is going to install Kubectl, Krew, Kubectx and Kubens.";
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

          info 'Installing kubectl from Homebrew...'
          brew install kubectl

          grep -q "kubectl completion zsh" "$HOME/env.sh"
          if [ $? != 0 ]
          then
            echo '### kubernetes'  >> $HOME/env.sh
            echo 'source <(kubectl completion zsh)' >> $HOME/env.sh
          fi

          info 'Installing Krew...'
          (
            set -x; cd "$(mktemp -d)" &&
            OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
            ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
            KREW="krew-${OS}_${ARCH}" &&
            curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
            tar zxvf "${KREW}.tar.gz" &&
            ./"${KREW}" install krew
          )

          grep -q "KREW_ROOT" "$HOME/env.sh"
          if [ $? != 0 ]
          then
            echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> $HOME/env.sh
          fi

          source $HOME/env.sh

          kubectl krew update

          info 'Installing Kubectx and Kubens as Krew plugins...'
          kubectl krew install ctx
          kubectl krew install ns

          info 'Installing and configuring kube-ps1...'
          brew install kube-ps1

          grep -q "KUBE_PS1" "$HOME/env.sh"
          if [ $? != 0 ]
          then
            cat << 'EOM' >> $HOME/env.sh
if [[ $PROMPT == '$(kube_ps1)'* ]]; then
  echo "Kube PS1 prompt already initialized"
else
  PROMPT='$(kube_ps1)'$PROMPT
fi

KUBE_PS1_SYMBOL_ENABLE=true
KUBE_PS1_SYMBOL_COLOR=blue
KUBE_PS1_CTX_COLOR=red
KUBE_PS1_NS_COLOR=cyan
KUBE_PS1_CLUSTER_FUNCTION=$(echo "$1" | cut -d . -f1)

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --no-color'
EOM
          fi

          info 'Sourcing env.sh...'
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