#!/bin/bash

usage() {
  cat << EOF 
Usage: $(basename "${BASH_SOURCE[0]}") install

Easy installation script for dot files.

Available options:

help      Print this help and exit.
install   Install dot files.
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  # default values of variables set from params
  flag=0
  param=''

  while :; do
    case "${1-}" in
    help) usage ;;
    -i | --install)
      install="${2-}"
      shift
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"

  return 0
}

parse_params "$@"
setup_colors

if [ "${args[*]-}" = "install" ]; then
    msg "${RED}Requiring sudo permissions to install curl unzip"
    sudo apt update
    sudo apt install curl unzip
    msg "${RED}Installation in progress:${NOFORMAT}"
    msg "${NOFORMAT}* ${GREEN}Installing Oh-my-zsh"
    curl -L -o omz-install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
    ZSH= sh omz-install.sh
    rm omz-install.sh
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting
    msg "${NOFORMAT}* ${GREEN}Installing Starship"
    curl -L -o starship-install.sh https://starship.rs/install.sh
    chmod +x starship-install.sh
    ./starship-install.sh
    rm starship-install.sh
    msg "${NOFORMAT}* ${CYAN}Copying Starship Configuration"
    mkdir $HOME/.config/
    cp .config/starship.toml $HOME/.config/starship.toml
    msg "${NOFORMAT}* ${GREEN}Installing kubecolor"
    curl -L -o kubecolor.tar.gz https://github.com/hidetatz/kubecolor/releases/download/v0.0.20/kubecolor_0.0.20_Linux_x86_64.tar.gz
    msg "${NOFORMAT}* ${CYAN}Copying kubecolor binaries"
    tar zxf kubecolor.tar.gz
    sudo mv kubecolor /usr/bin/
    rm kubecolor.tar.gz LICENSE README.md
    msg "${NOFORMAT}* ${GREEN}Installing exa (modern replacement for ls)"
    curl -L -o exa.zip https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip
    msg "${NOFORMAT}* ${CYAN}Copying exa binaries"
    unzip exa.zip
    sudo mv bin/exa /usr/bin
    mkdir $HOME/.zfunc
    mv completions/exa.zsh $HOME/.zfunc
    rm -fr bin completions man exa.zip
    msg "${NOFORMAT}* ${CYAN}Copying .zshrc"
    cp .zshrc $HOME/.zshrc
    msg "${NOFORMAT}* ${GREEN}Installing Vundle (vim plugin manager)"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    msg "${NOFORMAT}* ${CYAN}Copying .vimrc, .vimrc.bundles and .vimrc.local"
    cp .vimrc .vimrc.bundles .vimrc.bundles.local $HOME/
    msg "${RED}---------------------------------------------------------------------"
    msg "${NOFORMAT}* ${RED}NOTE: Remember to run :PluginInstall to install plugins!"
    msg "${NOFORMAT}* ${RED}Now restart the terminal"
    msg "${RED}---------------------------------------------------------------------"
    msg "${YELLOW}----${GREEN}DONE${YELLOW}----"
fi
